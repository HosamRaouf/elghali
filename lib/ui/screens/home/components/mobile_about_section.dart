import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../components/core/logo_circle.dart';

class MobileAboutSection extends ConsumerWidget {
  const MobileAboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        children: [
          const LogoCircle(size: 40, animated: false),
          const SizedBox(height: 16),
          Text(
            "حكاية بن الغالي",
            style: AppTypography.arefRuqaa.copyWith(
              fontSize: 26,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "منذ تأسيس بن الغالي، ونحن نقدم أجود أنواع القهوة العربية والتركية والإسبريسو،"
            " منتقاة من أفضل محاصيل البن حول العالم. كل فنجان نقدمه هو ثمرة شغفنا بفن القهوة"
            " وإيماننا بأن القهوة ليست مجرد مشروب، بل تجربة ثقافية واجتماعية أصيلة.",
            textAlign: TextAlign.center,
            style: AppTypography.tajawal.copyWith(
              color: AppColors.secondary,
              fontSize: 13,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 20),
          Opacity(
            opacity: 0.3,
            child: SizedBox(
              width: 160,
              child: Divider(
                color: AppColors.primary,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(label: "فروع", value: "٦"),
              _StatItem(label: "منتج", value: "٢٥+"),
              _StatItem(label: "صنف", value: "٤"),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.elMessiri.copyWith(
            fontSize: 28,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.tajawal.copyWith(
            color: AppColors.secondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
