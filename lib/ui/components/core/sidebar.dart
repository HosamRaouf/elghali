import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/cart_viewmodel.dart';
import 'custom_icons.dart';

class Bonnsidebar extends ConsumerWidget {
  final bool collapsed;

  const Bonnsidebar({super.key, this.collapsed = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartCount = cartState.items.fold(0, (sum, item) => sum + item.quantity);
    final String currentRoute = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (currentRoute.startsWith('/menu')) currentIndex = 1;
    if (currentRoute.startsWith('/branches')) currentIndex = 2;
    if (currentRoute.startsWith('/cart')) currentIndex = 3;
    if (currentRoute.startsWith('/profile')) currentIndex = 4;

    final items = [
      _SidebarItem(icon: const CupIcon(size: 22), label: 'الرئيسية', route: '/home'),
      _SidebarItem(icon: const CoffeeBeanMenu(size: 22), label: 'المنيو', route: '/menu'),
      _SidebarItem(icon: const DallahIcon(size: 22), label: 'الفروع', route: '/branches'),
      _SidebarItem(icon: const CoffeeBagCart(size: 22), label: 'السلة', route: '/cart', badge: cartCount),
      _SidebarItem(icon: const ProfileIcon(size: 22), label: 'حسابي', route: '/profile'),
    ];

    return Container(
      width: collapsed ? 72 : 200,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0400),
        border: Border(
          left: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          if (!collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'بن الغالي',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (collapsed)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final active = currentIndex == index;
            return _buildNavItem(context, item, active, collapsed, ref);
          }),
          const Spacer(),
          const Divider(color: Colors.white10, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 14,
                  color: AppColors.secondary,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 8),
                  Text(
                    'تصغير',
                    style: TextStyle(color: AppColors.secondary, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _SidebarItem item, bool active, bool collapsed, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.go(item.route),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: EdgeInsets.symmetric(
          horizontal: collapsed ? 0 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFB5682A)],
                )
              : null,
          color: active ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: collapsed ? Alignment.center : Alignment.centerRight,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.badge != null && item.badge! > 0)
                  _buildBadge(item.badge!, active),
                IconTheme(
                  data: IconThemeData(
                    color: active ? AppColors.background : AppColors.secondary,
                    size: 22,
                  ),
                  child: item.icon,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: active ? AppColors.background : AppColors.secondary,
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(int count, bool active) {
    return Positioned(
      left: 0,
      top: -4,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: active ? AppColors.background : AppColors.primary,
          shape: BoxShape.circle,
        ),
        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
        child: Text(
          count.toString(),
          style: TextStyle(
            color: active ? AppColors.primary : AppColors.background,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _SidebarItem {
  final Widget icon;
  final String label;
  final String route;
  final int? badge;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    this.badge,
  });
}
