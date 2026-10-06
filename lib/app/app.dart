import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/screens.dart';
import '../features/forms.dart';
import '../features/management.dart';
import '../features/export_screen.dart';
import 'providers.dart';
import 'theme.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (c, s) => const RootScreen()),
    GoRoute(path: '/categories', builder: (c, s) => const CategoriesScreen()),
    GoRoute(path: '/accounts', builder: (c, s) => const AccountsScreen()),
    GoRoute(path: '/bills', builder: (c, s) => const BillsScreen()),
    GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
    GoRoute(path: '/export', builder: (c, s) => const ExportScreen()),
    GoRoute(path: '/capture', builder: (c, s) => const CaptureScreen()),
    GoRoute(
      path: '/entry',
      builder: (c, s) => EntryForm(
        entryId: s.uri.queryParameters['edit'],
        refundOf: s.uri.queryParameters['refund'],
        billId: s.uri.queryParameters['bill'],
        adjustAccount: s.uri.queryParameters['adjust'],
      ),
    ),
    GoRoute(path: '/account/new', builder: (c, s) => const AccountForm()),
    GoRoute(path: '/budget/edit', builder: (c, s) => const BudgetForm()),
    GoRoute(path: '/bill/new', builder: (c, s) => const BillForm()),
  ],
);

class FinanceApp extends ConsumerStatefulWidget {
  const FinanceApp({super.key});
  @override
  ConsumerState<FinanceApp> createState() => _FinanceAppState();
}

class _FinanceAppState extends ConsumerState<FinanceApp>
    with WidgetsBindingObserver {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    timer = Timer.periodic(const Duration(minutes: 1), (_) => refresh());
  }

  void refresh() {
    ref.read(repositoryProvider).refresh().catchError((Object _) {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refresh();
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: 'Catatan keuangan',
    theme: appTheme(),
    locale: const Locale('id', 'ID'),
    supportedLocales: const [Locale('id', 'ID')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    routerConfig: appRouter,
  );
}
