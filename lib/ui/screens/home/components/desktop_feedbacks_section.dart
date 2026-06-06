import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../components/core/hoverable.dart';

class _Feedback {
  final String name;
  final String review;
  final int rating;
  final Color color;
  const _Feedback({required this.name, required this.review, required this.rating, required this.color});
}

const _feedbacks = [
  _Feedback(name: "سارة أحمد", review: "قهوة عربية رائعة! الطعم الأصلي والنكهة الغنية. صارت قهوتي المفضلة في البيت.", rating: 5, color: Color(0xFF8B4513)),
  _Feedback(name: "محمد علي", review: "بن الغالي أحسن بن جربته في المنصورة. التوصيل سريع والتغليف فخم.", rating: 5, color: Color(0xFFA0522D)),
  _Feedback(name: "نورة خالد", review: "حبيت القهوة التركية عندهم. طعمها ولا غلطة وهيلها مضبوط.", rating: 4, color: Color(0xFF6B3410)),
  _Feedback(name: "عمر حسن", review: "الإسبريسو عندهم شيء خيالي. كابتشينو ممتاز وسعره مناسب.", rating: 5, color: Color(0xFFD2691E)),
  _Feedback(name: "ليلى محمد", review: "أجمل هدية قهوة من بن الغالي. التغليف فخم والطعم أروع.", rating: 5, color: Color(0xFF8B5E3C)),
  _Feedback(name: "خالد يوسف", review: "البن الفرنساوي بالبندق تحفة بجد. نكهة راقية تستحق التجربة.", rating: 4, color: Color(0xFF7B3F00)),
];

class DesktopFeedbacksSection extends ConsumerWidget {
  final bool isActive;
  const DesktopFeedbacksSection({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyedSubtree(
      key: ValueKey('feedbacks_$isActive'),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            SectionChild(
              isActive: isActive, delayMs: 0,
              child: Text("آراء العملاء", style: AppTypography.arefRuqaa.copyWith(fontSize: 36, color: AppColors.textLight)),
            ),
            const SizedBox(height: 8),
            SectionChild(
              isActive: isActive, delayMs: 200,
              child: Text("ما يقوله ضيوفنا عن تجربتهم مع بن الغالي",
                style: AppTypography.tajawal.copyWith(color: AppColors.secondary.withValues(alpha: 0.5), fontSize: 15)),
            ),
            const SizedBox(height: 32),
            SectionChild(
              isActive: isActive, delayMs: 400,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 48) / 3;
                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < _feedbacks.length; i++)
                        SizedBox(
                          width: cardWidth.clamp(280, 400),
                          height: 180,
                          child: _DesktopFeedbackCard(index: i),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DesktopFeedbackCard extends StatelessWidget {
  final int index;
  const _DesktopFeedbackCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final feedback = _feedbacks[index];
    return Hoverable(
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: feedback.color,
                  child: Text(feedback.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(width: 10),
                Text(feedback.name, style: AppTypography.elMessiri.copyWith(fontSize: 14, color: AppColors.textLight)),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) => Icon(Icons.star,
                    color: i < feedback.rating ? AppColors.primary : AppColors.primary.withValues(alpha: 0.15),
                    size: 14,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(feedback.review,
                style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13, height: 1.5),
                maxLines: 4, overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
