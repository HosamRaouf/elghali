import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/coffee_data.dart';
import '../../../../models/branch/branch.dart';
import '../../../components/core/hoverable.dart';

class DesktopBranchesSection extends ConsumerWidget {
  final bool isActive;
  const DesktopBranchesSection({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyedSubtree(
      key: ValueKey('branches_$isActive'),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SectionChild(isActive: isActive, delayMs: 0,
                child: Text("فروعنا", style: AppTypography.arefRuqaa.copyWith(fontSize: 36, color: AppColors.textLight)),
              ),
              const SizedBox(height: 8),
              SectionChild(isActive: isActive, delayMs: 200,
                child: Text("تفضل بزيارة أقرب فرع إليك",
                  style: AppTypography.tajawal.copyWith(color: AppColors.secondary.withValues(alpha: 0.5), fontSize: 15)),
              ),
              const SizedBox(height: 32),
              ...List.generate(2, (row) => Padding(
                padding: EdgeInsets.only(bottom: row < 1 ? 24 : 0),
                child: SectionChild(
                  isActive: isActive, delayMs: 400 + (row * 100).toInt(),
                  child: Row(
                    children: List.generate(3, (col) {
                      final i = row * 3 + col;
                      if (i >= branches.length) return const Spacer();
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: col < 2 ? 20 : 0),
                          child: _BranchCard(branch: branches[i], index: i),
                        ),
                      );
                    }),
                  ),
                ),
              )),
              const SizedBox(height: 20),
              SectionChild(
                isActive: isActive, delayMs: 800,
                child: Hoverable(
                  glowColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/branches'),
                    icon: const Icon(Icons.map_rounded, color: AppColors.primary),
                    label: Text("عرض كل الفروع", style: AppTypography.tajawal.copyWith(color: AppColors.primary)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final Branch branch; final int index;
  const _BranchCard({required this.branch, required this.index});

  Future<void> _openDirections() async {
    final query = Uri.encodeComponent("${branch.name}، ${branch.city}، مصر");
    final url = "https://www.google.com/maps/dir/?api=1&destination=$query";
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.store_rounded, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 16),
          Text(branch.name, style: AppTypography.elMessiri.copyWith(fontSize: 16, color: AppColors.textLight)),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: AppColors.secondary, size: 14),
              const SizedBox(width: 6),
              Flexible(child: Text(branch.address, style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone, color: AppColors.secondary, size: 14),
              const SizedBox(width: 6),
              Text(branch.phone, style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (i) => Icon(Icons.star, color: AppColors.primary, size: 16, shadows: [
              Shadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 6),
            ])),
          ),
          const SizedBox(height: 16),
          Hoverable(
            onTap: _openDirections,
            glowColor: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFFB5682A)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions, color: AppColors.background, size: 18),
                  const SizedBox(width: 8),
                  Text("اتجاهات", style: AppTypography.tajawal.copyWith(color: AppColors.background, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 80).ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
