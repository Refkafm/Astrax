import 'dart:math';

import 'finance.dart';

class NamedAmount {
  final String name;
  final int amount;
  const NamedAmount(this.name, this.amount);
}

List<Entry> analyticsEntries(
  FinanceSnapshot snapshot, {
  String? account,
  String? category,
  DateTime? start,
  DateTime? end,
}) => snapshot.entries.where((entry) {
  final date = day(entry.businessDate);
  return !date.isBefore(start ?? snapshot.period.start) &&
      date.isBefore(end ?? snapshot.period.end) &&
      (account == null || entry.account == account) &&
      (category == null || entry.category == category);
}).toList();

List<NamedAmount> topMerchants(
  FinanceSnapshot snapshot, {
  String? account,
  String? category,
}) {
  final original = {for (final e in snapshot.entries) e.id: e};
  final totals = <String, int>{};
  for (final entry in analyticsEntries(
    snapshot,
    account: account,
    category: category,
  )) {
    if (entry.type != 'expense' && entry.type != 'refund') continue;
    final source = entry.type == 'refund'
        ? original[entry.refundOf] ?? entry
        : entry;
    final name = source.merchant.trim().isEmpty
        ? 'Tanpa merchant'
        : source.merchant.trim();
    totals.update(
      name,
      (value) => value + entry.expenseNet,
      ifAbsent: () => entry.expenseNet,
    );
  }
  return (totals.entries.map((e) => NamedAmount(e.key, e.value)).toList()
        ..sort((a, b) {
          final amount = b.amount.compareTo(a.amount);
          return amount != 0 ? amount : a.name.compareTo(b.name);
        }))
      .take(5)
      .toList();
}

class ExpenseComparison {
  final DateTime currentStart, currentEnd, previousStart, previousEnd;
  final int current, previous;
  const ExpenseComparison(
    this.currentStart,
    this.currentEnd,
    this.previousStart,
    this.previousEnd,
    this.current,
    this.previous,
  );
  int get difference => current - previous;
  double? get percent => previous == 0 ? null : difference / previous * 100;
}

ExpenseComparison? comparableExpense(
  FinanceSnapshot snapshot, {
  String? account,
  String? category,
}) {
  if (snapshot.period.partial || snapshot.started == null) return null;
  final previous = periodAt(
    snapshot.period.start.subtract(const Duration(days: 1)),
    snapshot.anchor,
  );
  if (day(snapshot.started!).isAfter(previous.start)) return null;
  final today = day(profileNow(snapshot.zone, snapshot.now));
  final days = min(
    snapshot.period.end.difference(snapshot.period.start).inDays,
    max(0, today.difference(snapshot.period.start).inDays + 1),
  );
  if (days == 0) return null;
  final currentEnd = snapshot.period.start.add(Duration(days: days));
  final previousEnd = previous.start.add(
    Duration(days: min(days, previous.end.difference(previous.start).inDays)),
  );
  int total(DateTime start, DateTime end) => analyticsEntries(
    snapshot,
    account: account,
    category: category,
    start: start,
    end: end,
  ).fold(0, (value, e) => value + e.expenseNet);
  return ExpenseComparison(
    snapshot.period.start,
    currentEnd,
    previous.start,
    previousEnd,
    total(snapshot.period.start, currentEnd),
    total(previous.start, previousEnd),
  );
}
