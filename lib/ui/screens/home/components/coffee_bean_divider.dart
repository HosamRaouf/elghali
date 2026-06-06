import 'package:bonn_flutter/core/theme/app_colors.dart';
import 'package:bonn_flutter/ui/components/core/custom_icons.dart';
import 'package:flutter/material.dart';

class CoffeeBeanDivider extends StatelessWidget {
  const CoffeeBeanDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.primary.withValues(alpha: 0.15),
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Transform.rotate(
                  angle: i == 0 ? -0.15 : (i == 2 ? 0.15 : 0),
                  child: Padding(
                    padding: EdgeInsets.only(left: i < 2 ? 4 : 0),
                    child: CoffeeBeanMenu(
                      size: 14,
                      color: AppColors.primary.withValues(
                        alpha: 0.6 - i * 0.15,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.primary.withValues(alpha: 0.15),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
