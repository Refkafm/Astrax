import 'finance.dart';

List<Entry> filterTransactionHistory(
  Iterable<Entry> entries, {
  required DateTime start,
  required DateTime end,
  String account = 'all',
  String category = 'all',
  String type = 'all',
  String query = '',
}) {
  final search = query.trim().toLowerCase();
  final result = entries.where((e) {
    final date = day(e.businessDate);
    return !date.isBefore(day(start)) &&
        date.isBefore(day(end)) &&
        (account == 'all' ||
            e.account == account ||
            e.destination == account) &&
        (category == 'all' || e.category == category) &&
        (type == 'all' || e.type == type) &&
        (search.isEmpty ||
            '${e.merchant} ${e.note}'.toLowerCase().contains(search));
  }).toList();
  result.sort((a, b) {
    final time = b.occurred.compareTo(a.occurred);
    return time != 0 ? time : b.id.compareTo(a.id);
  });
  return result;
}

int dailyExpenseNet(Iterable<Entry> entries) =>
    entries.fold(0, (sum, e) => sum + e.expenseNet);
