import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/breakpoints.dart';
import 'menu/desktop_menu.dart';
import 'menu/mobile_menu.dart';

class MenuScreen extends ConsumerWidget {
  final String? initialCategory;
  const MenuScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final device = getDeviceType(constraints.maxWidth);

        if (device == DeviceType.desktop) {
          return DesktopMenu(initialCategory: initialCategory);
        }

        return const MobileMenu();
      },
    );
  }
}
