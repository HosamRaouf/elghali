import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';

class ArabicPattern extends StatelessWidget {
  final double opacity;
  final Color? color;
  final bool animate;

  const ArabicPattern({
    super.key,
    this.opacity = 0.2,
    this.color,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final patternColor = color ?? AppColors.primary;

    Widget pattern = RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _ArabicPatternPainter(color: patternColor, opacity: opacity),
      ),
    );

    if (animate) {
      pattern = pattern
          .animate(onPlay: (controller) => controller.repeat())
          .custom(
            duration: 20.seconds,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value * 120.0),
                child: child,
              );
            },
          );
    }

    return ClipRect(
      child: Opacity(
        opacity: 0.5, // Further dampen for performance/visibility
        child: pattern,
      ),
    );
  }
}

class _ArabicPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;

  _ArabicPatternPainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.2)
      ..style = PaintingStyle.fill;

    const double tileSize = 120.0; // Larger tiles = fewer draw calls
    const Offset center = Offset(tileSize / 2, tileSize / 2);

    for (double y = -tileSize; y < size.height + tileSize; y += tileSize) {
      for (double x = -tileSize; x < size.width + tileSize; x += tileSize) {
        canvas.save();
        canvas.translate(x, y);

        // 1. Core rings
        canvas.drawCircle(center, tileSize * 0.45, strokePaint);
        canvas.drawCircle(center, tileSize * 0.3, strokePaint);

        // 2. Simplified 12-Fold Symmetry (Reduced from 24)
        const int folds = 12;
        for (int i = 0; i < folds; i++) {
          double angle = i * 2 * math.pi / folds;
          canvas.save();
          canvas.translate(center.dx, center.dy);
          canvas.rotate(angle);

          // Simple Petal
          final petal = Path()
            ..moveTo(0, -tileSize * 0.1)
            ..lineTo(tileSize * 0.05, -tileSize * 0.35)
            ..lineTo(0, -tileSize * 0.4)
            ..lineTo(-tileSize * 0.05, -tileSize * 0.35)
            ..close();
          canvas.drawPath(petal, strokePaint);

          // Dot accent
          canvas.drawCircle(const Offset(0, -tileSize * 0.2), 1, fillPaint);

          canvas.restore();
        }

        // 3. Central Geometry
        _drawStar(
          canvas,
          center,
          8,
          tileSize * 0.1,
          tileSize * 0.05,
          fillPaint,
        );

        canvas.restore();
      }
    }
  }

  void _drawStar(
    Canvas canvas,
    Offset center,
    int points,
    double outerRadius,
    double innerRadius,
    Paint paint,
  ) {
    final path = Path();
    for (int i = 0; i < 2 * points; i++) {
      double radius = i.isEven ? outerRadius : innerRadius;
      double angle = i * math.pi / points;
      Offset point = center + Offset.fromDirection(angle - math.pi / 2, radius);
      if (i == 0)
        path.moveTo(point.dx, point.dy);
      else
        path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArabicPatternPainter oldDelegate) => false;
}

class CoffeeBeanDivider extends StatelessWidget {
  const CoffeeBeanDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Color(0x66C9A84C)],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final opacity = 0.6 - (i * 0.1);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: SvgPicture.string(
                '''
                <svg width="8" height="12" viewBox="0 0 8 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <ellipse cx="4" cy="6" rx="3.5" ry="5.5" fill="#C9A84C" opacity="$opacity" />
                  <line x1="4" y1="1" x2="4" y2="11" stroke="#1A0A00" stroke-width="0.8" />
                </svg>
                ''',
                width: 8,
                height: 12,
              ),
            );
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x66C9A84C), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
