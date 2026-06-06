import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'components/animated_section.dart';
import 'components/coffee_bean_divider.dart';
import 'components/mobile_about_section.dart';
import 'components/mobile_branches_section.dart';
import 'components/mobile_featured_section.dart';
import 'components/mobile_feedbacks_section.dart';
import 'components/mobile_footer_section.dart';
import 'components/mobile_hero_section.dart';
import 'components/mobile_loyalty_section.dart';
import 'components/mobile_menu_section.dart';

class MobileHome extends ConsumerWidget {
  const MobileHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const AnimatedSection(child: MobileHeroSection()),
                const AnimatedSection(
                  triggerDelayMs: 3000,
                  child: MobileAboutSection(),
                ),
                const CoffeeBeanDivider(),
                const AnimatedSection(child: MobileFeaturedSection()),
                const CoffeeBeanDivider(),
                const AnimatedSection(child: MobileLoyaltySection()),
                const CoffeeBeanDivider(),
                const AnimatedSection(child: MobileBranchesSection()),
                const CoffeeBeanDivider(),
                const AnimatedSection(child: MobileMenuSection()),
                const CoffeeBeanDivider(),
                const AnimatedSection(child: MobileFeedbacksSection()),
                const CoffeeBeanDivider(),
                const MobileFooterSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
