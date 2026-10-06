import 'package:catatan_uang/core/domain/analytics.dart';
import 'package:catatan_uang/core/domain/finance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  Entry entry(
    String id,
    String type,
    int amount,
    DateTime date, {
    String merchant = '',
    String? refundOf,
    String account = 'a',
    String category = '',
  }) => Entry(
    id: id,
    type: type,
    account: account,
    amount: amount,
    occurred: date,
    businessDate: day(date),
    merchant: merchant,
    category: category,
    refundOf: refundOf,
  );
  FinanceSnapshot snapshot(List<Entry> entries, {DateTime? started}) =>
      FinanceSnapshot(
        accounts: [Account('a', 'Tunai', 'cash', 0, DateTime.utc(2026, 9))],
        entries: entries,
        bills: const [],
        budget: null,
        allocations: const {},
        period: Period(DateTime.utc(2026, 10), DateTime.utc(2026, 11)),
        zone: 'Asia/Jakarta',
        anchor: 1,
        onboarded: true,
        now: DateTime.utc(2026, 10, 12, 2),
        started: started,
      );

  test('merchant net follows original expense for cross-period refund', () {
    final s = snapshot([
      entry(
        'old',
        'expense',
        200,
        DateTime.utc(2026, 9, 20),
        merchant: 'Warung',
      ),
      entry(
        'new',
        'expense',
        100,
        DateTime.utc(2026, 10, 5),
        merchant: 'Warung',
      ),
      entry('refund', 'refund', 40, DateTime.utc(2026, 10, 6), refundOf: 'old'),
      entry('blank', 'expense', 30, DateTime.utc(2026, 10, 6)),
      entry(
        'transfer',
        'transfer',
        900,
        DateTime.utc(2026, 10, 6),
        merchant: 'Bank',
      ),
    ]);
    expect(topMerchants(s).map((e) => '${e.name}:${e.amount}'), [
      'Warung:60',
      'Tanpa merchant:30',
    ]);
  });

  test('comparison uses equal elapsed days and requires previous coverage', () {
    final entries = [
      entry('previous', 'expense', 50, DateTime.utc(2026, 9, 10)),
      entry('late', 'expense', 500, DateTime.utc(2026, 9, 30)),
      entry('current', 'expense', 100, DateTime.utc(2026, 10, 12)),
    ];
    final comparison = comparableExpense(
      snapshot(entries, started: DateTime.utc(2026, 9, 1)),
    )!;
    expect(comparison.previousEnd, DateTime.utc(2026, 9, 13));
    expect(comparison.previous, 50);
    expect(comparison.current, 100);
    expect(comparison.percent, 100);
    expect(
      comparableExpense(snapshot(entries, started: DateTime.utc(2026, 9, 5))),
      isNull,
    );
  });
  test(
    'account and category filters affect only selected analytics entries',
    () {
      final s = snapshot([
        entry(
          'a',
          'expense',
          100,
          DateTime.utc(2026, 10, 5),
          merchant: 'Warung',
          category: 'Makan',
        ),
        entry(
          'b',
          'expense',
          250,
          DateTime.utc(2026, 10, 6),
          merchant: 'Toko',
          account: 'b',
          category: 'Belanja',
        ),
        entry('c', 'income', 500, DateTime.utc(2026, 10, 7), category: 'Gaji'),
      ], started: DateTime.utc(2026, 9, 1));
      expect(
        analyticsEntries(s, account: 'a', category: 'Makan').map((e) => e.id),
        ['a'],
      );
      expect(
        topMerchants(s, account: 'a', category: 'Makan').single.amount,
        100,
      );
      expect(
        comparableExpense(s, account: 'a', category: 'Makan')!.current,
        100,
      );
      expect(s.expense, 350);
    },
  );
}
