import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/admin_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../components/core/arabic_pattern.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // Subtle brand pattern in background
            const Positioned.fill(
              child: ArabicPattern(opacity: 0.04, animate: false),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0400).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 80,
                        spreadRadius: -10,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 40,
                        spreadRadius: -5,
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logo.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ).animate().scale(
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "بن الغالي",
                        style: AppTypography.arefRuqaa.copyWith(
                          color: AppColors.primary,
                          fontSize: 52,
                          height: 1.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: AppColors.primary.withValues(alpha: 0.8),
                              blurRadius: 15,
                            ),
                            Shadow(
                              color: const Color(
                                0xFFFFD700,
                              ).withValues(alpha: 0.4),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "لوحة التحكم الإدارية",
                        style: AppTypography.tajawal.copyWith(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 48),
                      MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                adminAuth.login();
                                context.go('/admin_home');
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "تسجيل الدخول للنظام",
                                    style: AppTypography.cairo.copyWith(
                                      color: AppColors.background,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .shimmer(
                            duration: 3.seconds,
                            color: Colors.white.withValues(alpha: 0.3),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 800.ms),
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
