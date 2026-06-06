import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../components/core/arabic_pattern.dart';
import '../../../components/core/hoverable.dart';
import '../../../components/core/logo_circle.dart';

class DesktopAboutSection extends ConsumerWidget {
  final bool isActive;
  const DesktopAboutSection({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyedSubtree(
      key: ValueKey('about_$isActive'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: ArabicPattern(opacity: 0.7)),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SectionChild(
                    isActive: isActive,
                    delayMs: 0,
                    child: const LogoCircle(size: 160, animated: false),
                  ),
                  const SizedBox(height: 24),
                  SectionChild(
                    isActive: isActive,
                    delayMs: 200,
                    child: Text(
                      "حكاية بن الغالي",
                      style: AppTypography.arefRuqaa.copyWith(
                        fontSize: 40,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionChild(
                    isActive: isActive,
                    delayMs: 400,
                    child: Text(
                      "منذ تأسيس بن الغالي، ونحن نقدم أجود أنواع القهوة العربية والتركية والإسبريسو،"
                      " منتقاة من أفضل محاصيل البن حول العالم. كل فنجان نقدمه هو ثمرة شغفنا بفن القهوة"
                      " وإيماننا بأن القهوة ليست مجرد مشروب، بل تجربة ثقافية واجتماعية أصيلة.",
                      textAlign: TextAlign.center,
                      style: AppTypography.tajawal.copyWith(
                        color: AppColors.secondary,
                        fontSize: 18,
                        height: 1.9,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Opacity(
                    opacity: 0.3,
                    child: SizedBox(
                      width: 200,
                      child: Divider(color: AppColors.primary, thickness: 1),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SectionChild(
                    isActive: isActive,
                    delayMs: 600,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(label: "فروع", value: "٦"),
                        _StatItem(label: "منتج", value: "٢٥+"),
                        _StatItem(label: "صنف", value: "٤"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            fontSize: 42,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTypography.tajawal.copyWith(
            color: AppColors.secondary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
