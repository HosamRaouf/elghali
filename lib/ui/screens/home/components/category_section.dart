import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/coffee_data.dart';
import '../../../../models/product/product.dart';
import '../../../../viewmodels/cart_viewmodel.dart';
import 'home_providers.dart';

class CategorySection extends ConsumerWidget {
  final String category;

  const CategorySection({super.key, required this.category});

  static const Map<String, String> categoryLabels = {
    'arabic': 'قهوة عربية',
    'turkish': 'قهوة تركية',
    'espresso': 'إسبريسو',
    'french': 'قهوة فرنساوية',
  };

  static const Map<String, List<Color>> categoryGradients = {
    'arabic': [Color(0xFF0D0500), Color(0x2AC9A84C), Color(0xFF0D0500)],
    'turkish': [Color(0xFF0D0500), Color(0x2A8B4513), Color(0xFF0D0500)],
    'espresso': [Color(0xFF0D0500), Color(0x2A4A0E0E), Color(0xFF0D0500)],
    'french': [Color(0xFF0D0500), Color(0x2A8C6E5A), Color(0xFF0D0500)],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catProducts = products.where((p) => p.category == category).toList();
    final label = categoryLabels[category] ?? category;
    final gradient =
        categoryGradients[category] ?? categoryGradients['arabic']!;
    if (catProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradient,
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, AppColors.primary],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      label,
                      style: AppTypography.arefRuqaa.copyWith(
                        color: AppColors.textLight,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(color: Color(0x40C9A84C), blurRadius: 20),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Container(
                      width: 60,
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, Colors.transparent],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => context.push('/menu'),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'عرض القائمة الكاملة',
                          style: TextStyle(
                            color: AppColors.primary.withValues(alpha: 0.8),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary.withValues(alpha: 0.8),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(100),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  itemCount: catProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return const SizedBox(width: 20);
                    final product = catProducts[index - 1];
                    return _CategoryCard(product: product, index: index);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  final Product product;
  final int index;

  const _CategoryCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = ref.watch(hoverStateProvider('cat_${product.id}'));

    return MouseRegion(
          onEnter: (_) => ref
              .read(hoverStateProvider('cat_${product.id}').notifier)
              .setHover(true),
          onExit: (_) => ref
              .read(hoverStateProvider('cat_${product.id}').notifier)
              .setHover(false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.push('/menu/${product.id}'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: 280,
              margin: EdgeInsets.only(
                left: isHovered ? 32 : 24,
                right: isHovered ? 8 : 0,
                bottom: isHovered ? 8 : 0,
                top: isHovered ? 0 : 8,
              ),
              transform: Matrix4.diagonal3Values(
                isHovered ? 1.05 : 1.0,
                isHovered ? 1.05 : 1.0,
                1.0,
              ),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0x0AFFFFFF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withValues(
                    alpha: isHovered ? 0.6 : 0.15,
                  ),
                  width: isHovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.3),
                    blurRadius: isHovered ? 30 : 20,
                    offset: Offset(0, isHovered ? 15 : 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(23),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(product.image, fit: BoxFit.cover),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Color(0xE00D0500),
                                ],
                              ),
                            ),
                          ),
                          if (product.isNew)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'جديد',
                                  style: TextStyle(
                                    color: AppColors.background,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(23),
                      ),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0x0A0D0500), Color(0x2A0D0500)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: AppTypography.elMessiri.copyWith(
                            fontSize: 22,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${toArabicNum(product.price)} ج.م',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
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
                                    ),
                                  ),
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isHovered
                                        ? [
                                            const Color(0xFFC9A84C),
                                            const Color(0xFFD4A017),
                                          ]
                                        : [
                                            AppColors.primary,
                                            const Color(0xFFB5682A),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: isHovered ? 0.6 : 0.3,
                                      ),
                                      blurRadius: isHovered ? 16 : 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add_shopping_cart,
                                  color: AppColors.background,
                                  size: 22,
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
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (index * 80).ms, duration: 600.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
  }
}
