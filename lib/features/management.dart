import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../core/domain/finance.dart';
import '../core/widgets/components.dart';
import 'screens.dart';

Future<String?> requestName(
  BuildContext context,
  String title, {
  String initial = '',
}) => showDialog<String>(
  context: context,
  builder: (_) => _NameDialog(title: title, initial: initial),
);

class _NameDialog extends StatefulWidget {
  final String title, initial;
  const _NameDialog({required this.title, required this.initial});
  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final controller = TextEditingController(text: widget.initial);
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: Form(
      key: form,
      child: TextFormField(
        controller: controller,
        autofocus: true,
        maxLength: 60,
        decoration: const InputDecoration(labelText: 'Nama'),
        validator: (v) =>
            v == null || v.trim().isEmpty ? 'Isi nama terlebih dahulu.' : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: () {
          if (form.currentState!.validate()) {
            Navigator.pop(context, controller.text);
          }
        },
        child: const Text('Simpan'),
      ),
    ],
  );
}

class AccountActions extends ConsumerWidget {
  final Account account;
  const AccountActions(this.account, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (account.archived)
        const Text(
          'Diarsipkan · riwayat tetap tersimpan',
          style: TextStyle(color: Palette.secondary),
        ),
      Wrap(
        spacing: 8,
        children: [
          TextButton(
            onPressed: () async {
              final name = await requestName(
                context,
                'Ubah nama akun',
                initial: account.name,
              );
              if (name != null && context.mounted) {
                await runAction(
                  context,
                  () => ref
                      .read(repositoryProvider)
                      .renameAccount(account.id, name),
                  'Nama akun diperbarui',
                );
              }
            },
            child: const Text('Ubah nama'),
          ),
          TextButton(
            onPressed: () async {
              if (!await confirm(
                context,
                account.archived ? 'Aktifkan akun?' : 'Arsipkan akun?',
                account.archived ? 'Akun kembali tersedia untuk pencatatan.' : 'Saldo harus nol dan akun tidak boleh digunakan jadwal. Riwayat tetap ada.',
              )) {
                return;
              }
              if (context.mounted) {
                await runAction(
                  context,
                  () => ref
                      .read(repositoryProvider)
                      .archiveAccount(account.id, !account.archived),
                  'Status akun diperbarui',
                );
              }
            },
            child: Text(account.archived ? 'Aktifkan kembali' : 'Arsipkan'),
          ),
          TextButton(
            onPressed: () async {
              if (!await confirm(
                context,
                'Hapus akun?',
                'Hanya akun tanpa riwayat transaksi atau jadwal yang dapat dihapus. Saldo awal akun juga dihapus.',
              )) {
                return;
              }
              if (context.mounted) {
                await runAction(
                  context,
                  () => ref.read(repositoryProvider).deleteAccount(account.id),
                  'Akun dihapus',
                );
              }
            },
            child: const Text(
              'Hapus akun',
              style: TextStyle(color: Palette.danger),
            ),
          ),
        ],
      ),
    ],
  );
}

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});
  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  String type = 'expense';
  bool archived = false, busy = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Kategori')),
    body: SnapshotView(
      builder: (s) => PageBody(
        children: [
          const Text(
            'Kategori membantu melihat uangmu dipakai untuk apa. Arsip menyembunyikan kategori dari pilihan baru; catatan lama tetap ada.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Pengeluaran'),
                selected: type == 'expense',
                onSelected: (_) => setState(() => type = 'expense'),
              ),
              ChoiceChip(
                label: const Text('Pemasukan'),
                selected: type == 'income',
                onSelected: (_) => setState(() => type = 'income'),
              ),
              FilterChip(
                label: const Text('Arsip'),
                selected: archived,
                onSelected: (v) => setState(() => archived = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: busy
                ? null
                : () async {
                    final name = await requestName(context, 'Tambah kategori');
                    if (name == null || !context.mounted) return;
                    setState(() => busy = true);
                    await runAction(
                      context,
                      () =>
                          ref.read(repositoryProvider).addCategory(name, type),
                      'Kategori ditambahkan',
                    );
                    if (mounted) setState(() => busy = false);
                  },
            icon: const Icon(Icons.add),
            label: const Text('Tambah kategori'),
          ),
          const SizedBox(height: 20),
          if (!s.categories.any(
            (c) => c.type == type && c.archived == archived,
          ))
            const EmptyState(
              'Belum ada kategori di sini.',
              'Tambahkan kategori atau pilih daftar aktif.',
            ),
          ...s.categories
              .where((c) => c.type == type && c.archived == archived)
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OutlinedSurface(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          c.isSystem ? 'Kategori bawaan' : 'Kategori buatanmu',
                          style: const TextStyle(color: Palette.secondary),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (!await confirm(
                              context,
                              c.archived
                                  ? 'Aktifkan kategori?'
                                  : 'Arsipkan kategori?',
                              'Riwayat transaksi tidak diubah.',
                            )) {
                              return;
                            }
                            if (context.mounted) {
                              await runAction(
                                context,
                                () => ref
                                    .read(repositoryProvider)
                                    .archiveCategory(
                                      c.name,
                                      c.type,
                                      !c.archived,
                                    ),
                                'Kategori diperbarui',
                              );
                            }
                          },
                          child: Text(
                            c.archived ? 'Aktifkan kembali' : 'Arsipkan',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}
