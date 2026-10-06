import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../app/providers.dart';
import 'management.dart';
import '../app/theme.dart';
import '../core/domain/finance.dart';
import '../core/domain/transaction_history.dart';
import '../core/domain/analytics.dart';
import '../core/widgets/components.dart';

void notify(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
Future<bool> confirm(BuildContext context, String title, String body) async =>
    await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    ) ??
    false;
Future<void> runAction(
  BuildContext context,
  Future<void> Function() action,
  String success,
) async {
  try {
    await action();
    if (context.mounted) notify(context, success);
  } catch (e) {
    if (context.mounted) {
      notify(
        context,
        e is StateError ? e.message : 'Perubahan belum tersimpan. Coba lagi.',
      );
    }
  }
}

class SnapshotView extends ConsumerWidget {
  final Widget Function(FinanceSnapshot) builder;
  const SnapshotView({super.key, required this.builder});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(snapshotProvider)
      .when(
        data: builder,
        loading: () => const Center(
          child: CircularProgressIndicator(
            semanticsLabel: 'Menyiapkan catatan',
          ),
        ),
        error: (e, s) => Center(
          child: EmptyState(
            'Catatan belum bisa ditampilkan',
            'Data tidak dihapus. Coba buka kembali catatan.',
            action: 'Coba lagi',
            onTap: () => ref.invalidate(snapshotProvider),
          ),
        ),
      );
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) => SnapshotView(
    builder: (s) {
      if (!s.onboarded) return const OnboardingScreen();
      return Scaffold(
        appBar: AppBar(
          title: Text(['Home', 'Transaksi', 'Budget', 'Ringkasan'][tab]),
          actions: [
            IconButton(
              tooltip: 'Pengaturan',
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings_outlined),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: IndexedStack(
          index: tab,
          children: [
            HomeScreen(s),
            TransactionsScreen(s),
            BudgetScreen(s),
            AnalyticsScreen(s),
          ],
        ),
        floatingActionButton: tab < 2
            ? FloatingActionButton.extended(
                backgroundColor: Palette.primary,
                foregroundColor: Palette.ink,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Palette.ink, width: 2),
                ),
                onPressed: () => context.push('/entry'),
                icon: const Icon(Icons.add),
                label: const Text(
                  'Catat',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              )
            : null,
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Palette.ink, width: 2)),
          ),
          child: NavigationBar(
            selectedIndex: tab,
            onDestinationSelected: (i) => setState(() => tab = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                label: 'Transaksi',
              ),
              NavigationDestination(
                icon: Icon(Icons.pie_chart_outline),
                label: 'Budget',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                label: 'Ringkasan',
              ),
            ],
          ),
        ),
      );
    },
  );
}

class HomeScreen extends StatelessWidget {
  final FinanceSnapshot s;
  const HomeScreen(this.s, {super.key});
  @override
  Widget build(BuildContext context) {
    final safe = s.safe;
    return PageBody(
      storageKey: 'home',
      children: [
        Text(s.period.label, style: const TextStyle(color: Palette.secondary)),
        if (s.period.partial)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('Periode awal parsial', style: TextStyle(fontSize: 12)),
          ),
        const SizedBox(height: 20),
        OutlinedSurface(
          color: Palette.mint,
          shadow: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.spa_outlined, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ESTIMASI AMAN DIPAKAI',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (safe == null)
                const Text(
                  '—',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
                )
              else
                MoneyText(
                  safe.amount,
                  size: MediaQuery.sizeOf(context).width < 360 ? 32 : 40,
                ),
              const SizedBox(height: 10),
              Text(
                safe == null
                    ? 'Lengkapi akun dan batas belanjamu.'
                    : '${rupiah(safe.daily)} per hari',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sampai ${DateFormat('d MMMM', 'id_ID').format(s.period.end.subtract(const Duration(days: 1)))}',
                style: const TextStyle(color: Palette.secondary),
              ),
              const SizedBox(height: 16),
              const Divider(color: Palette.ink),
              TextButton.icon(
                onPressed: () => safe == null
                    ? context.push(
                        s.activeAccounts.isEmpty
                            ? '/account/new'
                            : '/budget/edit',
                      )
                    : showBreakdown(context, s),
                label: Text(
                  safe == null
                      ? s.activeAccounts.isEmpty
                            ? 'Tambah akun'
                            : 'Atur budget'
                      : 'Lihat perhitungan',
                ),
                icon: const Icon(Icons.arrow_forward, size: 20),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, c) {
            final cards = [
              _summary(
                context,
                'Saldo tercatat',
                s.liquid,
                Palette.lilac,
                Icons.account_balance_wallet_outlined,
                '/accounts',
              ),
              _summary(
                context,
                'Tagihan belum dibayar',
                s.reserve,
                Palette.butter,
                Icons.event_note_outlined,
                '/bills',
              ),
            ];
            if (c.maxWidth < 350 ||
                MediaQuery.textScalerOf(context).scale(16) > 22) {
              return Column(
                children: [cards[0], const SizedBox(height: 12), cards[1]],
              );
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[1]),
                ],
              ),
            );
          },
        ),
        Section(
          'Akun',
          action: 'Lihat semua',
          onTap: () => context.push('/accounts'),
        ),
        if (s.activeAccounts.isEmpty)
          EmptyState(
            'Uangmu, mulai tercatat.',
            'Tambahkan bank, e-wallet, atau uang tunai.',
            action: 'Tambah akun',
            onTap: () => context.push('/account/new'),
          )
        else
          OutlinedSurface(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: s.accounts
                  .take(3)
                  .map(
                    (a) => AccountRow(
                      a,
                      s,
                      onTap: () => context.push('/accounts'),
                    ),
                  )
                  .toList(),
            ),
          ),
        Section(
          'Budget',
          action: 'Edit budget',
          onTap: () => context.push('/budget/edit'),
        ),
        if (s.budget == null)
          EmptyState(
            'Tentukan batas belanja.',
            'Masukkan budget tersisa untuk periode ini.',
            action: 'Atur budget',
            onTap: () => context.push('/budget/edit'),
          )
        else
          OutlinedSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryProgress('Total periode ini', s.expense, s.budget!),
                ...s.allocations.entries
                    .take(3)
                    .map(
                      (a) => CategoryProgress(
                        a.key,
                        s.categoryActual(a.key),
                        a.value,
                      ),
                    ),
              ],
            ),
          ),
        Section(
          'Tagihan mendatang',
          action: 'Lihat semua',
          onTap: () => context.push('/bills'),
        ),
        if (s.bills
            .where((b) => b.state == 'unpaid' && b.direction == 'expense')
            .isEmpty)
          EmptyState(
            'Belum ada tagihan.',
            'Tambahkan tagihan agar dananya ikut disisihkan.',
            action: 'Tambah tagihan',
            onTap: () => context.push('/bill/new'),
          )
        else
          ...s.bills
              .where((b) => b.state == 'unpaid' && b.direction == 'expense')
              .take(3)
              .map((b) => BillRow(b, s)),
        const Section('Transaksi terbaru'),
        if (s.entries.isEmpty)
          const EmptyState(
            'Mulai dari satu transaksi.',
            'Catat uang masuk atau keluar lewat tombol + Catat.',
          )
        else
          OutlinedSurface(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: s.entries
                  .take(5)
                  .map((e) => TransactionRow(e, s))
                  .toList(),
            ),
          ),
        const SizedBox(height: 20),
        const Text(
          'Saldo pembukuan lokal, bukan saldo bank real-time.',
          style: TextStyle(fontSize: 12, color: Palette.secondary),
        ),
      ],
    );
  }

  Widget _summary(
    BuildContext c,
    String title,
    int amount,
    Color color,
    IconData icon,
    String route,
  ) => InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: () => c.push(route),
    child: OutlinedSurface(
      color: color,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: 12),
          Text(title),
          const SizedBox(height: 8),
          MoneyText(amount, size: 20),
        ],
      ),
    ),
  );
}

void showBreakdown(BuildContext context, FinanceSnapshot s) {
  final a = s.safe!;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (c) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: .8,
      minChildSize: .4,
      maxChildSize: .95,
      builder: (c, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Cara menghitungnya',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                tooltip: 'Tutup',
                onPressed: () => Navigator.pop(c),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          DetailLine('Saldo tercatat', a.liquid),
          DetailLine('Tagihan belum dibayar', -a.reserve),
          DetailLine('Ruang dari saldo', a.cashRoom),
          const Divider(),
          DetailLine('Budget periode ini', a.budget),
          DetailLine('Pengeluaran bersih', -a.expense),
          DetailLine('Tagihan belum dibayar', -a.reserve),
          DetailLine('Ruang dari budget', a.budgetRoom),
          const Divider(),
          OutlinedSurface(
            color: Palette.mint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Estimasi Aman Dipakai'),
                MoneyText(a.amount),
                const SizedBox(height: 8),
                Text('${a.days} hari tersisa · ${rupiah(a.daily)} per hari'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nilai yang lebih kecil dari ruang saldo dan ruang budget, minimal Rp0. Berdasarkan transaksi yang sudah tercatat. Pemasukan yang belum diterima tidak dihitung.',
          ),
          if (a.cashDeficit > 0) DetailLine('Defisit saldo', a.cashDeficit),
          if (a.budgetDeficit > 0)
            DetailLine('Defisit budget', a.budgetDeficit),
          const SizedBox(height: 12),
          Text(
            'Berdasarkan catatan sampai ${DateFormat('d MMM yyyy HH:mm', 'id_ID').format(profileNow(s.zone, s.now))} (${s.zone}).',
            style: const TextStyle(color: Palette.secondary),
          ),
        ],
      ),
    ),
  );
}

class AccountRow extends StatelessWidget {
  final Account a;
  final FinanceSnapshot s;
  final VoidCallback? onTap;
  const AccountRow(this.a, this.s, {super.key, this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(accountIcon(a.type)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  a.type == 'bank'
                      ? 'Bank'
                      : a.type == 'cash'
                      ? 'Tunai'
                      : 'E-wallet',
                  style: const TextStyle(color: Palette.secondary),
                ),
                MoneyText(s.balance(a), size: 18),
                if (s.balance(a) < 0)
                  const Text(
                    'Periksa catatan akun',
                    style: TextStyle(color: Palette.danger),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class TransactionRow extends StatelessWidget {
  final Entry e;
  final FinanceSnapshot s;
  const TransactionRow(this.e, this.s, {super.key});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => showEntry(context, e, s),
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            e.type == 'transfer' ? Icons.swap_horiz : categoryIcon(e.category),
            color: e.type == 'income'
                ? Palette.mint
                : e.type == 'transfer'
                ? Palette.lilac
                : Palette.butter,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  e.type == 'transfer'
                      ? '${s.accountName(e.account)} → ${s.accountName(e.destination!)}'
                      : '${e.type == 'refund' ? 'Refund · ' : ''}${e.category} · ${s.accountName(e.account)}',
                  style: const TextStyle(color: Palette.secondary),
                ),
                const SizedBox(height: 4),
                MoneyText(
                  e.type == 'expense' ? -e.amount : e.amount,
                  size: 16,
                  color: ['income', 'refund'].contains(e.type)
                      ? Palette.success
                      : null,
                ),
                Text(
                  DateFormat(
                    'd MMM · HH:mm',
                    'id_ID',
                  ).format(profileNow(s.zone, e.occurred)),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Palette.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void showEntry(BuildContext context, Entry e, FinanceSnapshot s) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (c) => Consumer(
      builder: (c, ref, _) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(e.label, style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 12),
            MoneyText(e.amount, size: 32),
            const SizedBox(height: 12),
            Text('${s.accountName(e.account)} · ${e.category}'),
            Text(e.note),
            const SizedBox(height: 20),
            if (e.parent == null && e.type != 'adjustment')
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(c);
                  context.push('/entry?edit=${e.id}');
                },
                child: const Text('Edit transaksi'),
              ),
            if (e.type == 'expense')
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(c);
                  context.push('/entry?refund=${e.id}');
                },
                child: const Text('Catat refund'),
              ),
            if (e.parent == null)
              TextButton(
                onPressed: () async {
                  if (!await confirm(
                    c,
                    'Hapus transaksi?',
                    'Saldo dan budget akan dihitung ulang. Tagihan terkait kembali belum dibayar.',
                  )) {
                    return;
                  }
                  if (!c.mounted) return;
                  try {
                    await ref.read(repositoryProvider).deleteEntry(e.id);
                    if (!c.mounted) return;
                    Navigator.pop(c);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Transaksi dihapus'),
                          action: SnackBarAction(
                            label: 'Urungkan',
                            onPressed: () => runAction(
                              context,
                              () =>
                                  ref.read(repositoryProvider).undoDelete(e.id),
                              'Transaksi dipulihkan',
                            ),
                          ),
                        ),
                      );
                    }
                  } catch (error) {
                    if (c.mounted) {
                      notify(
                        c,
                        error is StateError
                            ? error.message
                            : 'Transaksi belum dihapus.',
                      );
                    }
                  }
                },
                child: const Text(
                  'Hapus transaksi',
                  style: TextStyle(color: Palette.danger),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    ),
  );
}

class TransactionsScreen extends StatefulWidget {
  final FinanceSnapshot s;
  const TransactionsScreen(this.s, {super.key});
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String query = '', type = 'all', account = 'all', category = 'all';
  DateTime? rangeStart, rangeEnd;
  int shown = 50;
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> selectRange(FinanceSnapshot s) async {
    final today = day(profileNow(s.zone, s.now));
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year, today.month, today.day),
      initialDateRange: DateTimeRange(
        start: rangeStart ?? s.period.start,
        end: rangeEnd?.subtract(const Duration(days: 1)) ?? today,
      ),
    );
    if (selected != null) {
      setState(() {
        rangeStart = day(selected.start);
        rangeEnd = day(selected.end).add(const Duration(days: 1));
        shown = 50;
      });
    }
  }

  void reset() => setState(() {
    searchController.clear();
    query = '';
    type = account = category = 'all';
    rangeStart = rangeEnd = null;
    shown = 50;
  });

  Future<void> showFilters(FinanceSnapshot s) async {
    var selectedType = type;
    var selectedAccount = account;
    var selectedCategory = category;
    final categories = s.categories.map((c) => c.name).toSet()
      ..addAll(s.entries.map((e) => e.category).where((c) => c.isNotEmpty));
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, updateSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            16,
            24,
            MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter transaksi',
                        style: Theme.of(sheetContext).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup filter',
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Jenis transaksi'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final item in {
                      'all': 'Semua',
                      'expense': 'Pengeluaran',
                      'income': 'Pemasukan',
                      'transfer': 'Transfer',
                      'refund': 'Refund',
                      'adjustment': 'Penyesuaian',
                    }.entries)
                      FilterChip(
                        label: Text(item.value),
                        selected: selectedType == item.key,
                        onSelected: (_) =>
                            updateSheet(() => selectedType = item.key),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: ValueKey('sheet-account-$selectedAccount'),
                  isExpanded: true,
                  initialValue: selectedAccount,
                  decoration: const InputDecoration(labelText: 'Akun'),
                  items: [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('Semua akun'),
                    ),
                    ...s.accounts.map(
                      (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                    ),
                  ],
                  onChanged: (value) =>
                      updateSheet(() => selectedAccount = value ?? 'all'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: ValueKey('sheet-category-$selectedCategory'),
                  isExpanded: true,
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('Semua kategori'),
                    ),
                    ...categories.map(
                      (c) => DropdownMenuItem(value: c, child: Text(c)),
                    ),
                  ],
                  onChanged: (value) =>
                      updateSheet(() => selectedCategory = value ?? 'all'),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      type = selectedType;
                      account = selectedAccount;
                      category = selectedCategory;
                      shown = 50;
                    });
                    Navigator.pop(sheetContext);
                  },
                  child: const Text('Terapkan filter'),
                ),
                TextButton(
                  onPressed: () => updateSheet(() {
                    selectedType = selectedAccount = selectedCategory = 'all';
                  }),
                  child: const Text('Kosongkan pilihan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final from = rangeStart ?? s.period.start;
    final until = rangeEnd ?? s.period.end;
    final entries = filterTransactionHistory(
      s.entries,
      start: from,
      end: until,
      account: account,
      category: category,
      type: type,
      query: query,
    );
    final filterCount = [
      type,
      account,
      category,
    ].where((value) => value != 'all').length;
    return PageBody(
      storageKey: 'transactions',
      children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Cari transaksi',
            hintText: 'Merchant atau catatan',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus pencarian',
                    onPressed: () => setState(() {
                      searchController.clear();
                      query = '';
                      shown = 50;
                    }),
                    icon: const Icon(Icons.close),
                  ),
          ),
          onChanged: (v) => setState(() {
            query = v;
            shown = 50;
          }),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => selectRange(s),
                child: const Text('Periode'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => showFilters(s),
                child: Text(
                  filterCount == 0 ? 'Filter' : 'Filter ($filterCount)',
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            rangeStart == null
                ? s.period.label
                : '${DateFormat('d MMM yyyy', 'id_ID').format(from)} – ${DateFormat('d MMM yyyy', 'id_ID').format(until.subtract(const Duration(days: 1)))}',
            style: const TextStyle(color: Palette.secondary),
          ),
        ),
        if (defaultTargetPlatform == TargetPlatform.android)
          TextButton.icon(
            onPressed: () => context.push('/capture'),
            icon: const Icon(Icons.notifications_none),
            label: const Text('Periksa catatan notifikasi'),
          ),
        const SizedBox(height: 12),
        Text('${entries.length} transaksi ditemukan'),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          EmptyState(
            'Tidak ada transaksi yang cocok.',
            'Coba periode atau filter lain.',
            action: 'Reset filter',
            onTap: reset,
          )
        else
          OutlinedSurface(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (var i = 0; i < entries.length && i < shown; i++) ...[
                  if (i == 0 ||
                      day(entries[i].businessDate) !=
                          day(entries[i - 1].businessDate))
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat(
                            'EEEE, d MMM yyyy',
                            'id_ID',
                          ).format(entries[i].businessDate),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  TransactionRow(entries[i], s),
                  if (i == entries.length - 1 ||
                      i == shown - 1 ||
                      day(entries[i].businessDate) !=
                          day(entries[i + 1].businessDate))
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pengeluaran bersih hari ini: ${rupiah(dailyExpenseNet(entries.where((e) => day(e.businessDate) == day(entries[i].businessDate))))}',
                        style: const TextStyle(
                          color: Palette.secondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        if (entries.length > shown)
          TextButton(
            onPressed: () => setState(() => shown += 50),
            child: const Text('Tampilkan lebih banyak'),
          ),
      ],
    );
  }
}

class BudgetScreen extends StatelessWidget {
  final FinanceSnapshot s;
  const BudgetScreen(this.s, {super.key});
  @override
  Widget build(BuildContext context) => PageBody(
    storageKey: 'budget',
    children: [
      Text(s.period.label),
      const SizedBox(height: 20),
      if (s.budget == null)
        EmptyState(
          'Tentukan batas belanja periode ini.',
          'Budget mencakup pengeluaran harian dan tagihan.',
          action: 'Atur budget',
          onTap: () => context.push('/budget/edit'),
        )
      else ...[
        OutlinedSurface(
          color: Palette.butter,
          shadow: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BATAS TOTAL',
                style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              MoneyText(s.budget!, size: 32),
              CategoryProgress('Terpakai', s.expense, s.budget!),
              DetailLine('Sisa aktual', s.budget! - s.expense),
              DetailLine('Disiapkan untuk tagihan', s.reserve),
            ],
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => context.push('/budget/edit'),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit budget'),
        ),
        const Section('Alokasi kategori'),
        OutlinedSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...s.allocations.entries.map(
                (a) =>
                    CategoryProgress(a.key, s.categoryActual(a.key), a.value),
              ),
              DetailLine(
                'Belum dialokasikan',
                s.budget! - s.allocations.values.fold(0, (a, b) => a + b),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Alokasi adalah pembagian dari batas total. Tagihan disisihkan sampai pembayarannya dicatat.',
        ),
      ],
    ],
  );
}

class AnalyticsScreen extends StatefulWidget {
  final FinanceSnapshot s;
  const AnalyticsScreen(this.s, {super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String? account, category;

  Future<void> showFilters(FinanceSnapshot snapshot) async {
    var selectedAccount = account;
    var selectedCategory = category;
    final categories = snapshot.categories.map((c) => c.name).toSet()
      ..addAll(
        snapshot.entries.map((e) => e.category).where((c) => c.isNotEmpty),
      );
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheet) => StatefulBuilder(
        builder: (sheet, updateSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter Ringkasan',
                        style: Theme.of(sheet).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup filter',
                      onPressed: () => Navigator.pop(sheet),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: selectedAccount ?? 'all',
                  decoration: const InputDecoration(labelText: 'Akun'),
                  items: [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('Semua akun'),
                    ),
                    ...snapshot.accounts.map(
                      (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                    ),
                  ],
                  onChanged: (value) => updateSheet(
                    () => selectedAccount = value == 'all' ? null : value,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: selectedCategory ?? 'all',
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('Semua kategori'),
                    ),
                    ...categories.map(
                      (c) => DropdownMenuItem(value: c, child: Text(c)),
                    ),
                  ],
                  onChanged: (value) => updateSheet(
                    () => selectedCategory = value == 'all' ? null : value,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      account = selectedAccount;
                      category = selectedCategory;
                    });
                    Navigator.pop(sheet);
                  },
                  child: const Text('Terapkan filter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final current = analyticsEntries(s, account: account, category: category);
    final merchants = topMerchants(s, account: account, category: category);
    final comparison = comparableExpense(
      s,
      account: account,
      category: category,
    );
    int net(String type) => current
        .where((e) => e.type == type)
        .fold(0, (sum, e) => sum + e.amount);
    final income = net('income');
    final gross = net('expense');
    final refund = net('refund');
    final expense = gross - refund;
    int categoryNet(String name) => current
        .where((e) => e.category == name)
        .fold(0, (sum, e) => sum + e.expenseNet);
    final categories =
        current
            .where((e) => ['expense', 'refund'].contains(e.type))
            .map((e) => e.category)
            .toSet()
            .toList()
          ..sort((a, b) => categoryNet(b).compareTo(categoryNet(a)));
    return PageBody(
      storageKey: 'analytics',
      children: [
        Text(s.period.label),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () => showFilters(s),
            icon: const Icon(Icons.tune_outlined),
            label: Text(
              account == null && category == null ? 'Filter' : 'Ubah filter',
            ),
          ),
        ),
        if (account != null || category != null) ...[
          Wrap(
            spacing: 8,
            children: [
              if (account != null)
                InputChip(
                  label: Text(s.accountName(account!)),
                  onDeleted: () => setState(() => account = null),
                ),
              if (category != null)
                InputChip(
                  label: Text(category!),
                  onDeleted: () => setState(() => category = null),
                ),
              TextButton(
                onPressed: () => setState(() {
                  account = null;
                  category = null;
                }),
                child: const Text('Reset'),
              ),
            ],
          ),
          const Text(
            'Filter hanya mengubah Ringkasan, bukan angka di Home.',
            style: TextStyle(color: Palette.secondary),
          ),
        ],
        const SizedBox(height: 12),
        if (current.isEmpty)
          EmptyState(
            'Belum ada transaksi yang cocok.',
            'Coba ubah filter atau catat transaksi baru.',
            action: account != null || category != null ? 'Reset filter' : null,
            onTap: () => setState(() {
              account = null;
              category = null;
            }),
          )
        else ...[
          OutlinedSurface(
            color: Palette.mint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailLine('Pemasukan', income),
                DetailLine('Pengeluaran kotor', gross),
                DetailLine('Refund', refund),
                DetailLine('Pengeluaran bersih', expense),
                const Divider(),
                DetailLine('Selisih', income - expense),
              ],
            ),
          ),
          if (categories.isNotEmpty) ...[
            const Section('Pengeluaran per kategori'),
            OutlinedSurface(
              child: Column(
                children: categories
                    .map((c) => DetailLine(c, categoryNet(c)))
                    .toList(),
              ),
            ),
          ],
          if (merchants.isNotEmpty) ...[
            const Section('Merchant teratas'),
            OutlinedSurface(
              child: Column(
                children: merchants
                    .map(
                      (merchant) => DetailLine(merchant.name, merchant.amount),
                    )
                    .toList(),
              ),
            ),
          ],
          const Section('Dibanding periode lalu'),
          OutlinedSurface(
            child: comparison == null
                ? const Text(
                    'Belum ada cakupan penuh pada periode sebelumnya untuk dibandingkan.',
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailLine(
                        '${DateFormat('d MMM', 'id_ID').format(comparison.currentStart)}–${DateFormat('d MMM', 'id_ID').format(comparison.currentEnd.subtract(const Duration(days: 1)))}',
                        comparison.current,
                      ),
                      DetailLine(
                        '${DateFormat('d MMM', 'id_ID').format(comparison.previousStart)}–${DateFormat('d MMM', 'id_ID').format(comparison.previousEnd.subtract(const Duration(days: 1)))}',
                        comparison.previous,
                      ),
                      Text(
                        comparison.percent == null
                            ? 'Belum ada pembanding: pengeluaran periode sebelumnya Rp0.'
                            : '${comparison.difference >= 0 ? 'Naik' : 'Turun'} ${comparison.percent!.abs().toStringAsFixed(0)}% dibanding rentang yang sama.',
                      ),
                    ],
                  ),
          ),
          const Section('Catatan harian'),
          OutlinedSurface(
            child: Column(
              children: [
                for (
                  var d = s.period.start;
                  !d.isAfter(day(profileNow(s.zone, s.now)));
                  d = d.add(const Duration(days: 1))
                )
                  DetailLine(
                    DateFormat('d MMM', 'id_ID').format(d),
                    current
                        .where((e) => day(e.businessDate) == d)
                        .fold(0, (a, e) => a + e.expenseNet),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Transfer dan penyesuaian saldo tidak masuk ringkasan.'),
        ],
      ],
    );
  }
}

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Akun')),
    body: SnapshotView(
      builder: (s) => PageBody(
        children: [
          const Text('SALDO TERCATAT'),
          MoneyText(s.liquid, size: 36),
          const SizedBox(height: 12),
          const Text(
            'Saldo ini berasal dari catatanmu, bukan saldo rekening real-time.',
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.push('/account/new'),
            icon: const Icon(Icons.add),
            label: const Text('Tambah akun'),
          ),
          for (final a in s.accounts) ...[
            const SizedBox(height: 16),
            OutlinedSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccountRow(a, s),
                  AccountActions(a),
                  DetailLine('Saldo awal', a.opening),
                  Text(
                    'Dicatat ${DateFormat('d MMM yyyy HH:mm', 'id_ID').format(profileNow(s.zone, a.opened))}',
                  ),
                  if (!a.archived)
                    TextButton(
                      onPressed: () => context.push('/entry?adjust=${a.id}'),
                      child: const Text('Sesuaikan saldo'),
                    ),
                  ...s.entries
                      .where((e) => e.account == a.id || e.destination == a.id)
                      .take(5)
                      .map((e) => TransactionRow(e, s)),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});
  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  bool done = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tagihan')),
    body: SnapshotView(
      builder: (s) => PageBody(
        children: [
          FilledButton.icon(
            onPressed: () => context.push('/bill/new'),
            icon: const Icon(Icons.add),
            label: const Text('Tambah tagihan'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Belum dibayar'),
                selected: !done,
                onSelected: (_) => setState(() => done = false),
              ),
              FilterChip(
                label: const Text('Selesai'),
                selected: done,
                onSelected: (_) => setState(() => done = true),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (s.bills.where((b) => (b.state != 'unpaid') == done).isEmpty)
            const EmptyState(
              'Belum ada tagihan.',
              'Jadwal tidak otomatis mengubah saldo.',
            ),
          ...s.bills
              .where((b) => (b.state != 'unpaid') == done)
              .map((b) => BillRow(b, s)),
        ],
      ),
    ),
  );
}

class BillRow extends ConsumerWidget {
  final Bill b;
  final FinanceSnapshot s;
  const BillRow(this.b, this.s, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final late =
        b.state == 'unpaid' && b.due.isBefore(day(profileNow(s.zone, s.now)));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlinedSurface(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    b.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (b.state == 'unpaid' && b.templateId != null)
                  PopupMenuButton<String>(
                    tooltip: 'Opsi jadwal ${b.name}',
                    onSelected: (value) async {
                      if (value == 'amount') {
                        await editBillAmount(context, ref, b);
                      } else {
                        await deactivateBillTemplate(context, ref, b);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'amount',
                        child: Text('Ubah nominal ini'),
                      ),
                      if (b.templateActive)
                        const PopupMenuItem(
                          value: 'deactivate',
                          child: Text('Nonaktifkan jadwal'),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${DateFormat('d MMM yyyy', 'id_ID').format(b.due)} · ${s.accountName(b.account)}',
            ),
            MoneyText(b.amount, size: 20),
            Text(
              b.state == 'skipped'
                  ? 'Dilewati'
                  : b.state == 'paid'
                  ? b.direction == 'income'
                        ? 'Sudah diterima'
                        : 'Selesai'
                  : b.direction == 'income'
                  ? 'Belum diterima'
                  : late
                  ? 'Terlambat · belum dibayar'
                  : 'Belum dibayar',
              style: TextStyle(
                color: late ? Palette.danger : Palette.secondary,
              ),
            ),
            if (b.state == 'unpaid')
              Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: () => context.push('/entry?bill=${b.id}'),
                    child: Text(
                      b.direction == 'income'
                          ? 'Catat penerimaan'
                          : 'Catat pembayaran',
                    ),
                  ),
                  TextButton(
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      builder: (c) => ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          const Text('Pilih transaksi yang sudah tercatat'),
                          ...s.entries
                              .where((e) => e.type == b.direction)
                              .map(
                                (e) => ListTile(
                                  title: Text(e.label),
                                  subtitle: Text(rupiah(e.amount)),
                                  onTap: () async {
                                    await runAction(
                                      context,
                                      () => ref
                                          .read(repositoryProvider)
                                          .linkBill(b.id, e.id),
                                      'Transaksi ditautkan',
                                    );
                                    if (c.mounted) Navigator.pop(c);
                                  },
                                ),
                              ),
                          TextButton(
                            onPressed: () => Navigator.pop(c),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Tautkan transaksi'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (await confirm(
                            context,
                            'Lewati tagihan ini?',
                            'Dana yang disisihkan untuk tagihan ini akan dilepas.',
                          ) &&
                          context.mounted) {
                        await runAction(
                          context,
                          () => ref.read(repositoryProvider).skipBill(b.id),
                          'Tagihan dilewati',
                        );
                      }
                    },
                    child: const Text('Lewati'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> editBillAmount(
  BuildContext context,
  WidgetRef ref,
  Bill bill,
) async {
  final controller = TextEditingController(text: bill.amount.toString());
  final key = GlobalKey<FormState>();
  try {
    final amount = await showDialog<int>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Ubah nominal tagihan ini'),
        content: Form(
          key: key,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Estimasi nominal (Rp)',
            ),
            validator: (value) {
              try {
                parseMoney(value ?? '');
                return null;
              } catch (_) {
                return 'Masukkan rupiah bulat yang valid.';
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                Navigator.pop(dialog, parseMoney(controller.text));
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (amount != null && context.mounted) {
      await runAction(
        context,
        () => ref.read(repositoryProvider).updateBillAmount(bill.id, amount),
        'Nominal tagihan diperbarui',
      );
    }
  } finally {
    controller.dispose();
  }
}

Future<void> deactivateBillTemplate(
  BuildContext context,
  WidgetRef ref,
  Bill bill,
) async {
  final skipFuture = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: const Text('Nonaktifkan jadwal?'),
      content: const Text(
        'Tagihan yang sudah selesai dan yang terlambat tetap ada. Pilih apa yang terjadi pada tagihan mendatang yang sudah dibuat.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialog),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialog, false),
          child: const Text('Tetap tampilkan'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialog, true),
          child: const Text('Lewati mendatang'),
        ),
      ],
    ),
  );
  if (skipFuture != null && context.mounted) {
    await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .deactivateTemplate(bill.templateId!, skipFuture: skipFuture),
      'Jadwal dinonaktifkan',
    );
  }
}

class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Periksa catatan')),
    body: defaultTargetPlatform == TargetPlatform.iOS
        ? const PageBody(
            children: [
              EmptyState(
                'Pencatatan manual di iPhone',
                'Catat pemasukan, pengeluaran, dan transfer melalui tombol + Catat. Versi iPhone tidak membaca notifikasi aplikasi bank atau e-wallet lain.',
              ),
            ],
          )
        : const PageBody(
            children: [
              EmptyState(
                'Belum ada transaksi untuk diperiksa.',
                'Pencatatan dari notifikasi belum tersedia pada build pengembangan ini. Belum ada sumber bank atau e-wallet yang terverifikasi.',
              ),
              SizedBox(height: 20),
              Text(
                'Pencatatan manual tetap tersedia tanpa akses notifikasi. Izin Android bukan koneksi rekening dan tidak menjamin seluruh transaksi dapat terbaca.',
              ),
            ],
          ),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pengaturan')),
    body: SnapshotView(
      builder: (s) => PageBody(
        children: [
          const Section('Catatan'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.category_outlined),
            title: const Text('Kelola kategori'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/categories'),
          ),
          OutlinedSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Zona profil: ${s.zone}'),
                const SizedBox(height: 8),
                Text('Awal siklus: tanggal ${s.anchor}'),
                const SizedBox(height: 8),
                const Text('Mata uang: Rupiah (IDR)'),
              ],
            ),
          ),
          if (defaultTargetPlatform == TargetPlatform.android) ...[
            const Section('Capture'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications_none),
              title: const Text('Sumber notifikasi'),
              subtitle: const Text('Belum ada sumber terverifikasi'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/capture'),
            ),
          ],
          const Section('Data'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.ios_share_outlined),
            title: const Text('Ekspor CSV'),
            subtitle: const Text('Pilih periode dan tujuan file'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/export'),
          ),
          const Section('Privasi'),
          const OutlinedSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.phonelink_lock_outlined),
                SizedBox(height: 12),
                Text(
                  'Data tersimpan di perangkat ini.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Tanpa login dan tanpa sinkronisasi cloud. Data dapat hilang saat aplikasi dihapus, perangkat direset, atau perangkat hilang.',
                ),
              ],
            ),
          ),
          const Section('Tentang'),
          const Text(
            'Versi pengembangan 0.1.0\nFondasi manual · belum untuk rilis publik.',
          ),
          const SizedBox(height: 12),
          Text(
            defaultTargetPlatform == TargetPlatform.iOS
                ? 'Versi iPhone mengutamakan pencatatan manual. Pengingat, app lock, dan penghapusan menyeluruh masih dalam tahap implementasi.'
                : 'Capture, pengingat, app lock, dan penghapusan menyeluruh masih dalam tahap implementasi.',
            style: const TextStyle(color: Palette.secondary),
          ),
        ],
      ),
    ),
  );
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String zone = 'Asia/Jakarta';
  int anchor = 1;
  bool consent = false, busy = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nama aplikasi')),
    body: PageBody(
      children: [
        const SizedBox(height: 24),
        const IconTile(Icons.auto_stories_outlined, color: Palette.butter),
        const SizedBox(height: 24),
        Text(
          'Kenali uangmu.\nAtur langkahmu.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        const Text(
          'Catat pengeluaran, sisihkan tagihan, dan lihat estimasi uang yang bisa kamu pakai.',
        ),
        const SizedBox(height: 24),
        const OutlinedSurface(
          color: Palette.mint,
          child: Text(
            'Catatanmu tersimpan di perangkat ini, tanpa login. Saldo berasal dari pembukuan lokal. Data bisa hilang saat uninstall atau perangkat hilang.',
          ),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          initialValue: zone,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Zona waktu pencatatan'),
          items: const [
            DropdownMenuItem(
              value: 'Asia/Jakarta',
              child: Text('WIB · Jakarta'),
            ),
            DropdownMenuItem(
              value: 'Asia/Makassar',
              child: Text('WITA · Makassar'),
            ),
            DropdownMenuItem(
              value: 'Asia/Jayapura',
              child: Text('WIT · Jayapura'),
            ),
          ],
          onChanged: (v) => setState(() => zone = v!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: anchor,
          decoration: const InputDecoration(labelText: 'Tanggal awal periode'),
          items: List.generate(
            31,
            (i) =>
                DropdownMenuItem(value: i + 1, child: Text('Tanggal ${i + 1}')),
          ),
          onChanged: (v) => setState(() => anchor = v!),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: consent,
          onChanged: (v) => setState(() => consent = v!),
          title: const Text(
            'Saya memahami penyimpanan lokal dan keterbatasan saldo.',
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: !consent || busy
              ? null
              : () async {
                  setState(() => busy = true);
                  try {
                    await ref
                        .read(repositoryProvider)
                        .completeOnboarding(zone: zone, anchor: anchor);
                    if (context.mounted) context.push('/account/new');
                  } catch (_) {
                    if (context.mounted) {
                      notify(context, 'Pengaturan belum tersimpan. Coba lagi.');
                    }
                  } finally {
                    if (mounted) setState(() => busy = false);
                  }
                },
          child: Text(busy ? 'Menyiapkan…' : 'Mulai mencatat'),
        ),
        const SizedBox(height: 12),
        const Text(
          'Akun dan budget dapat dilengkapi setelah langkah ini. Akses notifikasi tidak diperlukan.',
          style: TextStyle(color: Palette.secondary),
        ),
      ],
    ),
  );
}
