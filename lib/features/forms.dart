import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../app/providers.dart';
import '../app/theme.dart';
import '../core/domain/finance.dart';
import '../core/widgets/components.dart';
import 'screens.dart';

String? moneyError(String? value, {bool zero = false}) {
  try {
    parseMoney(value ?? '', allowZero: zero);
    return null;
  } on FormatException catch (e) {
    return e.message;
  }
}

String? requiredText(String? value) =>
    value == null || value.trim().isEmpty ? 'Isi bagian ini.' : null;
Widget moneyInput(
  TextEditingController controller,
  String label, {
  bool zero = false,
}) => TextFormField(
  controller: controller,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: label, hintText: 'Rp0'),
  validator: (v) => moneyError(v, zero: zero),
);
Widget spaced(Widget child) =>
    Padding(padding: const EdgeInsets.only(bottom: 16), child: child);

class FormPage extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final VoidCallback? onSave;
  final bool busy, dirty;
  final String? error;
  const FormPage({
    super.key,
    required this.title,
    required this.formKey,
    required this.fields,
    required this.onSave,
    this.busy = false,
    this.dirty = true,
    this.error,
  });
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !dirty || busy,
    onPopInvokedWithResult: (didPop, result) async {
      if (!didPop &&
          await confirm(
            context,
            'Buang perubahan?',
            'Perubahan yang belum disimpan akan hilang.',
          ) &&
          context.mounted) {
        Navigator.of(context).pop();
      }
    },
    child: Scaffold(
      appBar: AppBar(title: Text(title)),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: FilledButton(
            onPressed: busy ? null : onSave,
            child: Text(busy ? 'Menyimpan…' : 'Simpan'),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: PageBody(
          children: [
            ...fields.map(spaced),
            if (error != null)
              spaced(
                Text(error!, style: const TextStyle(color: Palette.danger)),
              ),
          ],
        ),
      ),
    ),
  );
}

class AccountForm extends ConsumerStatefulWidget {
  const AccountForm({super.key});
  @override
  ConsumerState<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<AccountForm> {
  final key = GlobalKey<FormState>();
  final name = TextEditingController(), amount = TextEditingController();
  String type = 'bank';
  String? error;
  bool busy = false, saved = false;
  late final command = ref.read(repositoryProvider).newId();
  @override
  void dispose() {
    name.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FormPage(
    title: 'Tambah akun',
    formKey: key,
    busy: busy,
    dirty: !saved,
    error: error,
    fields: [
      const Text(
        'Akun adalah sumber uang, bukan akun login. Tidak perlu nomor rekening, PIN, atau OTP.',
      ),
      TextFormField(
        controller: name,
        decoration: const InputDecoration(
          labelText: 'Nama akun',
          hintText: 'Contoh: BCA atau Tunai',
        ),
        validator: requiredText,
      ),
      DropdownButtonFormField<String>(
        initialValue: type,
        decoration: const InputDecoration(labelText: 'Jenis akun'),
        items: const [
          DropdownMenuItem(value: 'bank', child: Text('Bank')),
          DropdownMenuItem(value: 'e_wallet', child: Text('E-wallet')),
          DropdownMenuItem(value: 'cash', child: Text('Tunai')),
        ],
        onChanged: (v) => setState(() => type = v!),
      ),
      moneyInput(amount, 'Saldo awal saat ini', zero: true),
      const Text(
        'Transaksi sebelum waktu saldo awal tidak dapat dicatat. Saldo bisa berbeda dari rekening bank.',
      ),
    ],
    onSave: () async {
      if (!key.currentState!.validate()) return;
      setState(() {
        busy = true;
        error = null;
      });
      try {
        await ref
            .read(repositoryProvider)
            .addAccount(
              name.text,
              type,
              parseMoney(amount.text, allowZero: true),
              command: command,
            );
        saved = true;
        if (context.mounted) {
          context.pop();
          notify(context, 'Akun tersimpan');
        }
      } catch (e) {
        setState(
          () => error = e is StateError
              ? e.message
              : 'Akun belum tersimpan. Coba lagi.',
        );
      } finally {
        if (mounted) setState(() => busy = false);
      }
    },
  );
}

class EntryForm extends ConsumerStatefulWidget {
  final String? entryId, refundOf, billId, adjustAccount;
  const EntryForm({
    super.key,
    this.entryId,
    this.refundOf,
    this.billId,
    this.adjustAccount,
  });
  @override
  ConsumerState<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends ConsumerState<EntryForm> {
  final key = GlobalKey<FormState>();
  final amount = TextEditingController(),
      fee = TextEditingController(),
      merchant = TextEditingController(),
      note = TextEditingController();
  String type = 'expense', category = 'Belum dikategorikan';
  String? account, destination, error;
  bool initialized = false, busy = false, saved = false;
  DateTime? occurred;
  late final command = ref.read(repositoryProvider).newId();
  @override
  void dispose() {
    for (final c in [amount, fee, merchant, note]) {
      c.dispose();
    }
    super.dispose();
  }

  void setup(FinanceSnapshot s) {
    if (initialized) return;
    if (s.activeAccounts.isEmpty) return;
    initialized = true;
    account = s.activeAccounts.firstOrNull?.id;
    occurred = s.now;
    final original = s.entries.where((e) => e.id == widget.entryId).firstOrNull;
    if (original != null) {
      type = original.type;
      category = original.category;
      account = original.account;
      destination = original.destination;
      amount.text = '${original.amount}';
      merchant.text = original.merchant;
      note.text = original.note;
      occurred = original.occurred;
      fee.text =
          '${s.entries.where((e) => e.parent == original.id).fold(0, (sum, e) => sum + e.amount)}';
    }
    if (widget.refundOf != null) {
      type = 'refund';
      final e = s.entries.firstWhere((e) => e.id == widget.refundOf);
      category = e.category;
      account = e.account;
      merchant.text = e.merchant;
    }
    if (widget.adjustAccount != null) {
      type = 'adjustment';
      account = widget.adjustAccount;
    }
    if (widget.billId != null) {
      final b = s.bills.firstWhere((b) => b.id == widget.billId);
      type = b.direction;
      category = b.category;
      account = b.account;
      amount.text = '${b.amount}';
      merchant.text = b.name;
    }
  }

  @override
  Widget build(BuildContext context) => SnapshotView(
    builder: (s) {
      setup(s);
      if (s.activeAccounts.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text('Catat transaksi')),
          body: PageBody(
            children: [
              EmptyState(
                'Tambahkan akun terlebih dahulu.',
                'Transaksi perlu sumber uang untuk menghitung saldo.',
                action: 'Tambah akun',
                onTap: () => context.push('/account/new'),
              ),
            ],
          ),
        );
      }
      final special =
          widget.entryId != null ||
          widget.refundOf != null ||
          widget.billId != null ||
          widget.adjustAccount != null;
      return FormPage(
        title: widget.entryId != null
            ? 'Edit transaksi'
            : type == 'refund'
            ? 'Catat refund'
            : type == 'adjustment'
            ? 'Sesuaikan saldo'
            : 'Catat transaksi',
        formKey: key,
        busy: busy,
        dirty: !saved,
        error: error,
        fields: [
          if (!special)
            Wrap(
              spacing: 8,
              children: [
                for (final t in {
                  'expense': 'Pengeluaran',
                  'income': 'Pemasukan',
                  'transfer': 'Transfer',
                }.entries)
                  ChoiceChip(
                    label: Text(t.value),
                    selected: type == t.key,
                    onSelected: (_) => setState(() {
                      type = t.key;
                      category = type == 'income'
                          ? 'Gaji'
                          : 'Belum dikategorikan';
                      destination = null;
                    }),
                  ),
              ],
            ),
          moneyInput(
            amount,
            type == 'adjustment' ? 'Saldo yang diketahui' : 'Nominal rupiah',
            zero: type == 'adjustment',
          ),
          DropdownButtonFormField<String>(
            initialValue: account,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: type == 'transfer' ? 'Akun asal' : 'Akun',
            ),
            items: s.accounts
                .where(
                  (a) =>
                      !a.archived ||
                      (widget.entryId != null &&
                          (a.id == account || a.id == destination)),
                )
                .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                .toList(),
            onChanged: (v) => setState(() => account = v),
            validator: (v) => v == null ? 'Pilih akun.' : null,
          ),
          if (type == 'transfer') ...[
            DropdownButtonFormField<String>(
              initialValue: destination,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Akun tujuan'),
              items: s.accounts
                  .where(
                    (a) =>
                        !a.archived ||
                        (widget.entryId != null &&
                            (a.id == account || a.id == destination)),
                  )
                  .map(
                    (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => destination = v),
              validator: (v) => v == null || v == account
                  ? 'Pilih akun tujuan yang berbeda.'
                  : null,
            ),
            moneyInput(fee, 'Biaya admin (isi 0 jika tidak ada)', zero: true),
          ] else if (type != 'adjustment')
            DropdownButtonFormField<String>(
              key: ValueKey('$type:$category'),
              initialValue: category,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: s
                  .categoryNames(
                    type == 'income' ? 'income' : 'expense',
                    include: widget.entryId != null || type == 'refund'
                        ? category
                        : null,
                  )
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: type == 'refund'
                  ? null
                  : (v) => setState(() => category = v!),
            ),
          OutlinedButton.icon(
            onPressed: type == 'adjustment'
                ? null
                : () async {
                    final local = profileNow(s.zone, occurred);
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime(local.year, local.month, local.day),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(
                        profileNow(s.zone, s.now).year,
                        profileNow(s.zone, s.now).month,
                        profileNow(s.zone, s.now).day,
                      ),
                    );
                    if (date == null || !context.mounted) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: local.hour,
                        minute: local.minute,
                      ),
                    );
                    if (time != null) {
                      setState(
                        () => occurred = tz.TZDateTime(
                          tz.getLocation(s.zone),
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        ).toUtc(),
                      );
                    }
                  },
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              DateFormat(
                'd MMM yyyy · HH:mm',
                'id_ID',
              ).format(profileNow(s.zone, occurred)),
            ),
          ),
          if (type == 'adjustment')
            const Text(
              'Penyesuaian menyimpan selisih saldo dan tidak masuk pemasukan, pengeluaran, atau budget.',
            )
          else
            TextFormField(
              controller: merchant,
              decoration: const InputDecoration(
                labelText: 'Merchant / nama (opsional)',
              ),
            ),
          TextFormField(
            controller: note,
            decoration: InputDecoration(
              labelText: type == 'adjustment'
                  ? 'Alasan penyesuaian'
                  : 'Catatan (opsional)',
            ),
            maxLines: 3,
            validator: type == 'adjustment' ? requiredText : null,
          ),
          if (widget.entryId != null)
            const Text(
              'Edit pembayaran yang ditautkan akan membuka kembali tagihan. Tautkan kembali setelah menyimpan.',
            ),
        ],
        onSave: () async {
          if (!key.currentState!.validate()) return;
          setState(() {
            busy = true;
            error = null;
          });
          try {
            final value = parseMoney(
              amount.text,
              allowZero: type == 'adjustment',
            );
            final original = s.entries
                .where((e) => e.id == widget.entryId)
                .firstOrNull;
            if (type == 'adjustment') {
              await ref
                  .read(repositoryProvider)
                  .adjustBalance(
                    command: command,
                    account: account!,
                    knownBalance: value,
                    reason: note.text,
                  );
            } else {
              await ref
                  .read(repositoryProvider)
                  .post(
                    command: command,
                    type: type,
                    account: account!,
                    amount: value,
                    occurred: type == 'adjustment'
                        ? ref.read(repositoryProvider).clock()
                        : occurred!,
                    category: category,
                    merchant: merchant.text,
                    note: note.text,
                    destination: type == 'transfer' ? destination : null,
                    fee: type == 'transfer'
                        ? parseMoney(fee.text, allowZero: true)
                        : 0,
                    refundOf: widget.refundOf ?? original?.refundOf,
                    billId: widget.billId,
                    editId: widget.entryId,
                  );
            }
            saved = true;
            if (context.mounted) {
              context.pop();
              notify(context, 'Transaksi tersimpan');
            }
          } catch (e) {
            if (mounted) {
              setState(
                () => error = e is StateError
                    ? e.message
                    : e is FormatException
                    ? e.message
                    : 'Transaksi belum tersimpan. Coba lagi.',
              );
            }
          } finally {
            if (mounted) setState(() => busy = false);
          }
        },
      );
    },
  );
}

class BudgetForm extends ConsumerStatefulWidget {
  const BudgetForm({super.key});
  @override
  ConsumerState<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends ConsumerState<BudgetForm> {
  final key = GlobalKey<FormState>();
  final total = TextEditingController();
  final allocations = <String, TextEditingController>{};
  bool initialized = false, busy = false, saved = false;
  String? error;
  @override
  void dispose() {
    total.dispose();
    for (final c in allocations.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SnapshotView(
    builder: (s) {
      if (!initialized) {
        initialized = true;
        total.text = s.budget?.toString() ?? '';
        for (final c in {
          ...s.categoryNames('expense'),
          ...s.allocations.keys,
        }) {
          allocations[c] = TextEditingController(
            text: s.allocations[c]?.toString() ?? '',
          );
        }
      }
      return FormPage(
        title: 'Atur budget',
        formKey: key,
        busy: busy,
        dirty: !saved,
        error: error,
        fields: [
          Text(s.period.label),
          if (s.period.partial)
            const Text(
              'Periode awal parsial: masukkan batas belanja tersisa sampai akhir periode, bukan perkiraan histori sebulan.',
            ),
          moneyInput(total, 'Batas total periode ini', zero: true),
          const Text(
            'Alokasi kategori (opsional)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const Text('Semua alokasi dan tagihan termasuk dalam batas total.'),
          for (final e in allocations.entries)
            TextFormField(
              controller: e.value,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: e.key,
                hintText: 'Belum dialokasikan',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? null : moneyError(v, zero: true),
            ),
        ],
        onSave: () async {
          if (!key.currentState!.validate()) return;
          if (s.budget != null &&
              !await confirm(
                context,
                'Ubah budget aktif?',
                'Batas baru berlaku untuk periode ini. Transaksi yang sudah tercatat tetap ada.',
              )) {
            return;
          }
          setState(() => busy = true);
          try {
            await ref.read(repositoryProvider).saveBudget(
              parseMoney(total.text, allowZero: true),
              {
                for (final e in allocations.entries)
                  if (e.value.text.isNotEmpty)
                    e.key: parseMoney(e.value.text, allowZero: true),
              },
            );
            saved = true;
            if (context.mounted) {
              context.pop();
              notify(context, 'Budget tersimpan');
            }
          } catch (e) {
            if (mounted) {
              setState(
                () => error = e is StateError
                    ? e.message
                    : 'Budget belum tersimpan.',
              );
            }
          } finally {
            if (mounted) setState(() => busy = false);
          }
        },
      );
    },
  );
}

class BillForm extends ConsumerStatefulWidget {
  const BillForm({super.key});
  @override
  ConsumerState<BillForm> createState() => _BillFormState();
}

class _BillFormState extends ConsumerState<BillForm> {
  final key = GlobalKey<FormState>();
  final name = TextEditingController(), amount = TextEditingController();
  String? account, error;
  String direction = 'expense',
      category = 'Belum dikategorikan',
      cadence = 'monthly';
  DateTime? first;
  bool busy = false, saved = false;
  @override
  void dispose() {
    name.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SnapshotView(
    builder: (s) {
      final title = direction == 'income'
          ? 'Tambah pemasukan terjadwal'
          : 'Tambah tagihan';
      account ??= s.activeAccounts.firstOrNull?.id;
      first ??= day(profileNow(s.zone, s.now));
      if (s.activeAccounts.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: PageBody(
            children: [
              EmptyState(
                'Tambahkan akun terlebih dahulu.',
                'Jadwal perlu akun untuk pencatatan pembayaran.',
                action: 'Tambah akun',
                onTap: () => context.push('/account/new'),
              ),
            ],
          ),
        );
      }
      return FormPage(
        title: title,
        formKey: key,
        busy: busy,
        dirty: !saved,
        error: error,
        fields: [
          const Text(
            'Jadwal tidak mengubah saldo. Pembayaran atau penerimaan dicatat saat benar-benar terjadi.',
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              labelText: direction == 'income'
                  ? 'Nama pemasukan'
                  : 'Nama tagihan',
            ),
            validator: requiredText,
          ),
          DropdownButtonFormField<String>(
            initialValue: direction,
            decoration: const InputDecoration(labelText: 'Jenis'),
            items: const [
              DropdownMenuItem(
                value: 'expense',
                child: Text('Tagihan pengeluaran'),
              ),
              DropdownMenuItem(
                value: 'income',
                child: Text('Jadwal pemasukan'),
              ),
            ],
            onChanged: (v) => setState(() {
              direction = v!;
              category = direction == 'income' ? 'Gaji' : 'Belum dikategorikan';
            }),
          ),
          moneyInput(amount, 'Estimasi nominal'),
          DropdownButtonFormField<String>(
            initialValue: account,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Akun'),
            items: s.activeAccounts
                .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                .toList(),
            onChanged: (v) => setState(() => account = v),
          ),
          DropdownButtonFormField<String>(
            key: ValueKey(direction),
            initialValue: category,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Kategori'),
            items: s
                .categoryNames(direction)
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => category = v!),
          ),
          DropdownButtonFormField<String>(
            initialValue: cadence,
            decoration: const InputDecoration(labelText: 'Pengulangan'),
            items: const [
              DropdownMenuItem(value: 'monthly', child: Text('Bulanan')),
              DropdownMenuItem(value: 'weekly', child: Text('Mingguan')),
            ],
            onChanged: (v) => setState(() => cadence = v!),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: first,
                firstDate: DateTime(2020),
                lastDate: DateTime(s.now.year + 5),
              );
              if (selected != null) setState(() => first = day(selected));
            },
            icon: const Icon(Icons.event_outlined),
            label: Text(
              'Pertama: ${DateFormat('d MMM yyyy', 'id_ID').format(first!)}',
            ),
          ),
          const Text(
            'Pengingat perangkat belum tersedia pada build ini. Jadwal tetap muncul di daftar tagihan.',
          ),
        ],
        onSave: () async {
          if (!key.currentState!.validate()) return;
          setState(() => busy = true);
          try {
            await ref
                .read(repositoryProvider)
                .addTemplate(
                  name: name.text,
                  account: account!,
                  category: category,
                  direction: direction,
                  amount: parseMoney(amount.text),
                  cadence: cadence,
                  first: first!,
                );
            saved = true;
            if (context.mounted) {
              context.pop();
              notify(
                context,
                direction == 'income'
                    ? 'Pemasukan terjadwal tersimpan'
                    : 'Tagihan tersimpan',
              );
            }
          } catch (_) {
            if (mounted) {
              setState(() => error = 'Belum tersimpan. Coba lagi.');
            }
          } finally {
            if (mounted) setState(() => busy = false);
          }
        },
      );
    },
  );
}
