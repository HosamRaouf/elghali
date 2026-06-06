import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../viewmodels/cart_viewmodel.dart';
import '../../../components/core/arabic_pattern.dart';
import '../../../components/core/hoverable.dart';
import '../../../components/core/logo_circle.dart';

const _navItems = [
  (1, "حكايتنا"),
  (2, "الأكثر مبيعاً"),
  (3, "المكافآت"),
  (4, "الفروع"),
  (5, "القائمة"),
  (6, "الآراء"),
  (7, "تواصل معنا"),
];

class DesktopHeroSection extends ConsumerWidget {
  final void Function(int page)? onNavigateToPage;
  final bool isActive;
  const DesktopHeroSection({super.key, this.onNavigateToPage, this.isActive = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyedSubtree(
      key: ValueKey('hero_$isActive'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/hero.jpg", fit: BoxFit.cover, alignment: const Alignment(0, -0.4)),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0x801A0A00), Color(0xE61A0A00)],
              ),
            ),
          ),
          const Positioned.fill(child: ArabicPattern(opacity: 0.25))
              .animate().fadeIn(delay: 5000.ms, duration: 1500.ms),
          Positioned(top: 48, left: 48, child: _HeaderIcon(
            icon: Icons.person_outline_rounded, onTap: () => context.push('/profile'),
          )),
          Positioned(top: 48, right: 48, child: _CartIcon()),
          Positioned(
            top: 56, left: 0, right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_navItems.length, (i) {
                  final (page, label) = _navItems[i];
                  return Padding(
                    padding: EdgeInsets.only(left: i < _navItems.length - 1 ? 50 : 0),
                    child: _NavTextButton(label: label, onTap: () => onNavigateToPage?.call(page)),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 800.ms, duration: 800.ms).slideY(begin: -0.5, end: 0, curve: Curves.easeOutCubic),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LogoCircle(size: 200)
                    .animate().fadeIn(delay: 500.ms, duration: 1000.ms, curve: Curves.easeInOutCubic)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), curve: Curves.easeInOutCubic),
                const SizedBox(height: 40),
                Text("بن الغالي", style: AppTypography.arefRuqaa.copyWith(
                  fontSize: 128, color: AppColors.textLight, fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: AppColors.primary.withValues(alpha: 0.8), blurRadius: 20), Shadow(color: const Color(0xFFFFD700).withValues(alpha: 0.5), blurRadius: 40)],
                )).animate().fadeIn(delay: 1500.ms, duration: 1200.ms, curve: Curves.easeInOutCubic).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
                Text("كل شروق طعم جديد", style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 22))
                    .animate().fadeIn(delay: 1500.ms, duration: 1200.ms, curve: Curves.easeInOutCubic).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 48),
                _MenuButton(),
              ],
            ),
          ),
          Positioned(
            bottom: 36, left: 0, right: 0,
            child: IgnorePointer(
              child: Icon(Icons.keyboard_double_arrow_down_rounded,
                color: AppColors.textLight.withValues(alpha: 0.35), size: 30)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideY(begin: -0.35, end: 0.35, duration: 1400.ms, curve: Curves.easeInOut)
                .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1), duration: 1400.ms, curve: Curves.easeInOut),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTextButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavTextButton({required this.label, required this.onTap});

  @override
  State<_NavTextButton> createState() => _NavTextButtonState();
}

class _NavTextButtonState extends State<_NavTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: 200.ms,
          scale: _isHovered ? 1.12 : 1.0,
          child: AnimatedDefaultTextStyle(
            duration: 200.ms,
            style: AppTypography.tajawal.copyWith(
              color: _isHovered ? AppColors.primary : AppColors.textLight.withValues(alpha: 0.85),
              fontSize: 15,
              fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w500,
              shadows: _isHovered ? [Shadow(color: AppColors.primary.withValues(alpha: 0.6), blurRadius: 20)] : [],
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: () => context.push('/menu'),
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)]),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 24, spreadRadius: -2)],
        ),
        child: Text("عرض القائمة", style: AppTypography.tajawal.copyWith(color: AppColors.background, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    ).animate().fadeIn(delay: 2200.ms, duration: 800.ms, curve: Curves.easeInOutCubic).slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _HeaderIcon({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap, glowColor: AppColors.primary, borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: AppColors.primary, size: 28),
      ),
    );
  }
}

class _CartIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartProvider).items.fold(0, (sum, item) => sum + item.quantity);
    return Hoverable(
      onTap: () => context.push('/cart'),
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart_outlined, color: AppColors.primary, size: 28),
            if (count > 0)
              Positioned(
                right: -8, top: -8,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)]),
                    shape: BoxShape.circle,
                  ),
                  child: Text('$count', style: const TextStyle(color: AppColors.background, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
