import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AdminBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final double maxValue;

  const AdminBarChart({
    super.key,
    required this.values,
    required this.labels,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (i) {
        final height = (values[i] / maxValue) * 120;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: height.clamp(4.0, 120.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, Color(0xFFB5682A)],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: 0.3, end: 0, duration: 400.ms, delay: (i * 60).ms)
                    .fadeIn(delay: (i * 60).ms),
                const SizedBox(height: 6),
                Text(labels[i],
                  style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 9),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
