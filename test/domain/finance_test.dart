import 'package:flutter_test/flutter_test.dart';
import 'package:catatan_uang/core/domain/finance.dart';

void main() {
  test('SAFE-04 fixture and bill payment preserve safe spending', () {
    const before = SafeToSpend(
      liquid: 5000000,
      budget: 4000000,
      expense: 1000000,
      reserve: 1000000,
      days: 20,
    );
    const after = SafeToSpend(
      liquid: 4500000,
      budget: 4000000,
      expense: 1500000,
      reserve: 500000,
      days: 20,
    );
    expect(before.amount, 2000000);
    expect(before.daily, 100000);
    expect(after.amount, before.amount);
  });
  test('SAFE limits and separate deficits', () {
    const a = SafeToSpend(
      liquid: 100,
      budget: 200,
      expense: 250,
      reserve: 150,
      days: 1,
    );
    expect(a.amount, 0);
    expect(a.cashDeficit, 50);
    expect(a.budgetDeficit, 200);
    expect(
      const SafeToSpend(
        liquid: 10,
        budget: 100,
        expense: 0,
        reserve: 0,
        days: 3,
      ).daily,
      3,
    );
  });
  test('ONB-02 strict integer money parsing', () {
    expect(parseMoney('Rp1.250.000'), 1250000);
    expect(parseMoney('0', allowZero: true), 0);
    for (final invalid in [
      '1.23',
      '1,50',
      '-100',
      '0',
      '1000000000000',
      '1e3',
      '1 000',
      'Rp',
    ]) {
      expect(() => parseMoney(invalid), throwsFormatException);
    }
  });
  test('AC12 anchor clamp returns to March 31', () {
    final feb = periodAt(DateTime.utc(2026, 2, 28), 31);
    expect(feb.start, DateTime.utc(2026, 2, 28));
    expect(feb.end, DateTime.utc(2026, 3, 31));
    final jan = periodAt(DateTime.utc(2026, 2, 27), 31);
    expect(jan.start, DateTime.utc(2026, 1, 31));
    expect(jan.end, feb.start);
  });
  test('BUD-08 partial period and last-day boundary', () {
    final p = periodAt(
      DateTime.utc(2026, 10, 4),
      1,
      started: DateTime.utc(2026, 10, 4),
    );
    expect(p.partial, true);
    expect(p.start, DateTime.utc(2026, 10, 4));
    expect(p.end, DateTime.utc(2026, 11, 1));
    expect(p.contains(DateTime.utc(2026, 11, 1)), false);
  });
}
