import 'package:catatan_uang/core/domain/finance.dart';
import 'package:catatan_uang/core/domain/transaction_history.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Entry entry(
    String id,
    DateTime when,
    String type,
    String account, {
    String? destination,
    String category = '',
    String merchant = '',
    int amount = 100,
  }) => Entry(
    id: id,
    type: type,
    account: account,
    destination: destination,
    category: category,
    merchant: merchant,
    amount: amount,
    occurred: when,
    businessDate: day(when),
  );

  test(
    'historical filtering includes destination account and sorts newest first',
    () {
      final records = [
        entry('old', DateTime.utc(2026, 9, 30), 'expense', 'a'),
        entry(
          'x',
          DateTime.utc(2026, 10, 2, 9),
          'transfer',
          'a',
          destination: 'b',
        ),
        entry(
          'y',
          DateTime.utc(2026, 10, 2, 10),
          'expense',
          'b',
          category: 'Makan',
          merchant: 'Warung',
        ),
      ];
      final result = filterTransactionHistory(
        records,
        start: DateTime.utc(2026, 10),
        end: DateTime.utc(2026, 11),
        account: 'b',
      );
      expect(result.map((e) => e.id), ['y', 'x']);
      expect(
        filterTransactionHistory(
          records,
          start: DateTime.utc(2026, 9),
          end: DateTime.utc(2026, 10),
        ).map((e) => e.id),
        ['old'],
      );
      expect(
        filterTransactionHistory(
          records,
          start: DateTime.utc(2026, 10),
          end: DateTime.utc(2026, 11),
          category: 'Makan',
          query: 'WARUNG',
        ).map((e) => e.id),
        ['y'],
      );
    },
  );

  test('daily subtotal counts expense less refunds only', () {
    final date = DateTime.utc(2026, 10, 2);
    expect(
      dailyExpenseNet([
        entry('a', date, 'expense', 'a', amount: 100),
        entry('b', date, 'refund', 'a', amount: 40),
        entry('c', date, 'income', 'a', amount: 500),
      ]),
      60,
    );
  });
}
