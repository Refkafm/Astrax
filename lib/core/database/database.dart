import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../platform/storage_policy.dart';
part 'database.g.dart';

@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);
  @override
  int get schemaVersion => 3;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await customStatement(
          'ALTER TABLE accounts ADD COLUMN archived INTEGER NOT NULL DEFAULT 0 CHECK(archived IN (0,1))',
        );
        await customStatement(
          "CREATE TABLE categories (name TEXT NOT NULL, type TEXT NOT NULL CHECK(type IN ('expense','income')), archived INTEGER NOT NULL DEFAULT 0 CHECK(archived IN (0,1)), is_system INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(name,type))",
        );
      }
      if (from < 3) {
        await customStatement(
          'ALTER TABLE templates ADD COLUMN active INTEGER NOT NULL DEFAULT 1 CHECK(active IN (0,1))',
        );
        await customStatement(
          'ALTER TABLE bills ADD COLUMN amount_override INTEGER CHECK(amount_override BETWEEN 1 AND 999999999999)',
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

Future<AppDatabase> openDatabase() async {
  await prepareStoragePolicy();
  const storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
      synchronizable: false,
    ),
  );
  final directory = await getApplicationSupportDirectory();
  final file = File(p.join(directory.path, 'finance.sqlite'));
  var key = await storage.read(key: 'ledger_key_v1');
  if (key == null) {
    if (await file.exists()) throw StateError('database_key_unavailable');
    final random = Random.secure();
    key = List.generate(
      32,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    await storage.write(key: 'ledger_key_v1', value: key);
  }
  if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(key)) {
    throw StateError('database_key_invalid');
  }
  final secret = key;
  return AppDatabase(
    NativeDatabase.createInBackground(
      file,
      setup: (db) {
        if (db.select('PRAGMA cipher').isEmpty) {
          throw StateError('encrypted_database_unavailable');
        }
        db.execute("PRAGMA cipher = 'sqlcipher'");
        db.execute("PRAGMA key = '$secret'");
        db.execute('PRAGMA secure_delete = ON');
      },
    ),
  );
}
