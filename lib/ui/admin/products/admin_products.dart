import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/coffee_data.dart';
import '../../../models/product/product.dart';
import '../../../viewmodels/admin_viewmodel.dart';
import '../../components/core/empty_state.dart';

class AdminProducts extends ConsumerStatefulWidget {
  const AdminProducts({super.key});

  @override
  ConsumerState<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends ConsumerState<AdminProducts> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProvider);
    final products = _searchQuery.isEmpty
        ? state.products
        : state.products.where((p) =>
            p.name.contains(_searchQuery) ||
            p.nameEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.category.contains(_searchQuery))
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
                  Text("إدارة المنتجات",
                    style: AppTypography.elMessiri.copyWith(fontSize: 28, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("إضافة وتعديل وحذف المنتجات",
                    style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 14)),
                ],
              ),
              GestureDetector(
                onTap: () => _showProductDialog(context, null, state),
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
          if (products.isEmpty)
            const EmptyState(title: "لا توجد منتجات", subtitle: "لم يتم العثور على منتجات", icon: "☕")
          else
            ...products.asMap().entries.map((entry) => _buildProductCard(entry.key, entry.value, state)),
        ],
      ),
    );
  }

  Widget _buildProductCard(int index, Product product, AdminState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(product.image, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(
              width: 48, height: 48, color: Colors.white.withValues(alpha: 0.05),
              child: const Icon(Icons.coffee, color: AppColors.primary, size: 24),
            )),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                  style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text("${product.nameEn} • ${toArabicNum(product.price)} ج.م",
                  style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 11)),
              ],
            ),
          ),
          Text(product.category,
            style: AppTypography.tajawal.copyWith(color: AppColors.primary, fontSize: 11)),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _showProductDialog(context, (index, product), state),
            child: Icon(Icons.edit_outlined, size: 18, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _confirmDelete(context, index, product),
            child: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context, (int, Product)? existing, AdminState state) {
    final isEdit = existing != null;
    final product = existing?.$2;
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final nameEnCtrl = TextEditingController(text: product?.nameEn ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final sensoryCtrl = TextEditingController(text: product?.sensory ?? '');
    String selectedCategory = product?.category ?? 'arabic';
    double price = product?.price ?? 0;
    final priceCtrl = TextEditingController(text: price > 0 ? price.toString() : '');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D0500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setDialogState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEdit ? "تعديل المنتج" : "إضافة منتج جديد",
                  style: AppTypography.elMessiri.copyWith(fontSize: 20, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildField("اسم المنتج (عربي)", nameCtrl),
                const SizedBox(height: 12),
                _buildField("اسم المنتج (إنجليزي)", nameEnCtrl),
                const SizedBox(height: 12),
                _buildField("الوصف", descCtrl, maxLines: 3),
                const SizedBox(height: 12),
                _buildField("الجملة الحسية", sensoryCtrl),
                const SizedBox(height: 12),
                _buildField("السعر", priceCtrl, isNumber: true),
                const SizedBox(height: 12),
                Text("التصنيف", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: const Color(0xFF1A0A00),
                  style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13),
                  decoration: _fieldDecoration,
                  items: state.categories.map((c) => DropdownMenuItem(value: c.id, child: Text("${c.icon} ${c.name}"))).toList(),
                  onChanged: (v) => setDialogState(() => selectedCategory = v ?? 'arabic'),
                ),
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
                        final p = Product(
                          id: isEdit ? product!.id : ref.read(adminProvider.notifier).generateId(),
                          name: name,
                          nameEn: nameEn,
                          category: selectedCategory,
                          price: double.tryParse(priceCtrl.text) ?? 0,
                          image: product?.image ?? "assets/images/product-1.jpg",
                          description: descCtrl.text.trim(),
                          sensory: sensoryCtrl.text.trim(),
                          tags: product?.tags ?? [],
                          isNew: product?.isNew ?? false,
                          isFeatured: product?.isFeatured ?? false,
                          sizes: product?.sizes,
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
    );
  }

  InputDecoration get _fieldDecoration => InputDecoration(
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

  Widget _buildField(String hint, TextEditingController ctrl, {int maxLines = 1, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint, style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13),
          decoration: _fieldDecoration,
        ),
      ],
    );
  }

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
