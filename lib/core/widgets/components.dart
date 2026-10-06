import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../domain/finance.dart';

class OutlinedSurface extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool shadow;
  final EdgeInsets padding;
  const OutlinedSurface({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.shadow = false,
    this.padding = const EdgeInsets.all(20),
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(right: shadow ? 4 : 0, bottom: shadow ? 4 : 0),
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(shadow ? 24 : 18),
      border: Border.all(color: Palette.ink, width: 2),
      boxShadow: shadow
          ? [const BoxShadow(color: Palette.ink, offset: Offset(4, 4))]
          : null,
    ),
    child: child,
  );
}

class MoneyText extends StatelessWidget {
  final int value;
  final double size;
  final Color? color;
  const MoneyText(this.value, {super.key, this.size = 24, this.color});
  @override
  Widget build(BuildContext context) => Semantics(
    label: '$value rupiah',
    excludeSemantics: true,
    child: Text(
      rupiah(value),
      softWrap: true,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.25,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    ),
  );
}

class PageBody extends StatelessWidget {
  final List<Widget> children;
  final String? storageKey;
  const PageBody({super.key, required this.children, this.storageKey});
  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: ListView(
        key: storageKey == null ? null : PageStorageKey(storageKey),
        padding: EdgeInsets.fromLTRB(
          MediaQuery.sizeOf(context).width < 360 ? 16 : 20,
          8,
          20,
          112,
        ),
        children: children,
      ),
    ),
  );
}

class Section extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;
  const Section(this.title, {super.key, this.action, this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
      ],
    ),
  );
}

class EmptyState extends StatelessWidget {
  final String title, body;
  final String? action;
  final VoidCallback? onTap;
  const EmptyState(this.title, this.body, {super.key, this.action, this.onTap});
  @override
  Widget build(BuildContext context) => OutlinedSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.edit_note_rounded, size: 32),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(body),
        if (action != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: FilledButton(onPressed: onTap, child: Text(action!)),
          ),
      ],
    ),
  );
}

class DetailLine extends StatelessWidget {
  final String label;
  final int value;
  const DetailLine(this.label, this.value, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 16,
      runSpacing: 4,
      children: [Text(label), MoneyText(value, size: 16)],
    ),
  );
}

class IconTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  const IconTile(this.icon, {super.key, this.color = Palette.mint});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Palette.ink, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22),
    ),
  );
}

IconData accountIcon(String type) => type == 'bank'
    ? Icons.account_balance_outlined
    : type == 'cash'
    ? Icons.payments_outlined
    : Icons.account_balance_wallet_outlined;
IconData categoryIcon(String category) => switch (category) {
  'Makan & minum' => Icons.restaurant_outlined,
  'Transportasi' => Icons.directions_bus_outlined,
  'Belanja harian' => Icons.shopping_basket_outlined,
  'Tempat tinggal' => Icons.home_outlined,
  'Hiburan & langganan' => Icons.movie_outlined,
  _ => Icons.receipt_long_outlined,
};

class CategoryProgress extends StatelessWidget {
  final String category;
  final int actual, limit;
  const CategoryProgress(this.category, this.actual, this.limit, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: [
            Text('${rupiah(actual)} / ${rupiah(limit)}'),
            if (actual >= limit && actual > 0)
              Text(
                'Melebihi ${rupiah(actual - limit)}',
                style: const TextStyle(color: Palette.danger),
              ),
            if (limit > 0 && actual >= limit * .8 && actual < limit)
              const Text('Mendekati batas'),
          ],
        ),
        const SizedBox(height: 10),
        Semantics(
          label: '$category: ${rupiah(actual)} dari ${rupiah(limit)}',
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Palette.ink, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
            clipBehavior: Clip.antiAlias,
            child: LinearProgressIndicator(
              value: limit == 0 ? 0 : (actual / limit).clamp(0, 1),
              minHeight: 10,
              backgroundColor: Palette.subtle,
              color: actual > limit ? Palette.coral : Palette.primary,
            ),
          ),
        ),
      ],
    ),
  );
}
