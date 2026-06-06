import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';

/// A reusable animated logo circle widget with fade-to-black glow effect.
/// The logo is displayed in a circular frame with a radial gradient that
/// fades from transparent at the center to black at the edges, with a
/// pulsing golden glow.
class LogoCircle extends StatelessWidget {
  final double size;
  final bool animated;

  const LogoCircle({super.key, this.size = 60, this.animated = true});

  @override
  Widget build(BuildContext context) {
    Widget logo = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.45),
            blurRadius: size * 0.55,
            spreadRadius: size * 0.08,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: size * 0.25,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Logo image
            Image.asset('assets/images/logo.jpg', fit: BoxFit.cover),

            // Fade to black radial overlay
          ],
        ),
      ),
    );

    if (!animated) return logo;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer pulsing glow ring
        Container(
              width: size * 1.5,
              height: size * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat())
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.25, 1.25),
              duration: 2200.ms,
              curve: Curves.easeOut,
            )
            .fade(begin: 0.6, end: 0, duration: 2200.ms, curve: Curves.easeOut),

        // Inner glow ring
        Container(
              width: size * 1.12,
              height: size * 1.12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fade(
              begin: 0.4,
              end: 0.9,
              duration: 1800.ms,
              curve: Curves.easeInOut,
            ),

        // The logo itself with subtle pulse
        logo
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .boxShadow(
              begin: BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: size * 0.4,
                spreadRadius: 0,
              ),
              end: BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.7),
                blurRadius: size * 0.8,
                spreadRadius: size * 0.05,
              ),
              duration: 2000.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}
