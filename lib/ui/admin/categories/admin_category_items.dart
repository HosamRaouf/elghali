import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/coffee_data.dart';
import '../../../models/category/category.dart';
import '../../../models/product/product.dart';
import '../../../viewmodels/admin_viewmodel.dart';
import '../../../viewmodels/favorites_viewmodel.dart';
import '../../components/core/empty_state.dart';

class AdminCategoryItems extends ConsumerStatefulWidget {
  final String categoryId;

  const AdminCategoryItems({super.key, required this.categoryId});

  @override
  ConsumerState<AdminCategoryItems> createState() => _AdminCategoryItemsState();
}

class _AdminCategoryItemsState extends ConsumerState<AdminCategoryItems> {
  String _searchQuery = '';

  Category? get _category => ref.watch(adminProvider).categories.where((c) => c.id == widget.categoryId).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProvider);
    final cat = _category;
    if (cat == null) {
      return const Center(child: Text("التصنيف غير موجود", style: TextStyle(color: AppColors.error)));
    }

    final allItems = state.products.where((p) => p.category == widget.categoryId).toList();
    final items = _searchQuery.isEmpty
        ? allItems
        : allItems.where((p) =>
            p.name.contains(_searchQuery) ||
            p.nameEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            toArabicNum(p.price).contains(_searchQuery))
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text("العودة للتصنيفات",
                          style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(cat.icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Text(cat.name,
                        style: AppTypography.elMessiri.copyWith(fontSize: 28, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text("${toArabicNum(allItems.length)} منتج",
                    style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13)),
                ],
              ),
              GestureDetector(
                onTap: () => _showItemDialog(context, null, cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_rounded, color: AppColors.background, size: 18),
                      const SizedBox(width: 8),
                      Text("إضافة منتج",
                        style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 42,
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'بحث عن منتج...',
                hintStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.5), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondary, size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () => setState(() => _searchQuery = ''),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, color: AppColors.secondary, size: 18),
                        ),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (items.isEmpty)
            const EmptyState(title: "لا توجد منتجات", subtitle: "أضف منتجاً جديداً لهذا التصنيف", icon: "☕")
          else
            ...items.asMap().entries.map((entry) => _buildItemCard(entry.key, entry.value, cat)),
        ],
      ),
    );
  }

  Widget _buildItemCard(int index, Product product, Category cat) {
    return GestureDetector(
      onTap: () => _showItemDetail(context, index, product, cat),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(product.image, width: 48, height: 48, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 48, height: 48, color: Colors.white.withValues(alpha: 0.05),
                  child: const Icon(Icons.coffee, color: AppColors.primary, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                    style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(product.nameEn,
                    style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 11)),
                  if (product.sizes != null && product.sizes!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: product.sizes!.map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Text("${s.label}: ${toArabicNum(s.price)} ج.م",
                          style: AppTypography.tajawal.copyWith(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600)),
                      )).toList(),
                    ),
                  ] else ...[
                    const SizedBox(height: 2),
                    Text("${toArabicNum(product.price)} ج.م",
                      style: AppTypography.tajawal.copyWith(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                  if (product.isNew || product.isFeatured) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (product.isNew) _badge("جديد", AppColors.primary),
                        if (product.isNew && product.isFeatured) const SizedBox(width: 6),
                        if (product.isFeatured) _badge("مميز", AppColors.primary),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showItemDialog(context, (index, product), cat),
              child: Icon(Icons.edit_outlined, size: 18, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _confirmDelete(context, index, product),
              child: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
        style: AppTypography.tajawal.copyWith(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  int _orderCount(AdminState state, String productId) {
    int count = 0;
    for (final order in state.orders) {
      for (final item in order.items) {
        if (item.product.id == productId) {
          count += item.quantity;
        }
      }
    }
    return count;
  }

  void _showItemDetail(BuildContext context, int index, Product product, Category cat) {
    final adminState = ref.read(adminProvider);
    final favorites = ref.read(favoritesProvider);
    final orderCount = _orderCount(adminState, product.id);
    final inFavorites = favorites.contains(product.id);
    final mockFavTotal = (product.id.hashCode.abs() % 35 + 8) + (inFavorites ? 1 : 0);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D0500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 640),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(product.image, width: 80, height: 80, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80, height: 80, color: Colors.white.withValues(alpha: 0.05),
                                  child: const Icon(Icons.coffee, color: AppColors.primary, size: 40),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(product.name,
                                          style: AppTypography.elMessiri.copyWith(fontSize: 20, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                                      ),
                                      IconButton(
                                        onPressed: () { Navigator.pop(ctx); _showItemDialog(context, (index, product), cat); },
                                        icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 12),
                                      IconButton(
                                        onPressed: () { Navigator.pop(ctx); _confirmDelete(context, index, product); },
                                        icon: Icon(Icons.delete_outline_rounded, color: AppColors.error.withValues(alpha: 0.7), size: 20),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(product.nameEn,
                                    style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13)),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      if (product.isNew)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text("جديد", style: AppTypography.tajawal.copyWith(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      if (product.isFeatured)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text("مميز", style: AppTypography.tajawal.copyWith(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _detailRow("الوصف", product.description),
                        const SizedBox(height: 12),
                        _detailRow("الجملة الحسية", product.sensory),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white10, height: 1),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _infoChip(Icons.attach_money_rounded, "السعر الأساسي", "${toArabicNum(product.price)} ج.م"),
                            const SizedBox(width: 16),
                            if (product.calories != null)
                              _infoChip(Icons.local_fire_department_rounded, "السعرات", "${toArabicNum(product.calories!)}"),
                            if (product.tags.isNotEmpty) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("الوسوم", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 10)),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: product.tags.map((t) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                                        ),
                                        child: Text(t, style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 9)),
                                      )).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (product.sizes != null && product.sizes!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white10, height: 1),
                          const SizedBox(height: 16),
                          Text("المقاسات", style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: product.sizes!.map((s) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(s.label,
                                    style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Text("${toArabicNum(s.price)} ج.م",
                                    style: AppTypography.tajawal.copyWith(color: AppColors.background, fontSize: 12)),
                                ],
                              ),
                            )).toList(),
                          ),
                        ],
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white10, height: 1),
                        const SizedBox(height: 16),
                        Text("الإحصائيات", style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _statCard(Icons.shopping_bag_rounded, "مرات الطلب", toArabicNum(orderCount), orderCount > 0 ? AppColors.primary : AppColors.secondary),
                            const SizedBox(width: 12),
                            _statCard(Icons.favorite_rounded, "مفضل", "${toArabicNum(mockFavTotal)} مستخدم", mockFavTotal > 10 ? const Color(0xFFE57373) : AppColors.secondary),
                            const SizedBox(width: 12),
                            _statCard(Icons.coffee_rounded, "الصنف", "قطعة واحدة", AppColors.secondary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.primary.withValues(alpha: 0.1))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("إغلاق", style: AppTypography.cairo.copyWith(color: AppColors.primary, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value,
          style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13, height: 1.5)),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(label, style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statCard(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 6),
            Text(value,
              style: AppTypography.elMessiri.copyWith(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
              style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _showItemDialog(BuildContext context, (int, Product)? existing, Category cat) {
    final isEdit = existing != null;
    final product = existing?.$2;
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final nameEnCtrl = TextEditingController(text: product?.nameEn ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final sensoryCtrl = TextEditingController(text: product?.sensory ?? '');
    final priceCtrl = TextEditingController(text: product != null ? product.price.toString() : '');
    final sizes = List<ProductSize>.from(product?.sizes ?? []);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D0500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 520,
          padding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setDialogState) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(isEdit ? "تعديل المنتج" : "إضافة منتج جديد",
                        style: AppTypography.elMessiri.copyWith(fontSize: 20, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(cat.icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      Text(cat.name, style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("اسم المنتج (عربي)", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(controller: nameCtrl, style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13), decoration: _fieldDeco),
                  ]),
                  const SizedBox(height: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("اسم المنتج (إنجليزي)", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(controller: nameEnCtrl, style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13), decoration: _fieldDeco),
                  ]),
                  const SizedBox(height: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("الوصف", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(controller: descCtrl, maxLines: 3, style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13), decoration: _fieldDeco),
                  ]),
                  const SizedBox(height: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("الجملة الحسية", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(controller: sensoryCtrl, style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13), decoration: _fieldDeco),
                  ]),
                  const SizedBox(height: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("السعر الأساسي", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(controller: priceCtrl, keyboardType: TextInputType.number, style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13), decoration: _fieldDeco),
                  ]),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("المقاسات", style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => setDialogState(() => sizes.add(const ProductSize(label: '', price: 0))),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text("إضافة مقاس",
                                style: AppTypography.tajawal.copyWith(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (sizes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text("لا توجد مقاسات - سيستخدم السعر الأساسي",
                        style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 11)),
                    )
                  else
                    ...List.generate(sizes.length, (i) {
                      final size = sizes[i];
                      final labelCtrl = TextEditingController(text: size.label);
                      final priceSizeCtrl = TextEditingController(text: size.price > 0 ? size.price.toString() : '');
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: labelCtrl,
                                onChanged: (v) => setDialogState(() => sizes[i] = ProductSize(label: v, price: sizes[i].price)),
                                style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: "مثال: صغير",
                                  hintStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.4), fontSize: 11),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.04),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 90,
                              child: TextField(
                                controller: priceSizeCtrl,
                                onChanged: (v) => setDialogState(() => sizes[i] = ProductSize(label: sizes[i].label, price: double.tryParse(v) ?? 0)),
                                keyboardType: TextInputType.number,
                                style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: "السعر",
                                  hintStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.4), fontSize: 11),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.04),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => setDialogState(() => sizes.removeAt(i)),
                              child: Icon(Icons.remove_circle_outline, size: 18, color: AppColors.error.withValues(alpha: 0.6)),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text("إلغاء", style: AppTypography.cairo.copyWith(color: AppColors.secondary, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          final name = nameCtrl.text.trim();
                          final nameEn = nameEnCtrl.text.trim();
                          if (name.isEmpty || nameEn.isEmpty) return;
                          final cleanSizes = sizes.where((s) => s.label.isNotEmpty).toList();
                          final p = Product(
                            id: isEdit ? product!.id : ref.read(adminProvider.notifier).generateId(),
                            name: name,
                            nameEn: nameEn,
                            category: widget.categoryId,
                            price: double.tryParse(priceCtrl.text) ?? 0,
                            image: product?.image ?? "assets/images/product-1.jpg",
                            description: descCtrl.text.trim(),
                            sensory: sensoryCtrl.text.trim(),
                            tags: product?.tags ?? [],
                            isNew: product?.isNew ?? false,
                            isFeatured: product?.isFeatured ?? false,
                            sizes: cleanSizes.isNotEmpty ? cleanSizes : null,
                            calories: product?.calories,
                          );
                          if (isEdit) {
                            ref.read(adminProvider.notifier).updateProduct(existing.$1, p);
                          } else {
                            ref.read(adminProvider.notifier).addProduct(p);
                          }
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(isEdit ? "حفظ" : "إضافة",
                            style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration get _fieldDeco => InputDecoration(
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.05),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );

  void _confirmDelete(BuildContext context, int index, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D0500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 40),
              const SizedBox(height: 16),
              Text("حذف المنتج", style: AppTypography.elMessiri.copyWith(fontSize: 18, color: AppColors.textLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("هل أنت متأكد من حذف ${product.name}؟",
                style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("إلغاء", style: AppTypography.cairo.copyWith(color: AppColors.secondary, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      ref.read(adminProvider.notifier).deleteProduct(index);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("حذف", style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
