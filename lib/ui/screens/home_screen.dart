import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/breakpoints.dart';
import 'home/desktop_home.dart';
import 'home/mobile_home.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final device = getDeviceType(constraints.maxWidth);

        if (device == DeviceType.desktop) {
          return const DesktopHome();
        }

        return const MobileHome();
      },
    );
  }
}
