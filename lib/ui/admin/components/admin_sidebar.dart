import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/admin_auth.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class AdminSidebar extends StatelessWidget {
  final String activeRoute;

  const AdminSidebar({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0400),
        border: Border(left: BorderSide(color: AppColors.primary.withValues(alpha: 0.1))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildBrand(context),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 16),
          ..._items.map((item) => _buildNavItem(context, item)),
          const Spacer(),
          const Divider(color: Colors.white10, height: 1),
          _buildLogout(context),
          _buildBackToStore(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBrand(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              image: const DecorationImage(
                image: AssetImage('assets/images/logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text("Bonn Elghaly",
            style: AppTypography.elMessiri.copyWith(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text("لوحة التحكم",
            style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _AdminNavItem item) {
    final isActive = item.route == '/admin/categories'
        ? activeRoute.startsWith('/admin/categories')
        : activeRoute == item.route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: GestureDetector(
        onTap: () => context.go(item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.primaryGradient : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 20, color: isActive ? AppColors.background : AppColors.secondary),
              const SizedBox(width: 12),
              Text(item.label,
                style: AppTypography.tajawal.copyWith(
                  color: isActive ? AppColors.background : AppColors.secondary,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackToStore(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: GestureDetector(
        onTap: () => context.go('/home'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondary),
              const SizedBox(width: 12),
              Text("العودة للمتجر",
                style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: GestureDetector(
        onTap: () {
          adminAuth.logout();
          context.go('/admin');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 16, color: AppColors.error),
              const SizedBox(width: 12),
              Text("تسجيل الخروج",
                style: AppTypography.tajawal.copyWith(color: AppColors.error, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminNavItem {
  final IconData icon;
  final String label;
  final String route;
  const _AdminNavItem({required this.icon, required this.label, required this.route});
}

const _items = [
  _AdminNavItem(icon: Icons.dashboard_rounded, label: "الإحصائيات", route: "/admin_home"),
  _AdminNavItem(icon: Icons.receipt_long_rounded, label: "الطلبات", route: "/admin/orders"),
  _AdminNavItem(icon: Icons.folder_rounded, label: "التصنيفات", route: "/admin/categories"),
  _AdminNavItem(icon: Icons.people_rounded, label: "المستخدمون", route: "/admin/users"),
];
