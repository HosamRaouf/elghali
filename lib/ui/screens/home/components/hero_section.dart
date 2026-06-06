import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/breakpoints.dart';
import '../../../components/core/arabic_pattern.dart';
import '../../../components/core/logo_circle.dart';
import 'home_providers.dart';

class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final scrollOffset = ref.watch(scrollOffsetProvider);
    final parallaxOffset = scrollOffset * 0.3;
    final isDesktop =
        getDeviceType(MediaQuery.of(context).size.width) == DeviceType.desktop;

    return Container(
      height: screenHeight,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFF0D0500),
        //     Color(0xFF1A0A00),
        //     Color(0xFF2D1200),
        //     Color(0xFF1A0A00),
        //     Color(0xFF0D0500),
        //   ],
        //   stops: [0.0, 0.3, 0.6, 0.85, 1.0],
        // ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: Offset(0, -parallaxOffset),
            child: Image.asset(
              'assets/images/hero.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.3),
            ),
          ),
          if (!isDesktop)
            Positioned(
              top: 32,
              right: 40,
              child:
                  Row(
                        children: [
                          _HeroIconButton(
                            icon: Icons.person_outline,
                            onTap: () => context.push('/profile'),
                          ),
                          const SizedBox(width: 14),
                          _HeroIconButton(
                            icon: Icons.favorite_border,
                            onTap: () => context.push('/loyalty'),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 800.ms)
                      .slideX(begin: 0.2, end: 0),
            ),
          if (isDesktop)
            Positioned(
              top: 40,
              left: 60,
              right: 60,
              child:
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _OrderTypeTab(),
                          Row(
                            children: [
                              _HeroIconButton(
                                icon: Icons.favorite_border,
                                onTap: () => context.push('/loyalty'),
                              ),
                              const SizedBox(width: 20),
                              _HeroIconButton(
                                icon: Icons.person_outline,
                                onTap: () => context.push('/profile'),
                              ),
                            ],
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 800.ms)
                      .slideY(begin: -0.2, end: 0),
            ),
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Color(0xE60D0500),
          //         Color(0x551A0A00),
          //         Color(0x002D1200),
          //         Color(0x551A0A00),
          //         Color(0xE60D0500),
          //       ],
          //       stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          //     ),
          //   ),
          // ),
          const Positioned.fill(child: ArabicPattern(opacity: 0.15)),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const LogoCircle(size: 200)
                    .animate()
                    .fadeIn(duration: 1200.ms, curve: Curves.easeOutCubic)
                    .scale(
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1, 1),
                      duration: 1200.ms,
                      curve: Curves.easeOutBack,
                    ),
                const SizedBox(height: 40),
                Text(
                      'بن الغالي',
                      textAlign: TextAlign.center,
                      style: AppTypography.arefRuqaa.copyWith(
                        color: AppColors.primary,
                        fontSize: isDesktop ? 150 : 80,
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppColors.primary.withValues(alpha: 0.8),
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                          Shadow(
                            color: const Color(
                              0xFFFFD700,
                            ).withValues(alpha: 0.5),
                            blurRadius: 40,
                            offset: const Offset(0, 0),
                          ),
                          Shadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 80,
                            offset: const Offset(0, 0),
                          ),
                          Shadow(
                            color: const Color(
                              0xFFB5682A,
                            ).withValues(alpha: 0.2),
                            blurRadius: 150,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(
                      delay: 400.ms,
                      duration: 1500.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack)
                    .then()
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.02, 1.02),
                      duration: 4000.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(height: 60),
                Text(
                      'كل شروق .. ليه طعم تاني',
                      style: AppTypography.elMessiri.copyWith(
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    )
                    .animate()
                    .fadeIn(
                      delay: 800.ms,
                      duration: 1000.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 60),
                const Spacer(flex: 2),
                const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.secondary,
                      size: 36,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .slideY(
                      begin: 0,
                      end: 0.4,
                      duration: 1500.ms,
                      curve: Curves.easeInOutCubic,
                    )
                    .fadeIn(delay: 2000.ms, duration: 600.ms),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeroIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.45),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 16,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 26),
        ),
      ),
    );
  }
}

class _OrderTypeTab extends ConsumerWidget {
  const _OrderTypeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderType = ref.watch(orderTypeProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OrderTab(
            label: "توصيل",
            type: "delivery",
            isSelected: orderType == "delivery",
          ),
          _OrderTab(
            label: "استلام",
            type: "pickup",
            isSelected: orderType == "pickup",
          ),
        ],
      ),
    );
  }
}

class _OrderTab extends ConsumerWidget {
  final String label;
  final String type;
  final bool isSelected;

  const _OrderTab({
    required this.label,
    required this.type,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(orderTypeProvider.notifier).update(type),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.tajawal.copyWith(
            color: isSelected ? AppColors.background : AppColors.textLight,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
