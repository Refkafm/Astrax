import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:catatan_uang/core/database/database.dart' show AppDatabase;
import 'package:catatan_uang/core/database/repository.dart';

void main() {
  test(
    'encrypted DB persists after restart and fails with wrong key',
    () async {
      tz.initializeTimeZones();
      final directory = await Directory.systemTemp.createTemp(
        'finance_encryption_',
      );
      final file = File('${directory.path}/ledger.sqlite');
      AppDatabase open(String key) => AppDatabase(
        NativeDatabase(
          file,
          setup: (db) {
            expect(db.select('PRAGMA cipher'), isNotEmpty);
            db.execute("PRAGMA cipher = 'sqlcipher'");
            db.execute("PRAGMA key = '$key'");
          },
        ),
      );
      final repo = FinanceRepository(open('synthetic-test-key'));
      await repo.initialize();
      await repo.addAccount('SYNTHETIC_ACCOUNT', 'cash', 123456);
      await repo.close();
      final bytes = await file.readAsBytes();
      expect(String.fromCharCodes(bytes).contains('SYNTHETIC_ACCOUNT'), false);
      expect(
        String.fromCharCodes(bytes.take(16)),
        isNot('SQLite format 3\u0000'),
      );
      final restored = FinanceRepository(open('synthetic-test-key'));
      await restored.initialize();
      expect((await restored.snapshot()).liquid, 123456);
      await restored.close();
      final wrong = sqlite3.open(file.path);
      wrong.execute("PRAGMA cipher = 'sqlcipher'");
      wrong.execute("PRAGMA key = 'wrong-key'");
      expect(
        () => wrong.select('SELECT * FROM accounts'),
        throwsA(isA<SqliteException>()),
      );
      wrong.close();
      await directory.delete(recursive: true);
    },
  );
}
