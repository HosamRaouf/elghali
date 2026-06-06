import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/coffee_data.dart';
import '../../../../models/product/product.dart';
import '../../../../viewmodels/cart_viewmodel.dart';
import '../../../../viewmodels/favorites_viewmodel.dart';
import '../../../components/core/arabic_pattern.dart' hide CoffeeBeanDivider;
import '../../../components/core/custom_icons.dart';
import '../../../components/core/hoverable.dart';

class DesktopFeaturedSection extends ConsumerWidget {
  final bool isActive;
  const DesktopFeaturedSection({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = products.where((p) => p.isFeatured).take(3).toList();
    return KeyedSubtree(
      key: ValueKey('featured_$isActive'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      SectionChild(
                        isActive: isActive,
                        delayMs: 0,
                        child: Text(
                          "الأكثر مبيعاً",
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
                          "اختيارات عملائنا المفضلة",
                          style: AppTypography.tajawal.copyWith(
                            color: AppColors.secondary.withValues(alpha: 0.5),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 60,
                  top: 0,
                  child: Row(
                    children: [
                      _CartIcon(),
                      const SizedBox(width: 24),
                      _ExploreMenuButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            height: 420,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    featured.length,
                    (i) => Padding(
                      padding: EdgeInsets.only(
                        left: i < featured.length - 1 ? 24 : 0,
                      ),
                      child: _DesktopFeaturedCard(
                        product: featured[i],
                        index: i,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopFeaturedCard extends ConsumerStatefulWidget {
  final Product product;
  final int index;
  const _DesktopFeaturedCard({required this.product, required this.index});

  @override
  ConsumerState<_DesktopFeaturedCard> createState() =>
      _DesktopFeaturedCardState();
}

class _DesktopFeaturedCardState extends ConsumerState<_DesktopFeaturedCard> {
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
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 40,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          AnimatedOpacity(
                            duration: 300.ms,
                            opacity: _isHovered ? 0 : 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xE60D0500),
                                  ],
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
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: const ArabicPattern(),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xCC1A0A00),
                                        Color(0xE60D0500),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _SensoryDivider(),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          product.sensory,
                                          style: AppTypography.arefRuqaa
                                              .copyWith(
                                                fontSize: 28,
                                                color: AppColors.primary,
                                                height: 1.5,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _SensoryDivider(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (product.isNew)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "جديد",
                                  style: AppTypography.cairo.copyWith(
                                    color: AppColors.background,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Hoverable(
                              onTap: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggleFavorite(product.id),
                              glowColor: AppColors.primary,
                              borderRadius: BorderRadius.circular(999),
                              child: OctagonalStar(
                                size: 20,
                                filled: ref
                                    .watch(favoritesProvider)
                                    .contains(product.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: AppTypography.elMessiri.copyWith(
                                fontSize: 16,
                                color: AppColors.textLight,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${toArabicNum(product.price)} ج.م",
                                  style: AppTypography.cairo.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Hoverable(
                                  onTap: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .addItem(product, 1, null);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'تم الإضافة',
                                          style: AppTypography.cairo,
                                        ),
                                      ),
                                    );
                                  },
                                  glowColor: AppColors.primary,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          Color(0xFFB5682A),
                                        ],
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (widget.index * 100).ms, duration: 500.ms)
        .slideY(begin: 0.1, end: 0);
  }
}

class _SensoryDivider extends StatelessWidget {
  const _SensoryDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 1,
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
        SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CoffeeBeanMenu(size: 10, color: AppColors.primary),
        ),
        SizedBox(height: 48),

        Container(
          width: 100,
          height: 1,
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ],
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
    return Hoverable(
      onTap: () => context.push('/cart'),
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primary,
              size: 28,
            ),
            if (count > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(5),
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
                      fontSize: 11,
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

class _ExploreMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: () => context.push('/menu'),
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              "عرض القائمة",
              style: AppTypography.tajawal.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
