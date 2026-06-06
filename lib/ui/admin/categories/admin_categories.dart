import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/coffee_data.dart';
import '../../../models/category/category.dart';
import '../../../viewmodels/admin_viewmodel.dart';
import '../../components/core/empty_state.dart';

class AdminCategories extends ConsumerStatefulWidget {
  const AdminCategories({super.key});

  @override
  ConsumerState<AdminCategories> createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends ConsumerState<AdminCategories> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProvider);
    final categories = _searchQuery.isEmpty
        ? state.categories
        : state.categories.where((c) =>
            c.name.contains(_searchQuery) || c.id.contains(_searchQuery)).toList();

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
                  Text("إدارة التصنيفات",
                    style: AppTypography.elMessiri.copyWith(fontSize: 28, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("اضغط على تصنيف لإدارة منتجاته",
                    style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 14)),
                ],
              ),
              GestureDetector(
                onTap: () => _showAddDialog(state),
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
                      Text("إضافة تصنيف",
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
                hintText: 'بحث عن تصنيف...',
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
          if (categories.isEmpty)
            const EmptyState(title: "لا توجد تصنيفات", subtitle: "أضف تصنيفاً جديداً للمنتجات", icon: "📁")
          else
            ...categories.asMap().entries.map((entry) => _buildCategoryCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(int index, Category category) {
    final state = ref.read(adminProvider);
    final productCount = state.products.where((p) => p.category == category.id).length;

    return GestureDetector(
      onTap: () => context.push('/admin/categories/${category.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(category.icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name,
                    style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text("${toArabicNum(productCount)} منتج",
                    style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.secondary),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => _confirmDelete(context, index, category),
              child: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(AdminState state) {
    final nameCtrl = TextEditingController();
    final iconCtrl = TextEditingController(text: "☕");

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D0500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("إضافة تصنيف جديد",
                style: AppTypography.elMessiri.copyWith(fontSize: 20, color: AppColors.textLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text("اسم التصنيف", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
              const SizedBox(height: 6),
              TextField(
                controller: nameCtrl,
                style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  hintText: "مثال: مشروبات ساخنة",
                  hintStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.5)),
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
                ),
              ),
              const SizedBox(height: 12),
              Text("الأيقونة", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
              const SizedBox(height: 6),
              TextField(
                controller: iconCtrl,
                style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 20),
                maxLength: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  hintText: "☕",
                  counterStyle: const TextStyle(color: AppColors.secondary, fontSize: 10),
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
                ),
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
                      if (name.isEmpty) return;
                      final id = name.replaceAll(" ", "-").toLowerCase();
                      ref.read(adminProvider.notifier).addCategory(Category(
                        id: id,
                        name: name,
                        icon: iconCtrl.text.trim().isNotEmpty ? iconCtrl.text.trim() : "☕",
                      ));
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("إضافة",
                        style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 13, fontWeight: FontWeight.bold)),
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

  void _confirmDelete(BuildContext context, int index, Category category) {
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
              const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 40),
              const SizedBox(height: 16),
              Text("حذف التصنيف", style: AppTypography.elMessiri.copyWith(fontSize: 18, color: AppColors.textLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("هل أنت متأكد من حذف ${category.name}؟",
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
                      ref.read(adminProvider.notifier).deleteCategory(index);
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
