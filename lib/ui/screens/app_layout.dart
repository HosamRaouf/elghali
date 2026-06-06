import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/breakpoints.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final device = getDeviceType(constraints.maxWidth);

        if (device == DeviceType.desktop) {
          return _buildDesktopLayout(context, ref);
        }
        return _buildMobileLayout(context);
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    if (currentRoute.startsWith('/menu') || currentRoute.startsWith('/home')) {
      return Scaffold(backgroundColor: AppColors.background, body: child);
    }

    int currentIndex = 0;
    if (currentRoute.startsWith('/menu')) currentIndex = 1;
    if (currentRoute.startsWith('/branches')) currentIndex = 2;
    if (currentRoute.startsWith('/cart')) currentIndex = 3;
    if (currentRoute.startsWith('/orders')) currentIndex = 4;
    if (currentRoute.startsWith('/loyalty')) currentIndex = 5;
    if (currentRoute.startsWith('/profile')) currentIndex = 6;
    if (currentRoute.startsWith('/settings')) currentIndex = 7;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Desktop Sidebar
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: AppColors.cardBorder,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, body: child);
  }
}
