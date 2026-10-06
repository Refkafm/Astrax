import 'dart:async';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/finance.dart';
import 'database.dart' show AppDatabase;

String dateKey(DateTime d) => day(d).toIso8601String().substring(0, 10);

DateTime parseDate(String value) => DateTime.parse('${value}T00:00:00Z');

class FinanceRepository {
  final AppDatabase db;
  final DateTime Function() clock;
  final _changes = StreamController<void>.broadcast();
  FinanceRepository(this.db, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  String newId() => const Uuid().v4();
  Future<List<QueryRow>> rows(String sql, [List<Object> args = const []]) => db
      .customSelect(
        sql,
        variables: args
            .map(
              (v) =>
                  v is int ? Variable<int>(v) : Variable<String>(v as String),
            )
            .toList(),
      )
      .get();
  Future<void> sql(String query, [List<Object?> args = const []]) =>
      db.customStatement(query, args);
  Future<T> mutate<T>(Future<T> Function() action) async {
    final result = await db.transaction(action);
    _changes.add(null);
    return result;
  }

  Future<void> initialize() async {
    await db.transaction(() async {
      await sql('INSERT OR IGNORE INTO settings(id,started) VALUES(1,?)', [
        dateKey(profileNow('Asia/Jakarta', clock())),
      ]);
      for (final type in ['expense', 'income']) {
        for (final name
            in type == 'expense' ? expenseCategories : incomeCategories) {
          await sql(
            'INSERT OR IGNORE INTO categories(name,type,is_system) VALUES(?,?,1)',
            [name, type],
          );
        }
      }
      await _reconcile();
    });
  }

  Future<void> refresh() => mutate(_reconcile);
  Future<void> _reconcile() async {
    final s = (await rows('SELECT * FROM settings')).single.data;
    final p = periodAt(
      profileNow(s['zone'] as String, clock()),
      s['anchor'] as int,
      started: parseDate(s['started'] as String),
    );
    final existing = await rows('SELECT * FROM budgets WHERE start=?', [
      dateKey(p.start),
    ]);
    if (existing.isEmpty) {
      final previous = await rows(
        'SELECT * FROM budgets WHERE start<? ORDER BY start DESC LIMIT 1',
        [dateKey(p.start)],
      );
      if (previous.isNotEmpty) {
        await sql(
          'INSERT INTO budgets(start,end_date,total,updated) VALUES(?,?,?,?)',
          [
            dateKey(p.start),
            dateKey(p.end),
            previous.single.data['total'],
            clock().millisecondsSinceEpoch,
          ],
        );
        await sql(
          'INSERT INTO allocations SELECT ?,category,amount FROM allocations WHERE period=?',
          [dateKey(p.start), previous.single.data['start']],
        );
      }
    }
    final until = anchored(p.end.year, p.end.month + 1, s['anchor'] as int);
    for (final row in await rows('SELECT * FROM templates WHERE active=1')) {
      final t = row.data;
      final first = parseDate(t['first_date'] as String);
      var due = first;
      var index = 0;
      while (due.isBefore(until)) {
        await sql(
          'INSERT OR IGNORE INTO bills(id,template,due) VALUES(?,?,?)',
          ['${t['id']}:${dateKey(due)}', t['id'], dateKey(due)],
        );
        index++;
        due = t['cadence'] == 'weekly'
            ? first.add(Duration(days: index * 7))
            : anchored(first.year, first.month + index, first.day);
      }
    }
  }

  Stream<FinanceSnapshot> watch() async* {
    yield await snapshot();
    await for (final _ in _changes.stream) {
      yield await snapshot();
    }
  }

  Future<FinanceSnapshot> snapshot() => db.transaction(() async {
    final settings = (await rows('SELECT * FROM settings')).single.data;
    final zone = settings['zone'] as String;
    final period = periodAt(
      profileNow(zone, clock()),
      settings['anchor'] as int,
      started: parseDate(settings['started'] as String),
    );
    final accounts = (await rows('SELECT * FROM accounts ORDER BY opened,id'))
        .map((r) {
          final d = r.data;
          return Account(
            d['id'] as String,
            d['name'] as String,
            d['type'] as String,
            d['opening'] as int,
            DateTime.fromMillisecondsSinceEpoch(d['opened'] as int),
            archived: d['archived'] == 1,
          );
        })
        .toList();
    final entries =
        (await rows(
          'SELECT * FROM entries WHERE deleted IS NULL AND occurred<=? ORDER BY occurred DESC,id DESC',
          [clock().millisecondsSinceEpoch],
        )).map((r) {
          final d = r.data;
          return Entry(
            id: d['id'] as String,
            type: d['type'] as String,
            account: d['account'] as String,
            amount: d['amount'] as int,
            occurred: DateTime.fromMillisecondsSinceEpoch(d['occurred'] as int),
            businessDate: parseDate(d['business_date'] as String),
            category: d['category'] as String,
            merchant: d['merchant'] as String,
            note: d['note'] as String,
            destination: d['destination'] as String?,
            refundOf: d['refund_of'] as String?,
            parent: d['parent'] as String?,
          );
        }).toList();
    final bills =
        (await rows(
          'SELECT b.id,b.due,b.state,b.template,t.active,t.name,t.account,t.category,t.direction,COALESCE(b.amount_override,t.amount) AS amount FROM bills b JOIN templates t ON b.template=t.id ORDER BY b.due,b.id',
        )).map((r) {
          final d = r.data;
          return Bill(
            d['id'] as String,
            d['name'] as String,
            d['account'] as String,
            d['category'] as String,
            d['direction'] as String,
            d['state'] as String,
            d['amount'] as int,
            parseDate(d['due'] as String),
            templateId: d['template'] as String,
            templateActive: (d['active'] as int) == 1,
          );
        }).toList();
    final budget = await rows('SELECT total FROM budgets WHERE start=?', [
      dateKey(period.start),
    ]);
    final allocations = await rows('SELECT * FROM allocations WHERE period=?', [
      dateKey(period.start),
    ]);
    return FinanceSnapshot(
      accounts: accounts,
      categories:
          (await rows('SELECT * FROM categories ORDER BY is_system DESC,name'))
              .map(
                (r) => FinanceCategory(
                  r.read<String>('name'),
                  r.read<String>('type'),
                  archived: r.read<int>('archived') == 1,
                  isSystem: r.read<int>('is_system') == 1,
                ),
              )
              .toList(),
      entries: entries,
      bills: bills,
      budget: budget.firstOrNull?.read<int>('total'),
      allocations: {
        for (final r in allocations)
          r.read<String>('category'): r.read<int>('amount'),
      },
      period: period,
      zone: zone,
      anchor: settings['anchor'] as int,
      onboarded: settings['onboarded'] == 1,
      now: clock(),
      started: parseDate(settings['started'] as String),
    );
  });
  Future<void> completeOnboarding({
    required String zone,
    required int anchor,
  }) => mutate(() async {
    if (!['Asia/Jakarta', 'Asia/Makassar', 'Asia/Jayapura'].contains(zone) ||
        anchor < 1 ||
        anchor > 31) {
      throw StateError('Periode atau zona waktu tidak valid.');
    }
    await sql(
      'UPDATE settings SET zone=?,anchor=?,started=?,onboarded=1 WHERE id=1',
      [zone, anchor, dateKey(profileNow(zone, clock()))],
    );
    await _reconcile();
  });
  Future<String> addAccount(
    String name,
    String type,
    int opening, {
    String? command,
  }) => mutate(() async {
    if (name.trim().isEmpty ||
        opening < 0 ||
        opening > maxMoney ||
        !['bank', 'e_wallet', 'cash'].contains(type)) {
      throw StateError('Nama, tipe, atau saldo awal tidak valid.');
    }
    final cmd = command ?? newId();
    final receipt = await rows('SELECT entity FROM receipts WHERE command=?', [
      cmd,
    ]);
    if (receipt.isNotEmpty) return receipt.single.read<String>('entity');
    final id = newId();
    await sql(
      'INSERT INTO accounts(id,name,type,opening,opened) VALUES(?,?,?,?,?)',
      [id, name.trim(), type, opening, clock().millisecondsSinceEpoch],
    );
    await sql('INSERT INTO receipts VALUES(?,?,?)', [cmd, id, 'account']);
    return id;
  });
  Future<void> saveBudget(int total, Map<String, int> allocations) =>
      mutate(() async {
        if (total < 0 ||
            total > maxMoney ||
            allocations.values.any((v) => v < 0) ||
            allocations.values.fold(0, (a, b) => a + b) > total) {
          throw StateError('Jumlah alokasi tidak boleh melebihi batas total.');
        }
        final s = await snapshot();
        if (allocations.keys.any(
          (name) => !s.categoryNames('expense').contains(name),
        )) {
          throw StateError('Alokasi harus memakai kategori pengeluaran aktif.');
        }

        await sql(
          'INSERT INTO budgets(start,end_date,total,updated) VALUES(?,?,?,?) ON CONFLICT(start) DO UPDATE SET total=excluded.total,revision=revision+1,updated=excluded.updated',
          [
            dateKey(s.period.start),
            dateKey(s.period.end),
            total,
            clock().millisecondsSinceEpoch,
          ],
        );
        await sql('DELETE FROM allocations WHERE period=?', [
          dateKey(s.period.start),
        ]);
        for (final e in allocations.entries) {
          await sql('INSERT INTO allocations VALUES(?,?,?)', [
            dateKey(s.period.start),
            e.key,
            e.value,
          ]);
        }
      });
  Future<String> post({
    required String command,
    required String type,
    required String account,
    required int amount,
    required DateTime occurred,
    String category = '',
    String merchant = '',
    String note = '',
    String? destination,
    int fee = 0,
    String? refundOf,
    String? billId,
    String? editId,
  }) => mutate(() async {
    final receipt = await rows('SELECT entity FROM receipts WHERE command=?', [
      command,
    ]);
    if (receipt.isNotEmpty) return receipt.single.read<String>('entity');
    final s = await snapshot();
    if (![
          'expense',
          'income',
          'transfer',
          'refund',
          'adjustment',
        ].contains(type) ||
        amount == 0 ||
        amount.abs() > maxMoney ||
        (type != 'adjustment' && amount < 0) ||
        occurred.isAfter(clock())) {
      throw StateError('Nominal atau waktu transaksi tidak valid.');
    }
    if (type == 'transfer' && (destination == null || destination == account)) {
      throw StateError('Pilih dua akun yang berbeda.');
    }
    if (type != 'transfer' && destination != null) {
      throw StateError('Akun tujuan hanya untuk transfer.');
    }
    for (final id in [account, ?destination]) {
      final a = s.accounts.where((a) => a.id == id).firstOrNull;
      if (a == null || a.archived || occurred.isBefore(a.opened)) {
        throw StateError(
          'Waktu transaksi tidak boleh sebelum saldo awal akun.',
        );
      }
    }
    if (['expense', 'income'].contains(type)) {
      final existing = s.entries.where((e) => e.id == editId).firstOrNull;
      if (!s.categoryNames(type).contains(category) &&
          existing?.category != category) {
        throw StateError('Pilih kategori aktif yang sesuai.');
      }
    }
    if (fee < 0 || fee > maxMoney || (fee > 0 && type != 'transfer')) {
      throw StateError('Biaya transfer tidak valid.');
    }
    if (type == 'adjustment' && note.trim().isEmpty) {
      throw StateError('Isi alasan penyesuaian saldo.');
    }
    if (type == 'refund') {
      final original = s.entries
          .where((e) => e.id == refundOf && e.type == 'expense')
          .firstOrNull;
      final refunded = s.entries
          .where((e) => e.refundOf == refundOf && e.id != editId)
          .fold(0, (a, e) => a + e.amount);
      if (original == null ||
          amount + refunded > original.amount ||
          occurred.isBefore(original.occurred)) {
        throw StateError(
          'Refund harus setelah pengeluaran dan tidak melebihi nominal asal.',
        );
      }
      category = original.category;
    }
    if (editId != null) {
      final children = s.entries
          .where((e) => e.parent == editId)
          .map((e) => e.id)
          .toSet();
      if (s.entries.any((e) => children.contains(e.refundOf))) {
        throw StateError(
          'Batalkan refund biaya sebelum mengedit transfer asal.',
        );
      }
      if (s.entries.any(
        (e) => e.refundOf == editId && occurred.isAfter(e.occurred),
      )) {
        throw StateError('Tanggal pengeluaran tidak boleh setelah refund.');
      }
      final original = s.entries.where((e) => e.id == editId).firstOrNull;
      if (original == null || original.type != type) {
        throw StateError('Jenis transaksi tidak dapat diubah saat edit.');
      }
      if (original.parent != null) {
        throw StateError('Edit biaya melalui transaksi transfer asal.');
      }
      if (s.entries
              .where((e) => e.refundOf == editId)
              .fold(0, (sum, e) => sum + e.amount) >
          amount) {
        throw StateError(
          'Nominal tidak boleh kurang dari refund yang sudah dicatat.',
        );
      }
      await sql(
        "UPDATE bills SET state='unpaid',entry=NULL WHERE entry=? OR entry IN (SELECT id FROM entries WHERE parent=?)",
        [editId, editId],
      );
      await sql('UPDATE entries SET deleted=? WHERE parent=?', [
        clock().millisecondsSinceEpoch,
        editId,
      ]);
    }
    final id = editId ?? newId();
    final business = dateKey(profileNow(s.zone, occurred));
    if (editId == null) {
      await sql(
        'INSERT INTO entries(id,command,type,account,destination,amount,category,merchant,note,occurred,business_date,zone,refund_of) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          id,
          command,
          type,
          account,
          destination,
          amount,
          category,
          merchant.trim(),
          note.trim(),
          occurred.millisecondsSinceEpoch,
          business,
          s.zone,
          refundOf,
        ],
      );
    } else {
      await sql(
        'UPDATE entries SET account=?,destination=?,amount=?,category=?,merchant=?,note=?,occurred=?,business_date=? WHERE id=?',
        [
          account,
          destination,
          amount,
          category,
          merchant.trim(),
          note.trim(),
          occurred.millisecondsSinceEpoch,
          business,
          id,
        ],
      );
      await sql('UPDATE entries SET category=? WHERE refund_of=?', [
        category,
        id,
      ]);
    }
    if (fee > 0) {
      await sql(
        "INSERT INTO entries(id,command,type,account,amount,category,occurred,business_date,zone,parent) VALUES(?,?,'expense',?,?,'Biaya admin',?,?,?,?)",
        [
          newId(),
          '$command:fee',
          account,
          fee,
          occurred.millisecondsSinceEpoch,
          business,
          s.zone,
          id,
        ],
      );
    }
    if (billId != null) {
      final bill = s.bills
          .where((b) => b.id == billId && b.state == 'unpaid')
          .firstOrNull;
      if (bill == null || bill.direction != type) {
        throw StateError(
          'Tagihan ini sudah diselesaikan atau jenis transaksi tidak cocok.',
        );
      }
      await sql("UPDATE bills SET state='paid',entry=? WHERE id=?", [
        id,
        billId,
      ]);
    }
    await sql('INSERT INTO receipts VALUES(?,?,?)', [
      command,
      id,
      editId == null ? 'post' : 'edit',
    ]);
    return id;
  });
  Future<String> adjustBalance({
    required String command,
    required String account,
    required int knownBalance,
    required String reason,
  }) => mutate(() async {
    final receipt = await rows('SELECT entity FROM receipts WHERE command=?', [
      command,
    ]);
    if (receipt.isNotEmpty) return receipt.single.read<String>('entity');
    if (knownBalance < 0 || knownBalance > maxMoney) {
      throw StateError('Saldo yang diketahui tidak valid.');
    }
    final s = await snapshot();
    final a = s.accounts.firstWhere((a) => a.id == account);
    final difference = knownBalance - s.balance(a);
    if (difference == 0) {
      throw StateError('Saldo sudah sesuai; tidak ada selisih untuk dicatat.');
    }
    return post(
      command: command,
      type: 'adjustment',
      account: account,
      amount: difference,
      occurred: clock(),
      note: reason,
    );
  });

  Future<void> _requireActiveEntryAccounts(String id) async {
    final archived = await rows(
      'SELECT a.id FROM accounts a JOIN entries e ON (e.account=a.id OR e.destination=a.id) WHERE e.id=? AND a.archived=1',
      [id],
    );
    if (archived.isNotEmpty) {
      throw StateError(
        'Aktifkan kembali akun arsip sebelum mengubah riwayatnya.',
      );
    }
  }

  Future<void> deleteEntry(String id) => mutate(() async {
    await _requireActiveEntryAccounts(id);
    if ((await rows(
      'SELECT id FROM entries WHERE (refund_of=? OR refund_of IN (SELECT id FROM entries WHERE parent=?)) AND deleted IS NULL',
      [id, id],
    )).isNotEmpty) {
      throw StateError('Batalkan refund sebelum menghapus pengeluaran asal.');
    }
    if ((await rows('SELECT parent FROM entries WHERE id=?', [
          id,
        ])).single.data['parent'] !=
        null) {
      throw StateError('Hapus biaya melalui transaksi transfer asal.');
    }
    await sql(
      "UPDATE bills SET state='unpaid',entry=NULL WHERE entry=? OR entry IN (SELECT id FROM entries WHERE parent=?)",
      [id, id],
    );
    await sql('UPDATE entries SET deleted=? WHERE id=? OR parent=?', [
      clock().millisecondsSinceEpoch,
      id,
      id,
    ]);
  });
  Future<void> undoDelete(String id) => mutate(() async {
    await _requireActiveEntryAccounts(id);
    final deleted = await rows('SELECT deleted FROM entries WHERE id=?', [id]);
    final at = deleted.single.data['deleted'] as int?;
    if (at == null ||
        clock().millisecondsSinceEpoch - at >
            const Duration(days: 7).inMilliseconds) {
      throw StateError('Batas waktu pemulihan sudah lewat.');
    }
    await sql('UPDATE entries SET deleted=NULL WHERE id=? OR parent=?', [
      id,
      id,
    ]);
  });
  Future<void> addTemplate({
    required String name,
    required String account,
    required String category,
    required String direction,
    required int amount,
    required String cadence,
    required DateTime first,
  }) => mutate(() async {
    if (name.trim().isEmpty || amount <= 0 || amount > maxMoney) {
      throw StateError('Nama dan nominal tagihan wajib diisi.');
    }
    final snapshotData = await snapshot();
    if (!snapshotData.activeAccounts.any((a) => a.id == account) ||
        !snapshotData.categoryNames(direction).contains(category)) {
      throw StateError('Pilih akun dan kategori aktif.');
    }
    await sql(
      'INSERT INTO templates(id,name,account,category,direction,amount,cadence,first_date) VALUES(?,?,?,?,?,?,?,?)',
      [
        newId(),
        name.trim(),
        account,
        category,
        direction,
        amount,
        cadence,
        dateKey(first),
      ],
    );
    await _reconcile();
  });
  Future<void> updateBillAmount(String id, int amount) => mutate(() async {
    if (amount < 1 || amount > maxMoney) {
      throw StateError('Nominal tagihan tidak valid.');
    }
    final bill = (await rows('SELECT state FROM bills WHERE id=?', [
      id,
    ])).firstOrNull;
    if (bill == null || bill.data['state'] != 'unpaid') {
      throw StateError('Hanya tagihan belum dibayar yang dapat diubah.');
    }
    await sql('UPDATE bills SET amount_override=? WHERE id=?', [amount, id]);
  });

  Future<void> deactivateTemplate(String id, {required bool skipFuture}) =>
      mutate(() async {
        final template = (await rows(
          'SELECT id FROM templates WHERE id=? AND active=1',
          [id],
        )).firstOrNull;
        if (template == null) throw StateError('Jadwal sudah tidak aktif.');
        await sql('UPDATE templates SET active=0 WHERE id=?', [id]);
        if (skipFuture) {
          final settings = (await rows('SELECT zone FROM settings WHERE id=1'))
              .single
              .data;
          final today = dateKey(
            profileNow(settings['zone'] as String, clock()),
          );
          await sql(
            "UPDATE bills SET state='skipped' WHERE template=? AND state='unpaid' AND due>?",
            [id, today],
          );
        }
      });

  Future<void> skipBill(String id) => mutate(
    () => sql(
      "UPDATE bills SET state='skipped' WHERE id=? AND state='unpaid'",
      [id],
    ),
  );
  Future<void> linkBill(String billId, String entryId) => mutate(() async {
    final s = await snapshot();
    final b = s.bills
        .where((b) => b.id == billId && b.state == 'unpaid')
        .firstOrNull;
    final e = s.entries.where((e) => e.id == entryId).firstOrNull;
    if (b == null || e == null || b.direction != e.type) {
      throw StateError('Pilih transaksi yang sesuai.');
    }
    await sql("UPDATE bills SET state='paid',entry=? WHERE id=?", [
      entryId,
      billId,
    ]);
  });
  Future<void> renameAccount(String id, String name) => mutate(() async {
    if (name.trim().isEmpty || name.trim().length > 80) {
      throw StateError('Isi nama akun, maksimal 80 karakter.');
    }
    await sql('UPDATE accounts SET name=? WHERE id=?', [name.trim(), id]);
  });
  Future<void> archiveAccount(String id, bool archived) => mutate(() async {
    final s = await snapshot();
    final account = s.accounts.firstWhere((a) => a.id == id);
    if (archived) {
      if (s.balance(account) != 0) {
        throw StateError('Saldo akun harus nol sebelum diarsipkan.');
      }
      if ((await rows(
        'SELECT id FROM templates WHERE account=? AND active=1 LIMIT 1',
        [id],
      )).isNotEmpty) {
        throw StateError('Akun masih digunakan jadwal tagihan atau pemasukan.');
      }
    }
    await sql('UPDATE accounts SET archived=? WHERE id=?', [
      archived ? 1 : 0,
      id,
    ]);
  });
  Future<void> deleteAccount(String id) => mutate(() async {
    final references = await rows(
      'SELECT id FROM entries WHERE account=? OR destination=? UNION ALL SELECT id FROM templates WHERE account=? LIMIT 1',
      [id, id, id],
    );
    if (references.isNotEmpty) {
      throw StateError(
        'Akun memiliki riwayat atau jadwal. Gunakan arsip setelah saldo nol.',
      );
    }
    await sql('DELETE FROM accounts WHERE id=?', [id]);
  });
  Future<void> addCategory(String name, String type) => mutate(() async {
    final trimmed = name.trim();
    if (trimmed.isEmpty ||
        trimmed.length > 60 ||
        !['expense', 'income'].contains(type)) {
      throw StateError('Isi nama kategori, maksimal 60 karakter.');
    }
    final all = await rows('SELECT name FROM categories WHERE type=?', [type]);
    if (all.any(
      (r) => r.read<String>('name').toLowerCase() == trimmed.toLowerCase(),
    )) {
      throw StateError(
        'Kategori dengan nama ini sudah ada, termasuk dalam arsip.',
      );
    }
    await sql('INSERT INTO categories(name,type) VALUES(?,?)', [trimmed, type]);
  });
  Future<void> archiveCategory(String name, String type, bool archived) =>
      mutate(() async {
        if (archived &&
            (name == 'Belum dikategorikan' ||
                name == 'Biaya admin' ||
                (type == 'income' && name == 'Gaji'))) {
          throw StateError('Kategori ini diperlukan sebagai kategori bawaan.');
        }
        final s = await snapshot();
        if (archived &&
            ((s.allocations[name] ?? 0) > 0 ||
                (await rows(
                  'SELECT id FROM templates WHERE category=? AND direction=? LIMIT 1',
                  [name, type],
                )).isNotEmpty)) {
          throw StateError(
            'Kategori masih dipakai alokasi budget atau jadwal. Hapus alokasi terlebih dahulu; jadwal harus tetap memiliki kategori aktif.',
          );
        }
        await sql('UPDATE categories SET archived=? WHERE name=? AND type=?', [
          archived ? 1 : 0,
          name,
          type,
        ]);
      });

  Future<void> close() async {
    await _changes.close();
    await db.close();
  }
}
