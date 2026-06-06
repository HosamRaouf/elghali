import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedSection extends StatefulWidget {
  final Widget child;
  final int triggerDelayMs;
  const AnimatedSection({super.key, required this.child, this.triggerDelayMs = 0});

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  late Animation<Offset> _slide;
  late Animation<double> _blur;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 900.ms);

    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const CurveEaseOutQuart()),
    );
    _slide = Tween(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _scale = Tween(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const CurveEaseOutBack()),
    );
    _blur = Tween(
      begin: 8.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.triggerDelayMs > 0) {
      Future.delayed(Duration(milliseconds: widget.triggerDelayMs), _trigger);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndListen());
    }
  }

  void _trigger() {
    if (!mounted || _triggered) return;
    _triggered = true;
    _controller.forward();
    _removeScrollListener();
  }

  void _checkAndListen() {
    if (!mounted) return;
    try {
      Scrollable.of(context).position.addListener(_onScroll);
      _onScroll();
    } catch (_) {}
  }

  void _onScroll() {
    if (_triggered || !mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    if (position.dy < screenHeight * 0.8) {
      _trigger();
    }
  }

  void _removeScrollListener() {
    try {
      Scrollable.of(context).position.removeListener(_onScroll);
    } catch (_) {}
  }

  @override
  void dispose() {
    _removeScrollListener();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _slide.value.dy * 50),
            child: Transform.scale(
              scale: _scale.value,
              child: _blur.value > 0.5
                  ? ImageFiltered(
                      imageFilter: ui.ImageFilter.blur(
                        sigmaX: _blur.value * 0.4,
                        sigmaY: _blur.value * 0.4,
                      ),
                      child: child,
                    )
                  : child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

class CurveEaseOutQuart extends Curve {
  const CurveEaseOutQuart();
  @override
  double transformInternal(double t) =>
      1 - (1 - t) * (1 - t) * (1 - t) * (1 - t);
}

class CurveEaseOutBack extends Curve {
  const CurveEaseOutBack();
  @override
  double transformInternal(double t) {
    const c1 = 1.70158;
    const c3 = c1 + 1;
    return 1 + c3 * (t - 1) * (t - 1) * (t - 1) + c1 * (t - 1) * (t - 1);
  }
}
