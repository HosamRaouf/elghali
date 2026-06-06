import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../components/core/arabic_pattern.dart';
import '../../../components/core/hoverable.dart';
import '../../../components/core/logo_circle.dart';

class DesktopFooterSection extends StatelessWidget {
  final bool isActive;
  const DesktopFooterSection({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey('footer_$isActive'),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0A00), Color(0xFF0D0500)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: ArabicPattern(opacity: 0.25)),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SectionChild(
                                isActive: isActive,
                                delayMs: 0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const LogoCircle(
                                      size: 120,
                                      animated: false,
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                          "بن الغالي",
                                          style: AppTypography.arefRuqaa
                                              .copyWith(
                                                fontSize: 96,
                                                color: AppColors.textLight,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    color: AppColors.primary
                                                        .withValues(alpha: 0.8),
                                                    blurRadius: 20,
                                                  ),
                                                  Shadow(
                                                    color: const Color(
                                                      0xFFFFD700,
                                                    ).withValues(alpha: 0.5),
                                                    blurRadius: 40,
                                                  ),
                                                ],
                                              ),
                                        )
                                        .animate()
                                        .fadeIn(
                                          delay: 0.ms,
                                          duration: 1200.ms,
                                          curve: Curves.easeInOutCubic,
                                        )
                                        .slideY(
                                          begin: 0.15,
                                          end: 0,
                                          curve: Curves.easeOutCubic,
                                        ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              SectionChild(
                                isActive: isActive,
                                delayMs: 200,
                                child: Text(
                                  "حيث تلتقي النكهات الأصيلة بالجودة العالية، نقدم لكم تجربة قهوة استثنائية.",
                                  style: AppTypography.tajawal.copyWith(
                                    color: AppColors.secondary,
                                    fontSize: 14,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SectionChild(
                                isActive: isActive,
                                delayMs: 400,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _SocialIcon(Icons.facebook_rounded, () {}),
                                    const SizedBox(width: 12),
                                    _SocialIcon(
                                      Icons.camera_alt_rounded,
                                      () {},
                                    ),
                                    const SizedBox(width: 12),
                                    _SocialIcon(
                                      Icons.music_note_rounded,
                                      () {},
                                    ),
                                    const SizedBox(width: 12),
                                    _SocialIcon(
                                      Icons.shopping_bag_rounded,
                                      () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SectionChild(
                                isActive: isActive,
                                delayMs: 200,
                                child: _LinkColumn(
                                  title: "روابط سريعة",
                                  links: [
                                    ("الرئيسية", "/home"),
                                    ("القائمة", "/menu"),
                                    ("الفروع", "/branches"),
                                  ],
                                ),
                              ),
                              SectionChild(
                                isActive: isActive,
                                delayMs: 400,
                                child: _LinkColumn(
                                  title: "خدماتنا",
                                  links: [
                                    ("المكافآت", "/loyalty"),
                                    ("الطلبات", "/cart"),
                                    ("المفضلة", "/favorites"),
                                  ],
                                ),
                              ),
                              SectionChild(
                                isActive: isActive,
                                delayMs: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "تواصل معنا",
                                      style: AppTypography.arefRuqaa.copyWith(
                                        fontSize: 18,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _ContactRow(
                                      Icons.phone_rounded,
                                      "0100-123-4567",
                                    ),
                                    const SizedBox(height: 12),
                                    _ContactRow(
                                      Icons.email_rounded,
                                      "info@bonelghali.com",
                                    ),
                                    const SizedBox(height: 12),
                                    _ContactRow(
                                      Icons.access_time_rounded,
                                      "السبت – الخميس ٨ص – ١١م",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Opacity(
                        opacity: 0.15,
                        child: Divider(color: AppColors.primary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "© 2026 بن الغالي – جميع الحقوق محفوظة",
                        style: AppTypography.tajawal.copyWith(
                          color: AppColors.secondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkColumn extends StatelessWidget {
  final String title;
  final List<(String, String)> links;
  const _LinkColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.arefRuqaa.copyWith(
              fontSize: 18,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          ...links.map(
            (l) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Hoverable(
                onTap: () => context.push(l.$2),
                glowColor: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  l.$1,
                  style: AppTypography.tajawal.copyWith(
                    color: AppColors.secondary,
                    fontSize: 14,
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

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow(this.icon, this.text);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: AppTypography.tajawal.copyWith(
            color: AppColors.secondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialIcon(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      glowColor: AppColors.primary,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }
}
