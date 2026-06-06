import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/coffee_data.dart';
import '../../../../models/product/product.dart';
import '../../../../viewmodels/cart_viewmodel.dart';
import '../../../components/core/hoverable.dart';

const _categories = [
  (id: 'arabic', name: 'البن العربي', icon: '☕'),
  (id: 'turkish', name: 'البن التركي', icon: '⚱'),
  (id: 'espresso', name: 'الإسبريسو', icon: '⚡'),
];

class DesktopMenuPreviewSection extends ConsumerWidget {
  final bool isActive;
  const DesktopMenuPreviewSection({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyedSubtree(
      key: ValueKey('menu_preview_$isActive'),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionChild(
              isActive: isActive,
              delayMs: 0,
              child: Text(
                "قائمة المشروبات",
                style: AppTypography.arefRuqaa.copyWith(
                  fontSize: 36,
                  color: AppColors.textLight,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SectionChild(
              isActive: isActive,
              delayMs: 200,
              child: Text(
                "تصفح تشكيلتنا المتنوعة من أصناف القهوة",
                style: AppTypography.tajawal.copyWith(
                  color: AppColors.secondary.withValues(alpha: 0.5),
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 20 * 2) / 3;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _categories.length; i++) ...[
                        if (i > 0) const SizedBox(width: 20),
                        SizedBox(
                          width: cardWidth,
                          height: 300,
                          child: _CategoryCard(
                            isActive: isActive,
                            index: i,
                            categoryId: _categories[i].id,
                            categoryName: _categories[i].name,
                            icon: _categories[i].icon,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            SectionChild(
              isActive: isActive,
              delayMs: 600,
              child: Hoverable(
                onTap: () => context.push('/menu'),
                glowColor: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                child: FilledButton.icon(
                  onPressed: () => context.push('/menu'),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(
                    "استعرض القائمة كاملة",
                    style: AppTypography.tajawal.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final bool isActive;
  final int index;
  final String categoryId;
  final String categoryName;
  final String icon;

  const _CategoryCard({
    required this.isActive,
    required this.index,
    required this.categoryId,
    required this.categoryName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final items = products
        .where((p) => p.category == categoryId)
        .take(3)
        .toList();

    return SectionChild(
      isActive: isActive,
      delayMs: 400 + index * 150,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    categoryName,
                    style: AppTypography.elMessiri.copyWith(
                      fontSize: 16,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                Center(
                  child: Hoverable(
                    onTap: () => context.push('/menu', extra: categoryId),
                    glowColor: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "عرض الكل",
                        style: AppTypography.tajawal.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.coffee_rounded,
                      color: AppColors.primary.withValues(alpha: 0.4),
                      size: 14,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (int j = 0; j < items.length; j++) ...[
                    if (j > 0) const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _ProductTile(product: items[j]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends ConsumerStatefulWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  ConsumerState<_ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends ConsumerState<_ProductTile> {
  ProductSize? _selectedSize;

  List<ProductSize> get _sizes => widget.product.sizes ?? [];

  String get _displayPrice {
    if (_selectedSize != null) return toArabicNum(_selectedSize!.price);
    return toArabicNum(widget.product.price);
  }

  @override
  void initState() {
    super.initState();
    if (_sizes.isNotEmpty) _selectedSize = _sizes.first;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Hoverable(
      onTap: () => context.push('/menu/${product.id}'),
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    product.image,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  product.name,
                  style: AppTypography.elMessiri.copyWith(
                    fontSize: 10,
                    color: AppColors.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (_sizes.length > 1)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final s in _sizes) ...[
                    if (s != _sizes.first) const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () => setState(() => _selectedSize = s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedSize == s
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _selectedSize == s
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          s.label,
                          style: AppTypography.cairo.copyWith(
                            fontSize: 8,
                            color: _selectedSize == s
                                ? AppColors.primary
                                : AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            if (_sizes.length == 1)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  _sizes.first.label,
                  style: AppTypography.cairo.copyWith(
                    fontSize: 8,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            Row(
              children: [
                Text(
                  "$_displayPrice ج.م",
                  style: AppTypography.cairo.copyWith(
                    fontSize: 10,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Hoverable(
                  onTap: () {
                    ref
                        .read(cartProvider.notifier)
                        .addItem(product, 1, _selectedSize);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم إضافة ${product.name} للسلة',
                          style: AppTypography.cairo,
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  glowColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFFB5682A)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: AppColors.background,
                          size: 10,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "أضف",
                          style: AppTypography.cairo.copyWith(
                            color: AppColors.background,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
