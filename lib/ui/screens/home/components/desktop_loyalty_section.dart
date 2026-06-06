import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/coffee_data.dart';
import '../../../components/core/arabic_pattern.dart' hide CoffeeBeanDivider;
import '../../../components/core/custom_icons.dart';
import '../../../components/core/hoverable.dart';
import 'coffee_bean_divider.dart';

class DesktopLoyaltySection extends ConsumerWidget {
  final bool isActive;
  const DesktopLoyaltySection({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userPoints = 1250;
    const currentLevel = "ذهبي";
    const nextLevel = "بلاتيني";
    const progress = 0.83;
    const nextPointsNeeded = 1500 - userPoints;

    return KeyedSubtree(
      key: ValueKey('loyalty_$isActive'),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SectionChild(isActive: isActive, delayMs: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OctagonalStar(size: 20, color: AppColors.primary, filled: i < 4)
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: (2000 + i * 300).ms, curve: Curves.easeInOut)
                        .custom(builder: (_, v, child) => Opacity(opacity: 0.4 + v * 0.6, child: child)),
                  )),
                ),
              ),
              const SizedBox(height: 10),
              SectionChild(isActive: isActive, delayMs: 100,
                child: Text("برنامج الولاء",
                  style: AppTypography.arefRuqaa.copyWith(fontSize: 32, color: AppColors.textLight)),
              ),
              const SizedBox(height: 4),
              SectionChild(isActive: isActive, delayMs: 200,
                child: Text("كل فنجان يقرّبك من مكافأة",
                  style: AppTypography.tajawal.copyWith(color: AppColors.secondary.withValues(alpha: 0.7), fontSize: 14)),
              ),
              const SizedBox(height: 2),
              SectionChild(isActive: isActive, delayMs: 300,
                child: Text("اجمع النقاط مع كل طلب واستبدلها بمكافآت حصرية",
                  style: AppTypography.tajawal.copyWith(color: AppColors.secondary.withValues(alpha: 0.4), fontSize: 12)),
              ),
              const SizedBox(height: 10),
              SectionChild(isActive: isActive, delayMs: 350,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.2), Colors.transparent]),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("☕", style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Text("اطلب مرّة واحدة واحصل على فنجان قهوة مجاني",
                        style: AppTypography.tajawal.copyWith(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: 480,
                child: _buildPointsCard(context, userPoints, currentLevel, nextPointsNeeded, nextLevel, progress),
              ),
              const SizedBox(height: 16),
              SectionChild(isActive: isActive, delayMs: 600,
                child: Text("المكافآت المتاحة",
                  style: AppTypography.elMessiri.copyWith(fontSize: 18, color: AppColors.textLight)),
              ),
              const SizedBox(height: 2),
              SectionChild(isActive: isActive, delayMs: 700,
                child: Text("استبدل نقاطك بهذه الهدايا",
                  style: AppTypography.tajawal.copyWith(color: AppColors.secondary.withValues(alpha: 0.5), fontSize: 12)),
              ),
              const SizedBox(height: 12),
              _RewardsRow(userPoints: userPoints),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context, int userPoints, String currentLevel, int nextPointsNeeded, String nextLevel, double progress) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF2B1800), Color(0xFF1A0A00), Color(0xFF2B1008)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 60, offset: const Offset(0, 20))],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(borderRadius: BorderRadius.circular(24), child: const ArabicPattern()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SectionChild(
                  isActive: isActive, delayMs: 400,
                  child: Text("رصيدك الحالي", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13)),
                ),
                const SizedBox(height: 2),
                SectionChild(
                  isActive: isActive, delayMs: 500,
                  child: Text(toArabicNum(userPoints),
                    style: AppTypography.cairo.copyWith(fontSize: 44, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1),
                  ).animate().scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), curve: Curves.elasticOut, duration: 800.ms),
                ),
                SectionChild(
                  isActive: isActive, delayMs: 500,
                  child: Text("نقطة", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 14)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CoffeeBeanDivider(),
                ),
                SectionChild(
                  isActive: isActive, delayMs: 600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("عضو $currentLevel",
                        style: AppTypography.cairo.copyWith(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                      Text("${toArabicNum(nextPointsNeeded)} نقطة لـ$nextLevel",
                        style: AppTypography.cairo.copyWith(color: AppColors.secondary, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SectionChild(
                  isActive: isActive, delayMs: 700,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Container(height: 6, color: Colors.white.withValues(alpha: 0.1)),
                        FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            height: 6,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)]),
                            ),
                          ).animate().shimmer(duration: 2.seconds, color: Colors.white.withValues(alpha: 0.2))
                            .animate().slideX(begin: -1, end: 0, duration: 1.seconds, curve: Curves.easeOut),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SectionChild(
                  isActive: isActive, delayMs: 800,
                  child: Hoverable(
                    onTap: () => context.push('/loyalty'),
                    glowColor: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text("اكتشف المكافآت", textAlign: TextAlign.center,
                        style: AppTypography.tajawal.copyWith(color: AppColors.background, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _rewards = [
  (name: "قهوة عربية مجانية", points: 500, id: "r1"),
  (name: "كابتشينو مجاني", points: 800, id: "r2"),
  (name: "حلوى بن الغالي", points: 1000, id: "r3"),
  (name: "جلسة VIP", points: 2000, id: "r4"),
];

class _RewardsRow extends StatelessWidget {
  final int userPoints;
  const _RewardsRow({required this.userPoints});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_rewards.length, (i) {
        final r = _rewards[i];
        final canRedeem = userPoints >= r.points;
        return Padding(
          padding: EdgeInsets.only(left: i < _rewards.length - 1 ? 12 : 0),
          child: _RewardCard(
            name: r.name, points: r.points,
            canRedeem: canRedeem, index: i,
          ),
        );
      }),
    );
  }
}

class _RewardCard extends StatefulWidget {
  final String name;
  final int points;
  final bool canRedeem;
  final int index;
  const _RewardCard({required this.name, required this.points, required this.canRedeem, required this.index});

  @override
  State<_RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends State<_RewardCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final canRedeem = widget.canRedeem;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Animate(
        effects: [
          FadeEffect(delay: (800 + widget.index * 100).ms, duration: 500.ms),
          SlideEffect(begin: const Offset(0, 0.1), end: Offset.zero, delay: (800 + widget.index * 100).ms, duration: 500.ms),
        ],
        child: AnimatedScale(
          scale: _hovered ? 1.08 : 1.0,
          duration: 200.ms,
          child: AnimatedContainer(
            duration: 200.ms,
            width: 195,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: canRedeem
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.06),
              ),
              boxShadow: canRedeem && _hovered
                  ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 2)]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 110,
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
                            child: const Center(child: Text("🔒", style: TextStyle(fontSize: 20))),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white.withValues(alpha: 0.03),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.name,
                          style: AppTypography.elMessiri.copyWith(color: AppColors.textLight, fontSize: 11),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${toArabicNum(widget.points)} نقطة",
                              style: AppTypography.cairo.copyWith(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            if (canRedeem)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2B7A2B).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text("متاح",
                                  style: AppTypography.cairo.copyWith(color: const Color(0xFF4CAF50), fontSize: 8),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
