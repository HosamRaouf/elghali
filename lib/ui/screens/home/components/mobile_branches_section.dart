import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/coffee_data.dart';
import '../../../../models/branch/branch.dart';
import '../../../components/core/hoverable.dart';

class MobileBranchesSection extends ConsumerWidget {
  const MobileBranchesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openCount = branches.where((b) => b.isOpen).length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFFB5682A)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "فروعنا",
                  style: AppTypography.arefRuqaa.copyWith(
                    fontSize: 32,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Hoverable(
                  glowColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  child: TextButton(
                    onPressed: () => context.push('/branches'),
                    child: const Text(
                      "عرض الكل",
                      style: TextStyle(color: AppColors.primary, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "${toArabicNum(openCount)} فروع مفتوحة الآن",
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textLight.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...branches.take(4).map((branch) => _BranchCard(branch: branch)),
          if (branches.length > 4)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Hoverable(
                onTap: () => context.push('/branches'),
                glowColor: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    "عرض جميع الفروع (${toArabicNum(branches.length)})",
                    textAlign: TextAlign.center,
                    style: AppTypography.tajawal.copyWith(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

class _BranchCard extends StatelessWidget {
  final Branch branch;
  const _BranchCard({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: branch.isOpen
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (branch.isOpen ? AppColors.primary : AppColors.secondary)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: branch.isOpen ? AppColors.primary : AppColors.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.name,
                    style: AppTypography.tajawal.copyWith(
                      color: AppColors.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    branch.address,
                    style: AppTypography.tajawal.copyWith(
                      color: AppColors.secondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: branch.isOpen
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                branch.isOpen ? "مفتوح" : "مغلق",
                style: AppTypography.tajawal.copyWith(
                  color: branch.isOpen
                      ? AppColors.primary
                      : AppColors.secondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
