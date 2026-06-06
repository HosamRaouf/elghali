import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/coffee_data.dart';
import '../../../components/core/arabic_pattern.dart';

class LoyaltySection extends StatelessWidget {
  const LoyaltySection({super.key});

  @override
  Widget build(BuildContext context) {
    const userPoints = 1250;
    const currentLevel = "ذهبي";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: const BoxDecoration(color: Color(0xFF0D0500)),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.15),
              Colors.transparent,
              AppColors.primary.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Stack(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 200,
              child: ArabicPattern(opacity: 0.5),
            ),
            const Positioned.fill(child: ArabicPattern(opacity: 0.05)),
            Padding(
              padding: const EdgeInsets.all(60),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "برنامج المكافآت",
                            style: AppTypography.tajawal.copyWith(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "استمتع بمميزات حصرية\nمع كل فنجان من بن الغالي",
                          style: AppTypography.arefRuqaa.copyWith(
                            color: AppColors.textLight,
                            fontSize: 48,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => context.push('/loyalty'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    Color(0xFFB5682A),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Text(
                                "اكتشف المكافآت",
                                style: AppTypography.tajawal.copyWith(
                                  color: AppColors.background,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 80),
                  Container(
                    width: 320,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 40,
                          offset: Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                              Icons.stars_rounded,
                              color: AppColors.primary,
                              size: 48,
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.1, 1.1),
                              duration: 2.seconds,
                              curve: Curves.easeInOut,
                            ),
                        const SizedBox(height: 24),
                        Text(
                          "رصيدك الحالي",
                          style: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          toArabicNum(userPoints),
                          style: AppTypography.cairo.copyWith(
                            color: AppColors.primary,
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        Text(
                          "نقطة",
                          style: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.7),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            "عضو $currentLevel",
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
