import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/cart_viewmodel.dart';
import 'custom_icons.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartCount = cartState.items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );

    final String currentRoute = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (currentRoute.startsWith('/menu')) currentIndex = 1;
    if (currentRoute.startsWith('/branches')) currentIndex = 2;
    if (currentRoute.startsWith('/cart')) currentIndex = 3;
    if (currentRoute.startsWith('/profile')) currentIndex = 4;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondary,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/menu');
            break;
          case 2:
            context.go('/branches');
            break;
          case 3:
            context.go('/cart');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: CupIcon(size: 24, color: AppColors.secondary),
          activeIcon: CupIcon(size: 24, color: AppColors.primary),
          label: 'الرئيسية',
        ),
        const BottomNavigationBarItem(
          icon: CoffeeBeanMenu(size: 24, color: AppColors.secondary),
          activeIcon: CoffeeBeanMenu(size: 24, color: AppColors.primary),
          label: 'المنيو',
        ),
        const BottomNavigationBarItem(
          icon: DallahIcon(size: 24, color: AppColors.secondary),
          activeIcon: DallahIcon(size: 24, color: AppColors.primary),
          label: 'الفروع',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const CoffeeBagCart(size: 24, color: AppColors.secondary),
              if (cartCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: AppColors.background,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          activeIcon: Stack(
            children: [
              const CoffeeBagCart(size: 24, color: AppColors.primary),
              if (cartCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.textLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: AppColors.background,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'السلة',
        ),
        const BottomNavigationBarItem(
          icon: ProfileIcon(size: 24, color: AppColors.secondary),
          activeIcon: ProfileIcon(size: 24, color: AppColors.primary),
          label: 'حسابي',
        ),
      ],
    );
  }
}
