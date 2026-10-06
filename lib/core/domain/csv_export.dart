import 'package:intl/intl.dart';

import 'finance.dart';

String csvCell(String value) {
  // Quoting alone does not stop spreadsheet software evaluating formulas.
  final guarded = RegExp(r'^[\s\uFEFF]*[=+\-@]').hasMatch(value)
      ? "'$value"
      : value;
  return '"${guarded.replaceAll('"', '""')}"';
}

String transactionCsv(FinanceSnapshot snapshot, DateTime start, DateTime end) {
  if (!start.isBefore(end)) throw ArgumentError('Periode tidak valid.');
  final accounts = {for (final a in snapshot.accounts) a.id: a.name};
  final rows =
      snapshot.entries
          .where(
            (e) =>
                !day(e.businessDate).isBefore(day(start)) &&
                day(e.businessDate).isBefore(day(end)),
          )
          .toList()
        ..sort((a, b) {
          final byDate = a.businessDate.compareTo(b.businessDate);
          return byDate != 0 ? byDate : a.id.compareTo(b.id);
        });
  final out = StringBuffer('\uFEFF');
  out.writeln(
    'id,tanggal_buku,waktu_transaksi,jenis,akun_asal,akun_tujuan,nominal_idr,kategori,merchant,catatan',
  );
  for (final e in rows) {
    out.writeln(
      [
        e.id,
        DateFormat('yyyy-MM-dd').format(e.businessDate),
        e.occurred.toIso8601String(),
        e.type,
        accounts[e.account] ?? e.account,
        e.destination == null
            ? ''
            : (accounts[e.destination] ?? e.destination!),
        e.amount.toString(),
        e.category,
        e.merchant,
        e.note,
      ].map(csvCell).join(','),
    );
  }
  return out.toString();
}
