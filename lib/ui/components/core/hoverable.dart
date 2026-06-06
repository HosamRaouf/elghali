import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Hoverable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Color? glowColor;
  final double glowBlur;
  final BorderRadius? borderRadius;

  const Hoverable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 1.08,
    this.glowColor,
    this.glowBlur = 20,
    this.borderRadius,
  });

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final glow = widget.glowColor;
    final useGlow = _isHovered && glow != null;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: useGlow
                ? BoxDecoration(
                    borderRadius: widget.borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: glow.withValues(alpha: 0.5),
                        blurRadius: widget.glowBlur,
                        spreadRadius: 2,
                      ),
                    ],
                  )
                : null,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class SectionChild extends StatelessWidget {
  final bool isActive;
  final int delayMs;
  final Widget child;

  const SectionChild({
    super.key,
    required this.isActive,
    required this.delayMs,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return child;
    return child
        .animate()
        .fadeIn(delay: delayMs.ms, duration: 500.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.04, end: 0, curve: Curves.easeOutCubic);
  }
}
