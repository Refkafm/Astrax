import 'dart:math';

import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

const maxMoney = 999999999999;
const expenseCategories = [
  'Makan & minum',
  'Belanja harian',
  'Transportasi',
  'Tempat tinggal',
  'Listrik & air',
  'Internet & pulsa',
  'Kesehatan',
  'Pendidikan',
  'Hiburan & langganan',
  'Belanja pribadi',
  'Keluarga',
  'Donasi',
  'Biaya admin',
  'Lainnya',
  'Belum dikategorikan',
];
const incomeCategories = ['Gaji', 'Freelance/usaha', 'Hadiah', 'Lainnya'];
String rupiah(int value) => NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
).format(value);
int parseMoney(String input, {bool allowZero = false}) {
  final clean = input.trim().replaceFirst(
    RegExp(r'^Rp\s*', caseSensitive: false),
    '',
  );
  if (!RegExp(r'^(\d+|\d{1,3}(\.\d{3})+)$').hasMatch(clean)) {
    throw const FormatException(
      'Gunakan rupiah bulat, misalnya 125000 atau Rp125.000.',
    );
  }
  final value = int.tryParse(clean.replaceAll('.', ''));
  if (value == null || value > maxMoney || value < (allowZero ? 0 : 1)) {
    throw FormatException(
      'Nominal harus ${allowZero ? 'nol atau ' : ''}positif, maksimal Rp999.999.999.999.',
    );
  }
  return value;
}

DateTime day(DateTime value) =>
    DateTime.utc(value.year, value.month, value.day);
DateTime profileNow(String zone, [DateTime? now]) =>
    tz.TZDateTime.from(now ?? DateTime.now(), tz.getLocation(zone));
DateTime anchored(int year, int month, int anchor) {
  final first = DateTime.utc(year, month);
  return DateTime.utc(
    first.year,
    first.month,
    min(anchor, DateTime.utc(first.year, first.month + 1, 0).day),
  );
}

class Period {
  final DateTime start, end;
  final bool partial;
  const Period(this.start, this.end, {this.partial = false});
  bool contains(DateTime date) =>
      !day(date).isBefore(start) && day(date).isBefore(end);
  String get label =>
      '${DateFormat('d MMM', 'id_ID').format(start)} – ${DateFormat('d MMM yyyy', 'id_ID').format(end.subtract(const Duration(days: 1)))}';
}

Period periodAt(DateTime date, int anchor, {DateTime? started}) {
  if (anchor < 1 || anchor > 31) {
    throw ArgumentError('Awal periode harus 1–31.');
  }
  final today = day(date);
  final boundary = anchored(today.year, today.month, anchor);
  final start = today.isBefore(boundary)
      ? anchored(today.year, today.month - 1, anchor)
      : boundary;
  final end = anchored(start.year, start.month + 1, anchor);
  final partial =
      started != null &&
      day(started).isAfter(start) &&
      day(started).isBefore(end);
  return Period(partial ? day(started) : start, end, partial: partial);
}

class SafeToSpend {
  final int liquid, budget, expense, reserve, days;
  const SafeToSpend({
    required this.liquid,
    required this.budget,
    required this.expense,
    required this.reserve,
    required this.days,
  });
  int get cashRoom => liquid - reserve;
  int get budgetRoom => budget - expense - reserve;
  int get amount => max(0, min(cashRoom, budgetRoom));
  int get daily => amount ~/ max(1, days);
  int get cashDeficit => max(0, -cashRoom);
  int get budgetDeficit => max(0, -budgetRoom);
}

class Account {
  final String id, name, type;
  final int opening;
  final DateTime opened;
  final bool archived;
  const Account(
    this.id,
    this.name,
    this.type,
    this.opening,
    this.opened, {
    this.archived = false,
  });
}

class Entry {
  final String id, type, account, category, merchant, note;
  final String? destination, refundOf, parent;
  final int amount;
  final DateTime occurred;
  final DateTime businessDate;
  const Entry({
    required this.id,
    required this.type,
    required this.account,
    required this.amount,
    required this.occurred,
    required this.businessDate,
    this.category = '',
    this.merchant = '',
    this.note = '',
    this.destination,
    this.refundOf,
    this.parent,
  });
  int effect(String accountId) {
    if (type == 'transfer') {
      return (accountId == account ? -amount : 0) +
          (accountId == destination ? amount : 0);
    }
    if (account != accountId) return 0;
    return type == 'expense' ? -amount : amount;
  }

  int get expenseNet => type == 'expense'
      ? amount
      : type == 'refund'
      ? -amount
      : 0;
  String get label => merchant.isNotEmpty
      ? merchant
      : type == 'transfer'
      ? 'Transfer'
      : type == 'adjustment'
      ? 'Penyesuaian saldo'
      : category;
}

class Bill {
  final String id, name, account, category, direction, state;
  final String? templateId;
  final bool templateActive;
  final int amount;
  final DateTime due;
  const Bill(
    this.id,
    this.name,
    this.account,
    this.category,
    this.direction,
    this.state,
    this.amount,
    this.due, {
    this.templateId,
    this.templateActive = true,
  });
}

class FinanceCategory {
  final String name, type;
  final bool archived, isSystem;
  const FinanceCategory(
    this.name,
    this.type, {
    this.archived = false,
    this.isSystem = false,
  });
}

class FinanceSnapshot {
  final List<Account> accounts;
  final List<FinanceCategory> categories;
  final List<Entry> entries;
  final List<Bill> bills;
  final int? budget;
  final Map<String, int> allocations;
  final Period period;
  final String zone;
  final int anchor;
  final bool onboarded;
  final DateTime now;
  final DateTime? started;
  const FinanceSnapshot({
    required this.accounts,
    this.categories = const [],
    required this.entries,
    required this.bills,
    required this.budget,
    required this.allocations,
    required this.period,
    required this.zone,
    required this.anchor,
    required this.onboarded,
    required this.now,
    this.started,
  });
  List<Account> get activeAccounts =>
      accounts.where((a) => !a.archived).toList();
  List<String> categoryNames(String type, {String? include}) {
    final names = categories.isEmpty
        ? List<String>.of(
            type == 'income' ? incomeCategories : expenseCategories,
          )
        : categories
              .where((c) => c.type == type && !c.archived)
              .map((c) => c.name)
              .toList();
    if (include != null && include.isNotEmpty && !names.contains(include)) {
      names.add(include);
    }
    return names;
  }

  int balance(Account a) =>
      a.opening + entries.fold(0, (sum, e) => sum + e.effect(a.id));
  int get liquid => activeAccounts.fold(0, (sum, a) => sum + balance(a));
  List<Entry> get current =>
      entries.where((e) => period.contains(e.businessDate)).toList();
  int get expense => current.fold(0, (sum, e) => sum + e.expenseNet);
  int get income => current
      .where((e) => e.type == 'income')
      .fold(0, (sum, e) => sum + e.amount);
  int get reserve => bills
      .where(
        (b) =>
            b.direction == 'expense' &&
            b.state == 'unpaid' &&
            b.due.isBefore(period.end),
      )
      .fold(0, (sum, b) => sum + b.amount);
  int categoryActual(String category) => current
      .where((e) => e.category == category)
      .fold(0, (sum, e) => sum + e.expenseNet);
  SafeToSpend? get safe => budget == null || activeAccounts.isEmpty
      ? null
      : SafeToSpend(
          liquid: liquid,
          budget: budget!,
          expense: expense,
          reserve: reserve,
          days: max(
            1,
            period.end.difference(day(profileNow(zone, now))).inDays,
          ),
        );
  String accountName(String id) =>
      accounts.where((a) => a.id == id).firstOrNull?.name ?? 'Akun';
}
