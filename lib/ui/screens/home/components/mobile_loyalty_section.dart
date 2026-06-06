import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/coffee_data.dart';
import '../../../components/core/arabic_pattern.dart' hide CoffeeBeanDivider;
import '../../../components/core/hoverable.dart';
import 'coffee_bean_divider.dart';
import '../../../components/core/custom_icons.dart';

class MobileLoyaltySection extends ConsumerWidget {
  const MobileLoyaltySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userPoints = 1250;
    const currentLevel = "ذهبي";
    const nextLevel = "بلاتيني";
    const progress = 0.83;
    const nextPointsNeeded = 1500 - userPoints;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "برنامج المكافآت",
              style: AppTypography.tajawal.copyWith(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "كل فنجان يقرّبك من مكافأة",
            textAlign: TextAlign.center,
            style: AppTypography.arefRuqaa.copyWith(
              fontSize: 24,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "اجمع النقاط مع كل طلب واستبدلها بمكافآت حصرية",
            textAlign: TextAlign.center,
            style: AppTypography.tajawal.copyWith(
              color: AppColors.secondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          _buildPointsCard(userPoints, currentLevel, nextPointsNeeded, nextLevel, progress),
          const SizedBox(height: 20),
          Hoverable(
            onTap: () => context.push('/loyalty'),
            glowColor: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFB5682A)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "اكتشف المكافآت",
                textAlign: TextAlign.center,
                style: AppTypography.tajawal.copyWith(
                  color: AppColors.background,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard(
    int userPoints,
    String currentLevel,
    int nextPointsNeeded,
    String nextLevel,
    double progress,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B1800), Color(0xFF1A0A00), Color(0xFF2B1008)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: const ArabicPattern(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OctagonalStar(
                        size: 20,
                        color: AppColors.primary,
                        filled: i < 4,
                      )
                          .animate(onPlay: (controller) => controller.repeat(reverse: true))
                          .scale(
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1.1, 1.1),
                            duration: (2000 + i * 300).ms,
                            curve: Curves.easeInOut,
                          )
                          .custom(
                            builder: (context, value, child) => Opacity(
                              opacity: 0.4 + (value * 0.6),
                              child: child,
                            ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "رصيدك الحالي",
                  style: AppTypography.tajawal.copyWith(
                    color: AppColors.secondary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  toArabicNum(userPoints),
                  style: AppTypography.cairo.copyWith(
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    height: 1,
                  ),
                ).animate().scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                  duration: 800.ms,
                ),
                Text(
                  "نقطة",
                  style: AppTypography.tajawal.copyWith(
                    color: AppColors.secondary,
                    fontSize: 16,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CoffeeBeanDivider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "عضو $currentLevel",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${toArabicNum(nextPointsNeeded)} نقطة لـ$nextLevel",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Container(
                        height: 8,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          height: 8,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, Color(0xFFB5682A)],
                            ),
                          ),
                        )
                            .animate()
                            .shimmer(
                              duration: 2.seconds,
                              color: Colors.white.withValues(alpha: 0.2),
                            )
                            .animate()
                            .slideX(
                              begin: -1,
                              end: 0,
                              duration: 1.seconds,
                              curve: Curves.easeOut,
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
    );
  }
}
