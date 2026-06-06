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
import '../../components/core/arabic_pattern.dart' hide CoffeeBeanDivider;
import '../../components/core/custom_icons.dart';
import '../../components/core/hoverable.dart';
import '../../components/core/logo_circle.dart';

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

class DesktopMenu extends ConsumerStatefulWidget {
  final String? initialCategory;
  const DesktopMenu({super.key, this.initialCategory});

  @override
  ConsumerState<DesktopMenu> createState() => _DesktopMenuState();
}

class _DesktopMenuState extends ConsumerState<DesktopMenu> {
  String _activeSection = _sections.first.id;
  String _searchQuery = '';
  final Set<String> _expandedSections = {};
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    for (final s in _sections) s.id: GlobalKey(),
  };
  final Map<String, GlobalKey> _productAnchorKeys = {
    for (final s in _sections) s.id: GlobalKey(),
  };
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    final cat = widget.initialCategory;
    if (cat != null && _sections.any((s) => s.id == cat)) {
      _activeSection = cat;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ready = true;
      if (cat != null) _scrollTo(cat);
    });
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
    if (!mounted || !_ready) return;
    String active = _sections.first.id;
    double minDist = double.infinity;
    for (final s in _sections) {
      final ctx = _sectionKeys[s.id]?.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final pos = box.localToGlobal(Offset.zero);
      final dist = (pos.dy - 160).abs();
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
    if (_searchQuery.isEmpty) return products.where((p) => p.category == category).toList();
    return products.where((p) =>
      p.category == category &&
      (p.name.contains(_searchQuery) ||
       p.nameEn.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hasAnyResults = _sections.any((s) => _filteredForSection(s.id).isNotEmpty);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hoverable(
                    onTap: () => context.go('/home'),
                    glowColor: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                      ),
                      child: const Icon(Icons.home_outlined, color: AppColors.primary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("قائمتنا",
                        style: AppTypography.elMessiri.copyWith(fontSize: 32, color: AppColors.textLight)),
                      Text("${toArabicNum(products.length)} منتج",
                        style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 14)),
                    ],
                  ),
                  const Spacer(),
                  _DesktopCartIcon(),
                  const SizedBox(width: 16),
                  const LogoCircle(size: 56),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'بحث عن منتج...',
                    hintStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.5), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.secondary, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? Hoverable(
                            onTap: () { _searchController.clear(); setState(() => _searchQuery = ''); },
                            glowColor: AppColors.primary,
                            borderRadius: BorderRadius.circular(999),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(Icons.close, color: AppColors.secondary, size: 18),
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 60),
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final s = _sections[index];
                  final isActive = _activeSection == s.id;
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Hoverable(
                      onTap: () => _scrollTo(s.id),
                      glowColor: isActive ? Colors.transparent : AppColors.primary,
                      scale: isActive ? 1.0 : 1.06,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? const LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)])
                              : null,
                          color: isActive ? null : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isActive ? Colors.transparent : AppColors.primary.withValues(alpha: 0.15),
                          ),
                          boxShadow: isActive
                              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 4))]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.icon, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(s.name,
                              style: AppTypography.cairo.copyWith(
                                color: isActive ? AppColors.background : AppColors.secondary,
                                fontSize: 14,
                                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: hasAnyResults
                  ? ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      children: [
                        for (final s in _sections)
                          _buildSection(s, width),
                        const SizedBox(height: 60),
                      ],
                    )
                  : Center(
                      child: Text('لا توجد نتائج',
                        style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 16)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(_SectionConfig section, double width) {
    final allItems = _filteredForSection(section.id);
    if (allItems.isEmpty) return const SizedBox.shrink();
    final isExpanded = _expandedSections.contains(section.id);
    final displayItems = isExpanded ? allItems : allItems.take(3).toList();
    final remaining = allItems.length - 3;

    return Column(
      key: _sectionKeys[section.id],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            Text(section.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(section.name,
              style: AppTypography.elMessiri.copyWith(fontSize: 24, color: AppColors.textLight)),
            const SizedBox(width: 12),
            Expanded(child: Divider(color: AppColors.primary.withValues(alpha: 0.15), thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(key: _productAnchorKeys[section.id]),
        const SizedBox(height: 8),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (int i = 0; i < displayItems.length; i++)
              SizedBox(
                width: (width > 1500 ? 278.0 : (width > 1300 ? 250.0 : 220.0)),
                height: 400,
                child: _ProductCard(product: displayItems[i], index: i),
              ),
          ],
        ),
        if (!isExpanded && remaining > 0) ...[
          const SizedBox(height: 16),
          Center(
            child: Hoverable(
              onTap: () => setState(() => _expandedSections.add(section.id)),
              glowColor: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("عرض الكل",
                      style: AppTypography.tajawal.copyWith(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 14),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProductCard extends ConsumerStatefulWidget {
  final Product product; final int index;
  const _ProductCard({required this.product, required this.index});

  @override
  ConsumerState<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<_ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.push('/menu/${product.id}'),
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: 200.ms,
          child: AnimatedContainer(
            duration: 200.ms,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
              boxShadow: _isHovered
                  ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: 1)]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(product.image, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                      ),
                      AnimatedOpacity(
                        duration: 300.ms,
                        opacity: _isHovered ? 0 : 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            gradient: LinearGradient(
                              begin: Alignment.center, end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xE60D0500)],
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: 300.ms,
                        opacity: _isHovered ? 1 : 0,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: const ArabicPattern(),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                  colors: [Color(0xCC1A0A00), Color(0xE60D0500)],
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _SensoryDivider(),
                                  const SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(product.sensory,
                                      style: AppTypography.arefRuqaa.copyWith(fontSize: 14, color: AppColors.primary, height: 1.5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  _SensoryDivider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (product.isNew)
                        Positioned(top: 8, right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                            child: Text("جديد", style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      Positioned(top: 8, left: 8,
                        child: Hoverable(
                          onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(product.id),
                          glowColor: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                          child: OctagonalStar(size: 16, filled: ref.watch(favoritesProvider).contains(product.id)),
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
                      Text(product.name, style: AppTypography.elMessiri.copyWith(fontSize: 13, color: AppColors.textLight)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${toArabicNum(product.price)} ج.م",
                            style: AppTypography.cairo.copyWith(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold)),
                          Hoverable(
                            onTap: () {
                              ref.read(cartProvider.notifier).addItem(product, 1, null);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم إضافة ${product.name} للسلة', style: AppTypography.cairo)),
                              );
                            },
                            glowColor: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)]),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                              ),
                              child: Text("+ أضف", style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (widget.index * 60).ms).slideY(begin: 0.1, end: 0);
  }
}

class _SensoryDivider extends StatelessWidget {
  const _SensoryDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 28, height: 1, color: AppColors.primary.withValues(alpha: 0.25)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CoffeeBeanMenu(size: 10, color: AppColors.primary),
        ),
        Container(width: 28, height: 1, color: AppColors.primary.withValues(alpha: 0.25)),
      ],
    );
  }
}

class _DesktopCartIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartProvider).items.fold(0, (sum, item) => sum + item.quantity);
    return Hoverable(
      onTap: () => context.push('/cart'),
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(999),
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
            const Icon(Icons.shopping_cart_outlined, color: AppColors.primary, size: 22),
            if (count > 0)
              Positioned(
                right: -6, top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)]),
                    shape: BoxShape.circle,
                  ),
                  child: Text('$count', style: const TextStyle(color: AppColors.background, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
