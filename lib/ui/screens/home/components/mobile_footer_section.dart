import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../components/core/hoverable.dart';
import '../../../components/core/logo_circle.dart';

class _Link {
  final String label;
  final String path;
  const _Link(this.label, this.path);
}

const _menuLinks = [
  _Link("القائمة", '/menu'),
  _Link("منتجاتنا", '/menu'),
  _Link("عربة التسوق", '/cart'),
  _Link("طلباتي", '/orders'),
];

const _brandLinks = [
  _Link("الرئيسية", '/home'),
  _Link("عن بن الغالي", '/home'),
  _Link("الفروع", '/branches'),
  _Link("المكافآت", '/loyalty'),
];

const _accountLinks = [
  _Link("حسابي", '/profile'),
  _Link("الإعدادات", '/settings'),
  _Link("تسجيل الدخول", '/login'),
  _Link("إنشاء حساب", '/register'),
];

class MobileFooterSection extends ConsumerWidget {
  const MobileFooterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D0500), Color(0xFF0A0400), Color(0xFF050200)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 0),
            child: Column(
              children: [
                const LogoCircle(size: 60),
                const SizedBox(height: 12),
                Text(
                  "بن الغالي",
                  style: AppTypography.arefRuqaa.copyWith(
                    color: AppColors.primary,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "كل شروق .. ليه طعم تاني",
                  style: TextStyle(
                    color: AppColors.secondary.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "أجود أنواع القهوة العربية والتركية والإسبريسو، منتقاة من أفضل محاصيل البن حول العالم.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondary.withValues(alpha: 0.35),
                    fontSize: 11,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Divider(
            color: AppColors.primary.withValues(alpha: 0.08),
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _LinkColumn(title: "القائمة", links: _menuLinks),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LinkColumn(title: "بن الغالي", links: _brandLinks),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LinkColumn(title: "الحساب", links: _accountLinks),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Divider(
            color: AppColors.primary.withValues(alpha: 0.08),
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleIcon(icon: Icons.facebook, onTap: () {}),
                const SizedBox(width: 14),
                _CircleIcon(icon: Icons.camera_alt_outlined, onTap: () {}),
                const SizedBox(width: 14),
                _CircleIcon(icon: Icons.mail_outline, onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: Text(
              "جميع الحقوق محفوظة © بن الغالي ${DateTime.now().year}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondary.withValues(alpha: 0.3),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkColumn extends StatelessWidget {
  final String title;
  final List<_Link> links;
  const _LinkColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.tajawal.copyWith(
            color: AppColors.textLight,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Hoverable(
              onTap: () => context.push(link.path),
              glowColor: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
              child: Text(
                link.label,
                style: TextStyle(
                  color: AppColors.secondary.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.secondary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
