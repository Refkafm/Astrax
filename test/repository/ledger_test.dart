import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:catatan_uang/core/database/database.dart' show AppDatabase;
import 'package:catatan_uang/core/database/repository.dart';

void main() {
  late FinanceRepository repo;
  late DateTime now;
  late String bank, wallet;
  setUp(() async {
    tz.initializeTimeZones();
    now = DateTime.utc(2026, 10, 12, 2);
    repo = FinanceRepository(
      AppDatabase(NativeDatabase.memory()),
      clock: () => now,
    );
    await repo.initialize();
    bank = await repo.addAccount('Bank', 'bank', 6000000);
    wallet = await repo.addAccount('Wallet', 'e_wallet', 0);
    now = now.add(const Duration(minutes: 1));
    await repo.saveBudget(4000000, {});
  });
  tearDown(() async => repo.close());
  Future<String> post(
    String command,
    String type,
    int amount, {
    String? destination,
    int fee = 0,
    String? bill,
    String? refund,
  }) => repo.post(
    command: command,
    type: type,
    account: bank,
    amount: amount,
    occurred: now,
    category: type == 'income' ? 'Gaji' : 'Belum dikategorikan',
    destination: destination,
    fee: fee,
    billId: bill,
    refundOf: refund,
  );
  test('AC02 expense updates source-of-truth balances', () async {
    await post('expense', 'expense', 75000);
    final s = await repo.snapshot();
    expect(s.liquid, 5925000);
    expect(s.expense, 75000);
  });
  test('AC03 atomic transfer with fee and command replay', () async {
    for (var i = 0; i < 10; i++) {
      await post(
        'transfer',
        'transfer',
        1000000,
        destination: wallet,
        fee: 2500,
      );
    }
    final s = await repo.snapshot();
    expect(s.liquid, 5997500);
    expect(s.expense, 2500);
    expect(s.balance(s.accounts.firstWhere((a) => a.id == wallet)), 1000000);
    expect(s.entries.length, 2);
  });
  test('AC21 failed bill association rolls back entire transfer', () async {
    await expectLater(
      post(
        'bad',
        'transfer',
        100000,
        destination: wallet,
        fee: 2500,
        bill: 'missing',
      ),
      throwsStateError,
    );
    expect((await repo.snapshot()).entries, isEmpty);
  });
  test(
    'AC10 AC15 bill payment releases reserve; deletion reopens bill',
    () async {
      await post('old', 'expense', 1000000);
      await repo.addTemplate(
        name: 'Kos',
        account: bank,
        category: 'Tempat tinggal',
        direction: 'expense',
        amount: 1000000,
        cadence: 'monthly',
        first: DateTime.utc(2026, 10, 15),
      );
      final before = await repo.snapshot();
      expect(before.safe!.amount, 2000000);
      final bill = before.bills.first;
      final id = await post('pay', 'expense', 1000000, bill: bill.id);
      final after = await repo.snapshot();
      expect(after.reserve, 0);
      expect(after.safe!.amount, before.safe!.amount);
      await repo.deleteEntry(id);
      expect((await repo.snapshot()).reserve, 1000000);
    },
  );
  test(
    'AC16 cross-period refund uses date of receipt; refund bounds',
    () async {
      final id = await post('original', 'expense', 100000);
      now = DateTime.utc(2026, 11, 2, 2);
      await repo.refresh();
      await post('refund', 'refund', 70000, refund: id);
      final s = await repo.snapshot();
      expect(s.expense, -70000);
      expect(s.liquid, 5970000);
      await expectLater(
        post('too-much', 'refund', 40000, refund: id),
        throwsStateError,
      );
      await expectLater(repo.deleteEntry(id), throwsStateError);
    },
  );
  test('BILL-02 recurrence idempotence and original monthly anchor', () async {
    await repo.addTemplate(
      name: 'Langganan',
      account: bank,
      category: 'Hiburan & langganan',
      direction: 'expense',
      amount: 10000,
      cadence: 'monthly',
      first: DateTime.utc(2026, 1, 31),
    );
    await repo.refresh();
    await repo.refresh();
    final bills = (await repo.snapshot()).bills;
    expect(bills.where((b) => b.due == DateTime.utc(2026, 2, 28)).length, 1);
    expect(bills.where((b) => b.due == DateTime.utc(2026, 3, 31)).length, 1);
    expect(bills.map((b) => b.id).toSet().length, bills.length);
  });
  test('SAFE scheduled income never changes liquid or reserve', () async {
    await repo.addTemplate(
      name: 'Gaji',
      account: bank,
      category: 'Gaji',
      direction: 'income',
      amount: 5000000,
      cadence: 'monthly',
      first: DateTime.utc(2026, 10, 13),
    );
    final s = await repo.snapshot();
    expect(s.liquid, 6000000);
    expect(s.reserve, 0);
  });
  test(
    'TXN-04 and ACC-08 reject future and pre-opening transactions',
    () async {
      await expectLater(
        repo.post(
          command: 'future',
          type: 'expense',
          account: bank,
          amount: 1,
          occurred: now.add(const Duration(days: 1)),
          category: 'Lainnya',
        ),
        throwsStateError,
      );
      await expectLater(
        repo.post(
          command: 'past',
          type: 'expense',
          account: bank,
          amount: 1,
          occurred: now.subtract(const Duration(days: 1)),
          category: 'Lainnya',
        ),
        throwsStateError,
      );
    },
  );
  test('BUD-02 invalid allocation leaves previous budget untouched', () async {
    await expectLater(
      repo.saveBudget(100, {'Makan & minum': 101}),
      throwsStateError,
    );
    expect((await repo.snapshot()).budget, 4000000);
  });
  test(
    'ACC-03 adjustment uses current ledger atomically and is idempotent',
    () async {
      await post('expense-first', 'expense', 50000);
      for (var i = 0; i < 2; i++) {
        await repo.adjustBalance(
          command: 'adjust',
          account: bank,
          knownBalance: 5900000,
          reason: 'Saldo diperiksa',
        );
      }
      final s = await repo.snapshot();
      expect(s.liquid, 5900000);
      expect(s.expense, 50000);
      expect(
        s.entries.where((e) => e.type == 'adjustment').single.amount,
        -50000,
      );
    },
  );
}
