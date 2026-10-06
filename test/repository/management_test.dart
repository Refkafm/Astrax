import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:catatan_uang/core/database/database.dart' show AppDatabase;
import 'package:catatan_uang/core/database/repository.dart';

void main() {
  late FinanceRepository repo;
  late String account;
  final now = DateTime.utc(2026, 10, 5, 2);
  setUp(() async {
    tz.initializeTimeZones();
    repo = FinanceRepository(
      AppDatabase(NativeDatabase.memory()),
      clock: () => now,
    );
    await repo.initialize();
    account = await repo.addAccount('Tunai', 'cash', 0);
  });
  tearDown(() async => repo.close());
  test(
    'bill amount override and schedule deactivation preserve overdue items',
    () async {
      await repo.addTemplate(
        name: 'Sewa',
        account: account,
        category: 'Tempat tinggal',
        direction: 'expense',
        amount: 100,
        cadence: 'monthly',
        first: DateTime.utc(2026, 9, 5),
      );
      var bills = (await repo.snapshot()).bills;
      final today = bills.firstWhere((b) => b.due == DateTime.utc(2026, 10, 5));
      final overdue = bills.firstWhere(
        (b) => b.due == DateTime.utc(2026, 9, 5),
      );
      final future = bills.firstWhere(
        (b) => b.due == DateTime.utc(2026, 11, 5),
      );
      await repo.updateBillAmount(today.id, 250);
      bills = (await repo.snapshot()).bills;
      expect(bills.firstWhere((b) => b.id == today.id).amount, 250);
      expect(bills.firstWhere((b) => b.id == overdue.id).amount, 100);
      await repo.deactivateTemplate(today.templateId!, skipFuture: true);
      await repo.refresh();
      bills = (await repo.snapshot()).bills;
      expect(bills.firstWhere((b) => b.id == future.id).state, 'skipped');
      expect(bills.firstWhere((b) => b.id == overdue.id).state, 'unpaid');
      expect(bills.firstWhere((b) => b.id == today.id).amount, 250);
      expect(bills.length, 3);
      await expectLater(
        repo.deactivateTemplate(today.templateId!, skipFuture: true),
        throwsStateError,
      );
    },
  );
  test(
    'custom category can post, archive preserves history, new use rejected',
    () async {
      await repo.addCategory('Hobi', 'expense');
      await repo.post(
        command: 'one',
        type: 'expense',
        account: account,
        amount: 100,
        occurred: now,
        category: 'Hobi',
      );
      await repo.archiveCategory('Hobi', 'expense', true);
      final s = await repo.snapshot();
      expect(s.entries.single.category, 'Hobi');
      expect(s.categoryNames('expense'), isNot(contains('Hobi')));
      await expectLater(
        repo.post(
          command: 'two',
          type: 'expense',
          account: account,
          amount: 100,
          occurred: now,
          category: 'Hobi',
        ),
        throwsStateError,
      );
      await repo.archiveCategory('Hobi', 'expense', false);
      expect(
        (await repo.snapshot()).categoryNames('expense'),
        contains('Hobi'),
      );
      await expectLater(
        repo.addCategory(' hObI ', 'expense'),
        throwsStateError,
      );
    },
  );
  test(
    'archive requires zero balance and preserves historical account name',
    () async {
      await repo.post(
        command: 'income',
        type: 'income',
        account: account,
        amount: 100,
        occurred: now,
        category: 'Gaji',
      );
      await expectLater(repo.archiveAccount(account, true), throwsStateError);
      await repo.post(
        command: 'expense',
        type: 'expense',
        account: account,
        amount: 100,
        occurred: now,
        category: 'Lainnya',
      );
      await repo.renameAccount(account, 'Dompet');
      await repo.archiveAccount(account, true);
      final s = await repo.snapshot();
      expect(s.activeAccounts, isEmpty);
      expect(s.entries.length, 2);
      expect(s.accountName(account), 'Dompet');
      await expectLater(repo.deleteEntry(s.entries.first.id), throwsStateError);
      await expectLater(repo.deleteAccount(account), throwsStateError);
      await expectLater(
        repo.post(
          command: 'new',
          type: 'expense',
          account: account,
          amount: 1,
          occurred: now,
          category: 'Lainnya',
        ),
        throwsStateError,
      );
      await repo.archiveAccount(account, false);
      expect((await repo.snapshot()).activeAccounts.length, 1);
    },
  );
  test(
    'unused account deletes; template blocks account and category archive',
    () async {
      final unused = await repo.addAccount('Unused', 'bank', 123);
      await repo.deleteAccount(unused);
      expect((await repo.snapshot()).accounts.length, 1);
      await repo.addTemplate(
        name: 'Kos',
        account: account,
        category: 'Tempat tinggal',
        direction: 'expense',
        amount: 100,
        cadence: 'monthly',
        first: now,
      );
      await expectLater(repo.archiveAccount(account, true), throwsStateError);
      await expectLater(
        repo.archiveCategory('Tempat tinggal', 'expense', true),
        throwsStateError,
      );
    },
  );
  test(
    'migration v1 to v3 preserves balances, transactions and relations',
    () async {
      final dir = await Directory.systemTemp.createTemp('finance_migration_');
      final file = File('${dir.path}/old.sqlite');
      final raw = sqlite3.open(file.path);
      raw.execute(await File('test/fixtures/schema_v1.sql').readAsString());
      raw.execute("INSERT INTO settings(id,started) VALUES(1,'2026-10-05')");
      raw.execute(
        "INSERT INTO accounts VALUES('a','Old account','cash',1000,0)",
      );
      raw.execute(
        "INSERT INTO entries(id,command,type,account,amount,category,occurred,business_date,zone) VALUES('e','c','expense','a',100,'Lainnya',1,'2026-10-05','Asia/Jakarta')",
      );
      raw.execute('PRAGMA user_version=1');
      raw.close();
      await repo.close();
      final upgraded = FinanceRepository(
        AppDatabase(NativeDatabase(file)),
        clock: () => now,
      );
      repo = upgraded;
      try {
        await upgraded.initialize();
        final s = await upgraded.snapshot();
        expect(s.liquid, 900);
        expect(s.entries.single.id, 'e');
        expect(s.accounts.single.archived, false);
        expect(s.categories.length, 19);
        expect((await upgraded.rows('PRAGMA foreign_key_check')), isEmpty);
      } finally {
        // tearDown closes the current repository; Unix permits unlinking the open test file.
        await dir.delete(recursive: true);
      }
    },
  );
  test(
    'migration v2 to v3 preserves existing schedule and occurrence',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'finance_migration_v2_',
      );
      final file = File('${dir.path}/old.sqlite');
      final raw = sqlite3.open(file.path);
      raw.execute(await File('test/fixtures/schema_v1.sql').readAsString());
      raw.execute(
        'ALTER TABLE accounts ADD COLUMN archived INTEGER NOT NULL DEFAULT 0',
      );
      raw.execute(
        "CREATE TABLE categories (name TEXT NOT NULL, type TEXT NOT NULL, archived INTEGER NOT NULL DEFAULT 0, is_system INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(name,type))",
      );
      raw.execute("INSERT INTO settings(id,started) VALUES(1,'2026-10-05')");
      raw.execute(
        "INSERT INTO accounts(id,name,type,opening,opened) VALUES('a','Tunai','cash',1000,0)",
      );
      raw.execute(
        "INSERT INTO templates VALUES('t','Sewa','a','Tempat tinggal','expense',100,'monthly','2026-10-05')",
      );
      raw.execute(
        "INSERT INTO bills(id,template,due) VALUES('b','t','2026-10-05')",
      );
      raw.execute('PRAGMA user_version=2');
      raw.close();
      await repo.close();
      repo = FinanceRepository(
        AppDatabase(NativeDatabase(file)),
        clock: () => now,
      );
      try {
        await repo.initialize();
        final bill = (await repo.snapshot()).bills.firstWhere(
          (b) => b.id == 'b',
        );
        expect(bill.amount, 100);
        expect(bill.templateActive, true);
        await repo.updateBillAmount('b', 125);
        expect(
          (await repo.snapshot()).bills.firstWhere((b) => b.id == 'b').amount,
          125,
        );
        expect((await repo.rows('PRAGMA foreign_key_check')), isEmpty);
      } finally {
        await dir.delete(recursive: true);
      }
    },
  );
}
