import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/domain/csv_export.dart';
import '../core/domain/finance.dart';
import 'screens.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});
  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  DateTime? start;
  DateTime? end;
  bool busy = false;

  Future<void> selectRange(FinanceSnapshot snapshot) async {
    final now = day(profileNow(snapshot.zone, snapshot.now));
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year, now.month, now.day),
      initialDateRange: DateTimeRange(
        start: start ?? snapshot.period.start,
        end: end?.subtract(const Duration(days: 1)) ?? now,
      ),
    );
    if (picked != null) {
      setState(() {
        start = day(picked.start);
        end = day(picked.end).add(const Duration(days: 1));
      });
    }
  }

  Future<void> export(FinanceSnapshot snapshot) async {
    if (busy) return;
    setState(() => busy = true);
    File? file;
    try {
      final from = start ?? snapshot.period.start;
      final until = end ?? snapshot.period.end;
      final dir = Directory(
        p.join((await getTemporaryDirectory()).path, 'catatan-uang-export'),
      );
      await dir.create(recursive: true);
      // Remove an interrupted prior export before creating another plaintext file.
      await for (final item in dir.list()) {
        if (item is File && item.path.endsWith('.csv')) {
          await item.delete();
        }
      }
      final stamp = DateFormat('yyyyMMdd-HHmmss').format(DateTime.now());
      file = File(p.join(dir.path, 'catatan-uang-$stamp.csv'));
      await file.writeAsString(
        transactionCsv(snapshot, from, until),
        flush: true,
      );
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'text/csv')],
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
      if (mounted && result.status == ShareResultStatus.success) {
        notify(context, 'CSV dibagikan. Periksa lokasi tujuan yang dipilih.');
      }
    } catch (_) {
      if (mounted) notify(context, 'Ekspor belum berhasil. Coba lagi.');
    } finally {
      if (file != null && await file.exists()) await file.delete();
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ekspor CSV')),
    body: SnapshotView(
      builder: (s) {
        final from = start ?? s.period.start;
        final until = end ?? s.period.end;
        final count = s.entries
            .where(
              (e) =>
                  !day(e.businessDate).isBefore(from) &&
                  day(e.businessDate).isBefore(until),
            )
            .length;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Pilih periode',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: busy ? null : () => selectRange(s),
              icon: const Icon(Icons.date_range_outlined),
              label: Text(
                '${DateFormat('d MMM yyyy', 'id_ID').format(from)} – ${DateFormat('d MMM yyyy', 'id_ID').format(until.subtract(const Duration(days: 1)))}',
              ),
            ),
            const SizedBox(height: 8),
            Text('$count transaksi dalam periode ini.'),
            const SizedBox(height: 24),
            const Text(
              'CSV memuat data finansial tanpa enkripsi, termasuk nama akun, merchant, dan catatan. Pilih tujuan penyimpanan yang Anda percayai. Salinan di lokasi tujuan berada di luar kendali aplikasi.',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: busy ? null : () => export(s),
              icon: const Icon(Icons.ios_share_outlined),
              label: Text(busy ? 'Menyiapkan CSV…' : 'Pilih tujuan ekspor'),
            ),
          ],
        );
      },
    ),
  );
}
