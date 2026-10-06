import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catatan_uang/app/providers.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:catatan_uang/app/theme.dart';
import 'package:catatan_uang/core/domain/finance.dart';
import 'package:catatan_uang/features/screens.dart';

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    await initializeDateFormatting('id_ID');
    final loader = FontLoader('PlusJakartaSans')
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans.ttf'));
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  FinanceSnapshot fixture() => FinanceSnapshot(
    accounts: [
      Account('b', 'BCA', 'bank', 4800000, DateTime.utc(2026, 10, 1)),
      Account('g', 'GoPay', 'e_wallet', 700000, DateTime.utc(2026, 10, 1)),
      Account('c', 'Tunai', 'cash', 500000, DateTime.utc(2026, 10, 1)),
    ],
    entries: [
      Entry(
        id: 'e',
        type: 'expense',
        account: 'b',
        amount: 1000000,
        occurred: DateTime.utc(2026, 10, 12, 1),
        businessDate: DateTime.utc(2026, 10, 12),
        category: 'Makan & minum',
        merchant: 'Makan & belanja',
      ),
    ],
    bills: [
      Bill(
        'bill',
        'Sewa kos',
        'b',
        'Tempat tinggal',
        'expense',
        'unpaid',
        1000000,
        DateTime.utc(2026, 10, 15),
      ),
    ],
    budget: 4000000,
    allocations: {'Makan & minum': 1500000},
    period: Period(DateTime.utc(2026, 10, 1), DateTime.utc(2026, 11, 1)),
    zone: 'Asia/Jakarta',
    anchor: 1,
    onboarded: true,
    now: DateTime.utc(2026, 10, 12, 2),
  );
  for (final size in [
    const Size(320, 700),
    const Size(360, 800),
    const Size(390, 844),
    const Size(430, 900),
    const Size(680, 900),
    const Size(844, 390),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('iOS Home layout ${size.width}x${size.height} scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final boundary = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            theme: appTheme(),
            locale: const Locale('id', 'ID'),
            supportedLocales: const [Locale('id', 'ID')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            builder: (c, child) => MediaQuery(
              data: MediaQuery.of(c).copyWith(
                textScaler: TextScaler.linear(scale),
                disableAnimations: true,
              ),
              child: child!,
            ),
            home: RepaintBoundary(
              key: boundary,
              child: ProviderScope(
                overrides: [
                  snapshotProvider.overrideWith(
                    (ref) => Stream.value(fixture()),
                  ),
                ],
                child: const RootScreen(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (size.width == 390 && scale == 1) {
          final saldoCard = find
              .ancestor(
                of: find.text('Saldo tercatat').first,
                matching: find.byType(InkWell),
              )
              .first;
          final tagihanCard = find
              .ancestor(
                of: find.text('Tagihan belum dibayar').first,
                matching: find.byType(InkWell),
              )
              .first;
          expect(
            tester.getSize(saldoCard).height,
            tester.getSize(tagihanCard).height,
          );
        }
        if (size.width == 390 && scale == 1) {
          await tester.runAsync(() async {
            final image =
                await (boundary.currentContext!.findRenderObject()
                        as RenderRepaintBoundary)
                    .toImage(pixelRatio: 2);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await Directory('docs/previews').create(recursive: true);
            await File('docs/previews/home-ios.png')
                .writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
        await tester.drag(find.byType(ListView).first, const Offset(0, -650));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Transaksi').last);
        await tester.pumpAndSettle();
        expect(find.text('Periksa catatan notifikasi'), findsNothing);
        expect(tester.takeException(), isNull);
        if (size.width == 390 && scale == 1) {
          expect(find.text('Filter'), findsOneWidget);
          await tester.tap(find.text('Filter'));
          await tester.pumpAndSettle();
          expect(find.text('Filter transaksi'), findsOneWidget);
          await tester.tap(find.text('Pemasukan'));
          await tester.tap(find.text('Terapkan filter'));
          await tester.pumpAndSettle();
          expect(find.text('Filter (1)'), findsOneWidget);
          expect(find.text('Tidak ada transaksi yang cocok.'), findsOneWidget);
        }
        await tester.tap(find.text('Ringkasan').last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (size.width == 390 && scale == 1) {
          await tester.tap(find.text('Filter').last);
          await tester.pumpAndSettle();
          expect(find.text('Filter Ringkasan'), findsOneWidget);
          await tester.tap(find.byType(DropdownButtonFormField<String>).first);
          await tester.pumpAndSettle();
          await tester.tap(find.text('BCA').last);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Terapkan filter'));
          await tester.pumpAndSettle();
          expect(find.text('Ubah filter'), findsOneWidget);
          expect(find.text('Reset'), findsOneWidget);
        }
        await tester.drag(find.byType(ListView).last, const Offset(0, -650));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
    }
  }
}
