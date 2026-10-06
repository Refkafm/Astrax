import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app/app.dart';
import 'app/providers.dart';
import 'app/theme.dart';
import 'core/database/database.dart';
import 'core/database/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await initializeDateFormatting('id_ID');
  try {
    final repository = FinanceRepository(await openDatabase());
    await repository.initialize();
    runApp(
      ProviderScope(
        overrides: [repositoryProvider.overrideWithValue(repository)],
        child: const FinanceApp(),
      ),
    );
  } catch (_) {
    runApp(
      MaterialApp(
        theme: appTheme(),
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 48),
                    const SizedBox(height: 20),
                    const Text(
                      'Catatan belum bisa dibuka',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Penyimpanan aman tidak tersedia atau kunci perangkat tidak dapat dibaca. Data lama tidak dihapus. Tutup lalu buka kembali aplikasi.',
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: main,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
