import 'package:catatan_uang/core/domain/csv_export.dart';
import 'package:catatan_uang/core/domain/finance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CSV escapes formula input, quotes, and excludes other periods', () {
    final snapshot = FinanceSnapshot(
      accounts: [Account('a', '=Tunai', 'cash', 0, DateTime.utc(2026))],
      entries: [
        Entry(
          id: '1',
          type: 'expense',
          account: 'a',
          amount: 100,
          occurred: DateTime.utc(2026, 10, 6),
          businessDate: DateTime.utc(2026, 10, 6),
          merchant: ' +SUM(1,2)',
          note: 'Kata "tes", lanjut\nbaris',
        ),
        Entry(
          id: '2',
          type: 'expense',
          account: 'a',
          amount: 200,
          occurred: DateTime.utc(2026, 9, 30),
          businessDate: DateTime.utc(2026, 9, 30),
        ),
      ],
      bills: const [],
      budget: null,
      allocations: const {},
      period: Period(DateTime.utc(2026, 10), DateTime.utc(2026, 11)),
      zone: 'Asia/Jakarta',
      anchor: 1,
      onboarded: true,
      now: DateTime.utc(2026, 10, 6),
    );
    final csv = transactionCsv(
      snapshot,
      DateTime.utc(2026, 10),
      DateTime.utc(2026, 11),
    );
    expect(csv, startsWith('\uFEFFid,tanggal_buku'));
    expect(csv, contains('"\'=Tunai"'));
    expect(csv, contains('"\' +SUM(1,2)"'));
    expect(csv, contains('"Kata ""tes"", lanjut\nbaris"'));
    expect(csv, contains('"1"'));
    expect(csv, isNot(contains('"2"')));
  });
}
