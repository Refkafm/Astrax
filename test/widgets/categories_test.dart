import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:catatan_uang/core/database/database.dart' show AppDatabase;
import 'package:catatan_uang/core/database/repository.dart';
import 'package:catatan_uang/app/providers.dart';
import 'package:catatan_uang/app/theme.dart';
import 'package:catatan_uang/features/screens.dart';
import 'package:catatan_uang/features/management.dart';

void main() {
  testWidgets('custom category appears in management and financial summary', (
    tester,
  ) async {
    tz.initializeTimeZones();
    await initializeDateFormatting('id_ID');
    final now = DateTime.utc(2026, 10, 5, 2);
    final repo = FinanceRepository(
      AppDatabase(NativeDatabase.memory()),
      clock: () => now,
    );
    await repo.initialize();
    final a = await repo.addAccount('Tunai', 'cash', 1000);
    await repo.addCategory('Alat seni', 'expense');
    await repo.post(
      command: 'test',
      type: 'expense',
      account: a,
      amount: 100,
      occurred: now,
      category: 'Alat seni',
    );
    final s = await repo.snapshot();
    Widget wrap(Widget child) => ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        snapshotProvider.overrideWith((ref) => Stream.value(s)),
      ],
      child: MaterialApp(theme: appTheme(), home: child),
    );
    await tester.pumpWidget(wrap(const CategoriesScreen()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Alat seni'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Alat seni'), findsOneWidget);
    await tester.pumpWidget(wrap(Scaffold(body: AnalyticsScreen(s))));
    await tester.pumpAndSettle();
    expect(find.text('Alat seni'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await repo.close();
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
}
