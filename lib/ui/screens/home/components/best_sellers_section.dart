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
import '../../../components/core/custom_icons.dart';
import 'home_providers.dart';

class BestSellersSection extends ConsumerWidget {
  const BestSellersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = products.where((p) => p.isFeatured).toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D0500),
            Color(0x33C9A84C),
            Color(0x1A0D0500),
            Color(0xFF0D0500),
          ],
          stops: [0.0, 0.3, 0.8, 1.0],
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
                      width: 80,
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, AppColors.primary],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Text(
                          'الأكثر مبيعا',
                          style: AppTypography.arefRuqaa.copyWith(
                            color: AppColors.textLight,
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(color: Color(0x40C9A84C), blurRadius: 30),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 1000.ms, curve: Curves.easeOutCubic)
                        .slideY(begin: -0.2, end: 0),
                    const SizedBox(width: 24),
                    Container(
                      width: 80,
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, Colors.transparent],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'اختر مذاقك المفضل من نخبتنا المختارة',
                  style: TextStyle(
                    color: AppColors.secondary.withValues(alpha: 0.6),
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 1000.ms),
              ],
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 500,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 100,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featured.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return const SizedBox(width: 20);
                    final product = featured[index - 1];
                    return _BestSellerCard(product: product, index: index);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _BestSellerCard extends ConsumerWidget {
  final Product product;
  final int index;

  const _BestSellerCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = ref.watch(hoverStateProvider('bs_${product.id}'));
    final isFavorite = ref.watch(favoritesProvider).contains(product.id);
    final sensoryLines = product.sensory.split('...');

    return MouseRegion(
          onEnter: (_) => ref
              .read(hoverStateProvider('bs_${product.id}').notifier)
              .setHover(true),
          onExit: (_) => ref
              .read(hoverStateProvider('bs_${product.id}').notifier)
              .setHover(false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.push('/menu/${product.id}'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              width: 580,
              height: 220,
              margin: EdgeInsets.only(
                left: isHovered ? 40 : 32,
                right: isHovered ? 8 : 0,
              ),
              transform: Matrix4.diagonal3Values(
                isHovered ? 1.03 : 1.0,
                isHovered ? 1.03 : 1.0,
                1.0,
              ),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x4AC9A84C),
                    Color(0x1AFFFFFF),
                    Color(0x3A0D0500),
                    Color(0x4AB5682A),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(
                    alpha: isHovered ? 0.8 : 0.3,
                  ),
                  width: isHovered ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: isHovered ? 0.4 : 0.15,
                    ),
                    blurRadius: isHovered ? 50 : 25,
                    offset: Offset(0, isHovered ? 20 : 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(26),
                          ),
                          child: Image.asset(product.image, fit: BoxFit.cover),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(26),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [Colors.transparent, Color(0xE60D0500)],
                            ),
                          ),
                        ),
                        if (product.isNew)
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: () => ref
                                .read(favoritesProvider.notifier)
                                .toggleFavorite(product.id),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: OctagonalStar(
                                size: 24,
                                filled: isFavorite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              '🔥 الأكثر مبيعاً',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.name,
                            style: AppTypography.elMessiri.copyWith(
                              fontSize: 32,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: sensoryLines.length > 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        sensoryLines[0].trim(),
                                        style: TextStyle(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.9,
                                          ),
                                          fontSize: 16,
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '...${sensoryLines[1].trim()}',
                                        style: TextStyle(
                                          color: AppColors.textLight.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    product.sensory,
                                    style: TextStyle(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 16,
                                      height: 1.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'السعر',
                                    style: TextStyle(
                                      color: AppColors.secondary.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${toArabicNum(product.price)} ج.م',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                                      backgroundColor: AppColors.primary,
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
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
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: isHovered ? 0.6 : 0.4,
                                        ),
                                        blurRadius: isHovered ? 20 : 12,
                                        offset: Offset(0, isHovered ? 8 : 4),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.add_shopping_cart,
                                        color: AppColors.background,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'أضف للسلة',
                                        style: TextStyle(
                                          color: AppColors.background,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
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
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (index * 100).ms, duration: 600.ms)
        .slideX(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
  }
}
