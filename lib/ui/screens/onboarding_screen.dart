import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../components/core/logo_circle.dart';

class SlideData {
  final String image;
  final String title;
  final String subtitle;
  final String accent;

  const SlideData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.accent,
  });
}

const slides = [
  SlideData(
    image:
        "https://images.unsplash.com/photo-1630620276854-c68ae3b47678?w=800&q=85",
    title: "كأنك تشم رائحة البن من الشاشة",
    subtitle: "قهوة عربية أصيلة محضّرة بعناية فائقة",
    accent: "تجربة حسية متكاملة",
  ),
  SlideData(
    image:
        "https://images.unsplash.com/photo-1773106287475-6a7c1b3e1e13?w=800&q=85",
    title: "فروعنا تنبض بالحياة ليلاً ونهاراً",
    subtitle: "أجواء حميمية تجمعك بمن تحب",
    accent: "في قلب المدينة",
  ),
  SlideData(
    image:
        "https://images.unsplash.com/photo-1762657440624-d0b5cfae5bac?w=800&q=85",
    title: "صانعو القهوة... فنانون في الحياة",
    subtitle: "كل فنجان قصة، كل رشفة لحظة",
    accent: "صنع بأيدي المحترفين",
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _current = 0;
  final PageController _pageController = PageController();

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bng_onboarded', true);
    if (mounted) {
      context.go('/login');
    }
  }

  void _next() {
    if (_current < slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0500),
      body: Stack(
        children: [
          // Background Images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) {
              setState(() {
                _current = idx;
              });
            },
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(slides[index].image, fit: BoxFit.cover)
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale(
                        begin: const Offset(1.08, 1.08),
                        end: const Offset(1, 1),
                        curve: Curves.easeOutQuad,
                        duration: 800.ms,
                      ),

                  // Multi-layer overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x4D0A0300), // 0.3
                          Color(0x1A0A0300), // 0.1
                          Color(0xB20A0300), // 0.7
                          Color(0xFA0A0300), // 0.98
                        ],
                        stops: [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // Side vignette
                  Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.0,
                        colors: [Colors.transparent, Color(0x990A0300)],
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      "تخطّي",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.secondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const LogoCircle(size: 40),
                ],
              ),
            ),
          ),

          // Slide Indicator
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 24, right: 24),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(slides.length, (index) {
                    final isActive = index == _current;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      margin: const EdgeInsets.only(left: 8),
                      width: isActive ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(
                          alpha: isActive ? 1.0 : 0.4,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text Content
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child:
                      Column(
                            key: ValueKey<int>(_current),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Accent badge
                              Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.15,
                                      ),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          slides[_current].accent,
                                          style: AppTypography.cairo.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate()
                                  .slideX(begin: 0.2, end: 0, duration: 400.ms)
                                  .fadeIn(duration: 400.ms),

                              Text(
                                slides[_current].title,
                                style: AppTypography.elMessiri.copyWith(
                                  fontSize: 32,
                                  color: AppColors.textLight,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                slides[_current].subtitle,
                                style: AppTypography.tajawal.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 16,
                                  height: 1.7,
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          )
                          .animate()
                          .slideY(begin: 0.2, end: 0, duration: 500.ms)
                          .fadeIn(duration: 500.ms),
                ),

                // CTA Button
                InkWell(
                  onTap: _next,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC9A84C), Color(0xFFB5682A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _current < slides.length - 1 ? "التالي" : "ابدأ رحلتك",
                      style: AppTypography.cairo.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D0500),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    "${_current + 1} / ${slides.length}",
                    style: AppTypography.tajawal.copyWith(
                      color: AppColors.secondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
