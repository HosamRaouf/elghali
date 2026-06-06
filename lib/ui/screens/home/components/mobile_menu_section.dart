import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../components/core/hoverable.dart';

class MobileMenuSection extends ConsumerWidget {
  const MobileMenuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),

      child: Column(
        children: [
          Text(
            "قائمتنا",
            style: AppTypography.arefRuqaa.copyWith(
              fontSize: 28,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "تصفح جميع منتجات بن الغالي من القهوة العربية والتركية والإسبريسو",
            textAlign: TextAlign.center,
            style: AppTypography.tajawal.copyWith(
              color: AppColors.secondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          Hoverable(
            onTap: () => context.push('/menu'),
            glowColor: AppColors.primary,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFB5682A)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                "عرض القائمة",
                style: AppTypography.tajawal.copyWith(
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
