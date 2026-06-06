import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'components/desktop_about_section.dart';
import 'components/desktop_branches_section.dart';
import 'components/desktop_featured_section.dart';
import 'components/desktop_feedbacks_section.dart';
import 'components/desktop_footer_section.dart';
import 'components/desktop_hero_section.dart';
import 'components/desktop_loyalty_section.dart';
import 'components/desktop_menu_preview_section.dart';

const _sectionLabels = [
  "الرئيسية",
  "حكايتنا",
  "الأكثر مبيعاً",
  "المكافآت",
  "الفروع",
  "القائمة",
  "الآراء",
  "تواصل معنا",
];

class DesktopHome extends ConsumerStatefulWidget {
  const DesktopHome({super.key});

  @override
  ConsumerState<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends ConsumerState<DesktopHome>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  bool _hasAutoScrolled = false;
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _bounceCtrl = AnimationController(vsync: this, duration: 4000.ms);
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 0), weight: 60),
    ]).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.bounceOut));
    _bounceCtrl.addListener(_onBounce);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(3.seconds, () {
        if (mounted && _currentPage == 0 && !_hasAutoScrolled) {
          _hasAutoScrolled = true;
          _bounceCtrl.forward(from: 0);
        }
      });
    });
  }

  void _onBounce() {
    final viewportHeight = MediaQuery.of(context).size.height;
    _pageController.jumpTo(_bounceAnim.value * viewportHeight);
  }

  @override
  void dispose() {
    _bounceCtrl.removeListener(_onBounce);
    _bounceCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            children: [
              _Page(
                viewportHeight: viewportHeight,
                child: DesktopHeroSection(
                  isActive: _currentPage == 0,
                  onNavigateToPage: (page) => _pageController.animateToPage(
                    page,
                    duration: 600.ms,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
              ),
              _Page(
                viewportHeight: viewportHeight,
                child: DesktopAboutSection(isActive: _currentPage == 1),
              ),
              _Page(
                viewportHeight: viewportHeight,
                child: DesktopFeaturedSection(isActive: _currentPage == 2),
              ),
              _Page(
                viewportHeight: viewportHeight,
                child: DesktopLoyaltySection(isActive: _currentPage == 3),
              ),
              _Page(
                viewportHeight: viewportHeight,
                child: DesktopBranchesSection(isActive: _currentPage == 4),
              ),
              _Page(
                viewportHeight: viewportHeight,
                child: DesktopMenuPreviewSection(isActive: _currentPage == 5),
              ),
              _Page(
                viewportHeight: viewportHeight,
                child: DesktopFeedbacksSection(isActive: _currentPage == 6),
              ),
              _Page(
                viewportHeight: viewportHeight,
                child: DesktopFooterSection(isActive: _currentPage == 7),
              ),
            ],
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 24,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  8,
                  (i) => _SideIndicator(
                    label: _sectionLabels[i],
                    isActive: _currentPage == i,
                    onTap: () => _pageController.animateToPage(
                      i,
                      duration: 600.ms,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final double viewportHeight;
  final Widget child;
  const _Page({required this.viewportHeight, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: viewportHeight,
      width: double.infinity,
      child: Center(child: child),
    );
  }
}

class _SideIndicator extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SideIndicator({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SideIndicator> createState() => _SideIndicatorState();
}

class _SideIndicatorState extends State<_SideIndicator> {
  bool _isHovered = false;

  bool get _showLabel => widget.isActive || _isHovered;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: AnimatedContainer(
            duration: 200.ms,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: -2,
                      ),
                    ]
                  : [],
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: 1,
                  duration: 200.ms,
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: 200.ms,
                    child: Text(
                      widget.label,
                      style: AppTypography.tajawal.copyWith(
                        color: widget.isActive
                            ? AppColors.primary
                            : AppColors.textLight.withValues(alpha: 0.7),
                        fontSize: 13,
                        fontWeight: widget.isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedContainer(
                  duration: 200.ms,
                  width: widget.isActive ? 28 : 8,
                  height: _isHovered && !widget.isActive ? 10 : 8,
                  decoration: BoxDecoration(
                    color: widget.isActive
                        ? AppColors.primary
                        : (_isHovered
                              ? AppColors.primary.withValues(alpha: 0.6)
                              : AppColors.primary.withValues(alpha: 0.25)),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                ),
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }
}
