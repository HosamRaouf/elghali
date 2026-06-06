import 'dart:async';
import 'dart:math';

import 'package:bonn_flutter/ui/components/core/arabic_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../components/core/logo_circle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showLogo = true);
    });

    Future.delayed(const Duration(milliseconds: 5000), () async {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('bng_onboarded') ?? false;
      if (mounted) {
        final isWebLayout = MediaQuery.of(context).size.width > 800;
        if (seen || isWebLayout) {
          context.go('/home');
        } else {
          context.go('/onboarding');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0300),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: ArabicPattern()),
          // Ambient Glow
          Center(
            child:
                Container(
                      width: MediaQuery.of(context).size.width * 1.5,
                      height: MediaQuery.of(context).size.width * 1.5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0xFF3A1500), Colors.transparent],
                          stops: [0.0, 0.7],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fade(
                      duration: 2500.ms,
                      begin: 0.2,
                      end: 0.4,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Coffee Beans
          ...List.generate(18, (index) {
            final random = Random();
            final x = random.nextDouble() * MediaQuery.of(context).size.width;
            final delay = random.nextDouble() * 2000;
            final duration = 3000 + random.nextDouble() * 3000;

            return Positioned(
              left: x,
              top: 300,
              child: _CoffeeBeanParticle()
                  .animate(delay: delay.ms)
                  .moveY(
                    begin: 0,
                    end: MediaQuery.of(context).size.height + 100,
                    duration: duration.ms,
                    curve: Curves.linear,
                  )
                  .rotate(begin: 0, end: 1, duration: duration.ms)
                  .fadeIn(duration: 300.ms)
                  .fadeOut(delay: (duration - 300).ms, duration: 300.ms),
            );
          }),

          // Logo
          if (_showLogo)
            Center(
              child:
                  Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo Circle
                          const LogoCircle(size: 120),
                          const SizedBox(height: 32),

                          // Brand Name
                          Text(
                                "بن الغالي",
                                style: AppTypography.elMessiri.copyWith(
                                  fontSize: 42,
                                  color: AppColors.primary,
                                  letterSpacing: 1.0,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Color(0x80C9A84C),
                                      blurRadius: 30,
                                    ),
                                  ],
                                ),
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .custom(
                                duration: 2000.ms,
                                builder: (context, value, child) {
                                  final blur = 20.0 + (value * 20.0);
                                  return Text(
                                    "بن الغالي",
                                    style: AppTypography.arefRuqaa.copyWith(
                                      fontSize: 60,
                                      color: AppColors.primary,
                                      letterSpacing: 1.0,
                                      height: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: const Color(0xB2C9A84C),
                                          blurRadius: blur,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                          const SizedBox(height: 4),

                          Text(
                            "B O N N  A L - G H A L I",
                            style: AppTypography.tajawal.copyWith(
                              color: AppColors.secondary,
                              fontSize: 13,
                              letterSpacing: 3.0,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Loading Drip
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (index) {
                              return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                  .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                  )
                                  .fade(
                                    begin: 0.3,
                                    end: 1,
                                    duration: 800.ms,
                                    delay: (index * 200).ms,
                                  )
                                  .moveY(
                                    begin: 0,
                                    end: -4,
                                    duration: 800.ms,
                                    delay: (index * 200).ms,
                                  );
                            }),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale(
                        begin: const Offset(0.6, 0.6),
                        end: const Offset(1, 1),
                        curve: Curves.easeOutBack,
                        duration: 800.ms,
                      )
                      .blur(
                        begin: const Offset(10, 10),
                        end: const Offset(0, 0),
                        duration: 800.ms,
                      )
                      .then(delay: 2500.ms)
                      .fadeOut(duration: 400.ms)
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.2, 1.2),
                        duration: 400.ms,
                      )
                      .blur(
                        begin: const Offset(0, 0),
                        end: const Offset(5, 5),
                        duration: 400.ms,
                      ),
            ),
        ],
      ),
    );
  }
}

class _CoffeeBeanParticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(10, 15), painter: _BeanPainter());
  }
}

class _BeanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final linePaint = Paint()
      ..color = const Color(0xFF1A0A00)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 2, 1),
      Offset(size.width / 2, size.height - 1),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
