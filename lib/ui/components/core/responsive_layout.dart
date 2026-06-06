import 'package:flutter/material.dart';
import '../../../core/theme/breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final device = getDeviceType(constraints.maxWidth);
        if (device == DeviceType.desktop) {
          return desktop;
        } else if (device == DeviceType.tablet) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
