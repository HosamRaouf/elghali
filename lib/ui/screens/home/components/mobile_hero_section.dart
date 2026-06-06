import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../viewmodels/cart_viewmodel.dart';
import '../../../components/core/arabic_pattern.dart';
import '../../../components/core/hoverable.dart';
import '../../../components/core/logo_circle.dart';

class MobileHeroSection extends ConsumerWidget {
  final double? height;
  const MobileHeroSection({super.key, this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height ?? MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/hero.jpg",
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.4),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x801A0A00), Color(0xE61A0A00)],
              ),
            ),
          ),
          const Positioned.fill(
            child: ArabicPattern(opacity: 0.25),
          ).animate().fadeIn(delay: 5000.ms, duration: 1500.ms),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderIcon(
                  icon: Icons.person_outline_rounded,
                  onTap: () => context.push('/profile'),
                ),
                Column(
                  children: [
                    const LogoCircle(size: 80)
                        .animate()
                        .fadeIn(
                          delay: 500.ms,
                          duration: 1000.ms,
                          curve: Curves.easeInOutCubic,
                        )
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          curve: Curves.easeInOutCubic,
                        ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),

                        Text(
                              "بن الغالي",
                              style: AppTypography.arefRuqaa.copyWith(
                                color: AppColors.textLight,
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.8,
                                    ),
                                    blurRadius: 20,
                                  ),
                                  Shadow(
                                    color: const Color(
                                      0xFFFFD700,
                                    ).withValues(alpha: 0.5),
                                    blurRadius: 40,
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(
                              delay: 1500.ms,
                              duration: 1200.ms,
                              curve: Curves.easeInOutCubic,
                            )
                            .slideY(
                              begin: 0.15,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                        const SizedBox(height: 12),
                        Text(
                              "كل شروق طعم جديد",
                              style: AppTypography.tajawal.copyWith(
                                color: AppColors.textLight,
                                fontSize: 16,
                              ),
                            )
                            .animate()
                            .fadeIn(
                              delay: 1500.ms,
                              duration: 1200.ms,
                              curve: Curves.easeInOutCubic,
                            )
                            .slideY(
                              begin: 0.15,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                        const SizedBox(height: 32),
                        _MenuButton(),
                      ],
                    ),
                  ],
                ),
                _CartIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
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
        padding: const EdgeInsets.all(10),
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
              size: 24,
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

class _MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: () => context.push('/menu'),
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(24),
      child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFFB5682A)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Text(
              "عرض القائمة",
              style: AppTypography.tajawal.copyWith(
                color: AppColors.background,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
          .animate()
          .fadeIn(
            delay: 2200.ms,
            duration: 800.ms,
            curve: Curves.easeInOutCubic,
          )
          .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
    );
  }
}
