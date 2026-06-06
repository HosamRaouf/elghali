import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

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
];

class MobileFeedbacksSection extends ConsumerWidget {
  const MobileFeedbacksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  width: 3, height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)]),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "آراء العملاء",
                  style: AppTypography.arefRuqaa.copyWith(fontSize: 22, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'ما يقوله عشاق بن الغالي عن تجربتهم',
              style: TextStyle(fontSize: 11, color: AppColors.primary.withValues(alpha: 0.5)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _feedbacks.length,
              itemBuilder: (context, index) {
                final fb = _feedbacks[index];
                return _FeedbackCard(feedback: fb, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final _Feedback feedback;
  final int index;
  const _FeedbackCard({required this.feedback, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: feedback.color.withValues(alpha: 0.2),
                child: Text(
                  feedback.name[0],
                  style: AppTypography.cairo.copyWith(
                    color: feedback.color, fontSize: 16, fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feedback.name,
                  style: AppTypography.tajawal.copyWith(
                    color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < feedback.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 14, color: AppColors.primary,
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              feedback.review,
              style: AppTypography.tajawal.copyWith(
                color: AppColors.secondary, fontSize: 12, height: 1.6,
              ),
              maxLines: 4, overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 80).ms, duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
