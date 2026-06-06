import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class Bonnnavigationmenu extends StatelessWidget {
  const Bonnnavigationmenu({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    final links = [
      ('الرئيسية', '/home'),
      ('المنيو', '/menu'),
      ('الفروع', '/branches'),
      ('السلة', '/cart'),
      ('حسابي', '/profile'),
    ];

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0400),
        border: Border(
          bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          Text(
            'بن الغالي',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 32),
          ...links.map((link) {
            final active = currentRoute.startsWith(link.$2);
            return GestureDetector(
              onTap: () => context.go(link.$2),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: active ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  link.$1,
                  style: TextStyle(
                    color: active ? AppColors.primary : AppColors.secondary,
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
        ],
      ),
    );
  }
}
