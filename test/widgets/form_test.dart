import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:catatan_uang/core/database/database.dart' show AppDatabase;
import 'package:catatan_uang/core/database/repository.dart';
import 'package:catatan_uang/app/providers.dart';
import 'package:catatan_uang/app/theme.dart';
import 'package:catatan_uang/features/forms.dart';

void main() {
  testWidgets('entry validation retains form and financial ledger on failure', (
    tester,
  ) async {
    tz.initializeTimeZones();
    await initializeDateFormatting('id_ID');
    final now = DateTime.utc(2026, 10, 12, 2);
    final repo = FinanceRepository(
      AppDatabase(NativeDatabase.memory()),
      clock: () => now,
    );
    await repo.initialize();
    await repo.addAccount('Tunai', 'cash', 1000000);
    final snapshot = await repo.snapshot();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          snapshotProvider.overrideWith((ref) => Stream.value(snapshot)),
        ],
        child: MaterialApp(theme: appTheme(), home: const EntryForm()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nominal rupiah'),
      '1.23',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.widgetWithText(TextFormField, 'Nominal rupiah'),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      find.text('Gunakan rupiah bulat, misalnya 125000 atau Rp125.000.'),
      findsOneWidget,
    );
    expect((await repo.snapshot()).entries, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    await repo.close();
  });
}
