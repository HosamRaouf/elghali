import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/breakpoints.dart';
import '../../data/coffee_data.dart';
import '../components/core/arabic_pattern.dart';
import '../components/core/custom_icons.dart';
import '../components/core/logo_circle.dart';
import '../components/core/hoverable.dart';

class Reward {
  final String id;
  final String name;
  final int points;
  final String image;
  final bool available;

  const Reward({
    required this.id,
    required this.name,
    required this.points,
    required this.image,
    required this.available,
  });
}

class PointsHistory {
  final String date;
  final String action;
  final String points;

  const PointsHistory({
    required this.date,
    required this.action,
    required this.points,
  });
}

final List<Reward> rewards = [
  const Reward(
    id: "r1",
    name: "قهوة عربية مجانية",
    points: 500,
    image:
        "https://images.unsplash.com/photo-1769781383545-6b60e30eb88c?w=300&q=70",
    available: true,
  ),
  const Reward(
    id: "r2",
    name: "كابتشينو مجاني",
    points: 800,
    image:
        "https://images.unsplash.com/photo-1649780567041-344d8f485e74?w=300&q=70",
    available: true,
  ),
  const Reward(
    id: "r3",
    name: "حلوى بن الغالي",
    points: 1000,
    image:
        "https://images.unsplash.com/photo-1736813133035-6baf4762fd3d?w=300&q=70",
    available: true,
  ),
  const Reward(
    id: "r4",
    name: "جلسة VIP",
    points: 2000,
    image:
        "https://images.unsplash.com/photo-1773106287475-6a7c1b3e1e13?w=300&q=70",
    available: false,
  ),
];

final List<PointsHistory> history = [
  const PointsHistory(
    date: "٣ مايو",
    action: "شراء بن الغالي مخصوص",
    points: "+٢٥",
  ),
  const PointsHistory(date: "١ مايو", action: "استرداد مكافأة", points: "-٥٠٠"),
  const PointsHistory(date: "٢٨ أبريل", action: "شراء بن تركي", points: "+٣٠"),
  const PointsHistory(
    date: "٢٥ أبريل",
    action: "بونص عيد ميلاد بن الغالي",
    points: "+٢٠٠",
  ),
];

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  static const _navItems = [
    _LoyaltyNavItem("الرئيسية", '/home'),
    _LoyaltyNavItem("المتجر", '/menu'),
    _LoyaltyNavItem("الفروع", '/branches'),
    _LoyaltyNavItem("المفضلة", '/profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userPoints = 1250;
    const currentLevel = "ذهبي";
    const nextLevel = "بلاتيني";
    const progress = 0.83;
    const nextPointsNeeded = 1500 - userPoints;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            getDeviceType(constraints.maxWidth) == DeviceType.desktop;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                            20,
                            isDesktop ? 48 : 32,
                            20,
                            16,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isDesktop)
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => context.pop(),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.arrow_back,
                                            size: 18,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "العودة",
                                            style: AppTypography.cairo.copyWith(
                                              color: AppColors.primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const LogoCircle(size: 44),
                                  ],
                                ),
                              if (isDesktop) ...[
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Hoverable(
                                      onTap: () => context.go('/home'),
                                      glowColor: AppColors.primary,
                                      borderRadius: BorderRadius.circular(999),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.background.withValues(alpha: 0.4),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                                        ),
                                        child: const Icon(Icons.home_outlined, color: AppColors.primary, size: 24),
                                      ),
                                    ),
                                    const SizedBox(width: 48),
                                    ..._navItems.map(
                                      (item) => Padding(
                                        padding: EdgeInsets.only(left: item != _navItems.last ? 36 : 0),
                                        child: _LoyaltyNavTextButton(
                                          label: item.label,
                                          onTap: () => context.go(item.route),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                              ],
                              Text(
                                "اشرب واكسب",
                                style: AppTypography.arefRuqaa.copyWith(
                                  fontSize: isDesktop ? 48 : 36,
                                  color: AppColors.textLight,
                                ),
                              ),
                              Text(
                                "كل معلقة بن بتستخدمها من بن  الغالي بتقربك من مكافئة!",
                                style: AppTypography.tajawal.copyWith(
                                  color: AppColors.primary,
                                  fontSize: isDesktop ? 16 : 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (isDesktop)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 28,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildPointsCard(
                                userPoints,
                                currentLevel,
                                nextPointsNeeded,
                                nextLevel,
                                progress,
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "سجل النقاط",
                                    style: AppTypography.elMessiri.copyWith(
                                      color: AppColors.textLight,
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildHistoryList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      // Points Card (Mobile)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildPointsCard(
                          userPoints,
                          currentLevel,
                          nextPointsNeeded,
                          nextLevel,
                          progress,
                        ),
                      ),
                    ],

                    // Rewards
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        isDesktop ? 48 : 24,
                        20,
                        12,
                      ),
                      child: Text(
                        "المكافآت المتاحة",
                        style: AppTypography.elMessiri.copyWith(
                          color: AppColors.textLight,
                          fontSize: isDesktop ? 28 : 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: isDesktop ? 0.85 : 1,
                        ),
                        itemCount: rewards.length,
                        itemBuilder: (context, index) {
                          final reward = rewards[index];
                          final canRedeem = userPoints >= reward.points;
                          return _buildRewardCard(reward, canRedeem, index);
                        },
                      ),
                    ),

                    if (!isDesktop) ...[
                      // History (Mobile)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                        child: Text(
                          "سجل النقاط",
                          style: AppTypography.elMessiri.copyWith(
                            color: AppColors.textLight,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        child: _buildHistoryList(),
                      ),
                    ],
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPointsCard(
    int userPoints,
    String currentLevel,
    int nextPointsNeeded,
    String nextLevel,
    double progress,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B1800), Color(0xFF1A0A00), Color(0xFF2B1008)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ArabicPattern(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child:
                          OctagonalStar(
                                size: 20,
                                color: AppColors.primary,
                                filled: i < 4,
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .scale(
                                begin: const Offset(0.9, 0.9),
                                end: const Offset(1.1, 1.1),
                                duration: (2000 + i * 300).ms,
                                curve: Curves.easeInOut,
                              )
                              .custom(
                                builder: (context, value, child) => Opacity(
                                  opacity: 0.4 + (value * 0.6),
                                  child: child,
                                ),
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "رصيدك الحالي",
                  style: AppTypography.tajawal.copyWith(
                    color: AppColors.secondary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  toArabicNum(userPoints),
                  style: AppTypography.cairo.copyWith(
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    height: 1,
                  ),
                ).animate().scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                  duration: 800.ms,
                ),
                Text(
                  "نقطة",
                  style: AppTypography.tajawal.copyWith(
                    color: AppColors.secondary,
                    fontSize: 16,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CoffeeBeanDivider(),
                ),

                // Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "عضو $currentLevel",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${toArabicNum(nextPointsNeeded)} نقطة لـ${nextLevel}",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Container(
                        height: 8,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child:
                            Container(
                              height: 8,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    Color(0xFFB5682A),
                                  ],
                                ),
                              ),
                            ).animate().shimmer(
                              duration: 2.seconds,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                      ).animate().slideX(
                        begin: -1,
                        end: 0,
                        duration: 1.seconds,
                        curve: Curves.easeOut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: history.asMap().entries.map((entry) {
            final idx = entry.key;
            final h = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.025),
                border: Border(
                  bottom: idx < history.length - 1
                      ? BorderSide(color: Colors.white.withValues(alpha: 0.04))
                      : BorderSide.none,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.action,
                        style: AppTypography.cairo.copyWith(
                          color: AppColors.textLight,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        h.date,
                        style: AppTypography.cairo.copyWith(
                          color: AppColors.secondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    h.points,
                    style: AppTypography.cairo.copyWith(
                      color: h.points.startsWith("+")
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFE57373),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRewardCard(Reward reward, bool canRedeem, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: canRedeem
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/product-1.jpg', fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xE60D0500)],
                        stops: [0.3, 1],
                      ),
                    ),
                  ),
                  if (!canRedeem)
                    Container(
                      color: const Color(0x800D0500),
                      child: const Center(
                        child: Text("🔒", style: TextStyle(fontSize: 24)),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white.withValues(alpha: 0.03),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      reward.name,
                      style: AppTypography.elMessiri.copyWith(
                        color: AppColors.textLight,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${toArabicNum(reward.points)} نقطة",
                          style: AppTypography.cairo.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (canRedeem)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2B7A2B,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "متاح",
                              style: AppTypography.cairo.copyWith(
                                color: Color(0xFF4CAF50),
                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1, end: 0);
  }
}

class _LoyaltyNavItem {
  final String label;
  final String route;
  const _LoyaltyNavItem(this.label, this.route);
}

class _LoyaltyNavTextButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _LoyaltyNavTextButton({required this.label, required this.onTap});

  @override
  State<_LoyaltyNavTextButton> createState() => _LoyaltyNavTextButtonState();
}

class _LoyaltyNavTextButtonState extends State<_LoyaltyNavTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: 200.ms,
          scale: _isHovered ? 1.1 : 1.0,
          child: AnimatedDefaultTextStyle(
            duration: 200.ms,
            style: AppTypography.tajawal.copyWith(
              color: _isHovered ? AppColors.primary : AppColors.textLight.withValues(alpha: 0.85),
              fontSize: 14,
              fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w500,
              shadows: _isHovered ? [Shadow(color: AppColors.primary.withValues(alpha: 0.6), blurRadius: 20)] : [],
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
