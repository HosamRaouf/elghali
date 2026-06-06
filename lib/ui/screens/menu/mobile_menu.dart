import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/coffee_data.dart';
import '../../../models/product/product.dart';
import '../../../viewmodels/cart_viewmodel.dart';
import '../../../viewmodels/favorites_viewmodel.dart';
import '../../components/core/custom_icons.dart';

class _SectionConfig {
  final String id;
  final String name;
  final String icon;
  const _SectionConfig(this.id, this.name, this.icon);
}

const _sections = [
  _SectionConfig('arabic', 'البن العربي', '☕'),
  _SectionConfig('turkish', 'البن التركي', '⚱'),
  _SectionConfig('espresso', 'الإسبريسو', '⚡'),
  _SectionConfig('french', 'البن الفرنساوي', '🥐'),
];

class MobileMenu extends ConsumerStatefulWidget {
  const MobileMenu({super.key});

  @override
  ConsumerState<MobileMenu> createState() => _MobileMenuState();
}

class _MobileMenuState extends ConsumerState<MobileMenu> {
  String _activeSection = _sections.first.id;
  String? _longPressId;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    for (final s in _sections) s.id: GlobalKey(),
  };
  final Map<String, GlobalKey> _productAnchorKeys = {
    for (final s in _sections) s.id: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    String active = _sections.first.id;
    double minDist = double.infinity;
    for (final s in _sections) {
      final ctx = _sectionKeys[s.id]?.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final pos = box.localToGlobal(Offset.zero);
      final dist = (pos.dy - 140).abs();
      if (dist < minDist) {
        minDist = dist;
        active = s.id;
      }
    }
    if (active != _activeSection) {
      setState(() => _activeSection = active);
    }
  }

  void _scrollTo(String id) {
    final ctx = _productAnchorKeys[id]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.0,
        duration: 500.ms,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  List<Product> _filteredForSection(String category) {
    if (_searchQuery.isEmpty) {
      return products.where((p) => p.category == category).toList();
    }
    return products
        .where(
          (p) =>
              p.category == category &&
              (p.name.contains(_searchQuery) ||
                  p.nameEn.toLowerCase().contains(_searchQuery.toLowerCase())),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasAnyResults = _sections.any(
      (s) => _filteredForSection(s.id).isNotEmpty,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                      child: const Icon(
                        Icons.home_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "قائمتنا",
                        style: AppTypography.arefRuqaa.copyWith(
                          fontSize: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        "${toArabicNum(products.length)} منتج، اضغط مطولا لمعرفة المزيد",
                        style: AppTypography.tajawal.copyWith(
                          color: AppColors.secondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  _CartIcon(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 42,
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: AppTypography.tajawal.copyWith(
                    color: AppColors.textLight,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'بحث عن منتج...',
                    hintStyle: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppColors.secondary,
                              size: 16,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final s = _sections[index];
                  final isActive = _activeSection == s.id;
                  return GestureDetector(
                    onTap: () => _scrollTo(s.id),
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? const LinearGradient(
                                colors: [AppColors.primary, Color(0xFFB5682A)],
                              )
                            : null,
                        color: isActive
                            ? null
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? Colors.transparent
                              : AppColors.primary.withValues(alpha: 0.15),
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        s.name,
                        style: AppTypography.cairo.copyWith(
                          color: isActive
                              ? AppColors.background
                              : AppColors.secondary,
                          fontSize: 13,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: hasAnyResults
                  ? ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        for (final s in _sections) _buildSection(s),
                        const SizedBox(height: 40),
                      ],
                    )
                  : Center(
                      child: Text(
                        'لا توجد نتائج',
                        style: AppTypography.tajawal.copyWith(
                          color: AppColors.secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(_SectionConfig section) {
    final items = _filteredForSection(section.id);
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      key: _sectionKeys[section.id],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              section.name,
              style: AppTypography.elMessiri.copyWith(
                fontSize: 20,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Divider(
                color: AppColors.primary.withValues(alpha: 0.12),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(key: _productAnchorKeys[section.id]),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++)
                    if (i % 2 == 0) _buildProductCard(items[i], i),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++)
                    if (i % 2 == 1) _buildProductCard(items[i], i),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product, int index) {
    final isTall = index % 3 == 0;
    final isLongPressed = _longPressId == product.id;

    return GestureDetector(
      onLongPressStart: (_) => setState(() => _longPressId = product.id),
      onLongPressEnd: (_) => setState(() => _longPressId = null),
      onTap: () {
        if (_longPressId != null) {
          setState(() => _longPressId = null);
          return;
        }
        context.push('/menu/${product.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: isTall ? 200 : 150,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xE60D0500)],
                      ),
                    ),
                  ),
                  if (product.isNew)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "جديد",
                          style: AppTypography.cairo.copyWith(
                            color: AppColors.background,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () => ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(product.id),
                      child: OctagonalStar(
                        size: 16,
                        filled: ref
                            .watch(favoritesProvider)
                            .contains(product.id),
                      ),
                    ),
                  ),
                  if (isLongPressed)
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xED0D0500),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 32,
                                height: 1,
                                color: AppColors.primary.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '"${product.sensory}"',
                                textAlign: TextAlign.center,
                                style: AppTypography.arefRuqaa.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 15,
                                  height: 1.8,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 32,
                                height: 1,
                                color: AppColors.primary.withValues(alpha: 0.4),
                              ),
                            ],
                          ).animate().fadeIn(duration: 200.ms),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.elMessiri.copyWith(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${toArabicNum(product.price)} ج.م",
                        style: AppTypography.cairo.copyWith(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(cartProvider.notifier)
                              .addItem(product, 1, null);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم إضافة ${product.name} للسلة',
                                style: AppTypography.cairo,
                              ),
                            ),
                          );
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: 200.ms,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, Color(0xFFB5682A)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              "+ أضف",
                              style: AppTypography.cairo.copyWith(
                                color: AppColors.background,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1, end: 0),
    );
  }
}

class _CartIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref
        .watch(cartProvider)
        .items
        .fold(0, (sum, item) => sum + item.quantity);
    return GestureDetector(
      onTap: () => context.push('/cart'),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            if (count > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFFB5682A)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: AppColors.background,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
