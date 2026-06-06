import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/breakpoints.dart';
import '../../data/coffee_data.dart';
import '../../models/branch/branch.dart';
import '../components/core/custom_icons.dart';
import '../components/core/logo_circle.dart';

class BranchesScreen extends ConsumerStatefulWidget {
  const BranchesScreen({super.key});

  @override
  ConsumerState<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends ConsumerState<BranchesScreen> {
  String? _selectedBranchId;

  @override
  Widget build(BuildContext context) {
    final openBranchesCount = branches.where((b) => b.isOpen).length;
    final selectedBranch = _selectedBranchId != null
        ? branches.firstWhere((b) => b.id == _selectedBranchId)
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            getDeviceType(constraints.maxWidth) == DeviceType.desktop;

        if (isDesktop)
          return _buildDesktopLayout(
            context,
            openBranchesCount,
            selectedBranch,
          );

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "فروعنا",
                                      style: AppTypography.elMessiri.copyWith(
                                        fontSize: 28,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${toArabicNum(openBranchesCount)} فروع مفتوحة الآن",
                                      style: AppTypography.tajawal.copyWith(
                                        color: AppColors.secondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const LogoCircle(size: 52),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Stylized Map
                    _buildMapSection(
                      context,
                      openBranchesCount,
                      selectedBranch,
                    ),

                    // Selected Branch Info
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: selectedBranch != null
                          ? _buildBranchInfo(selectedBranch)
                          : const SizedBox.shrink(),
                    ),

                    // All Branches List
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "جميع الفروع",
                            style: AppTypography.elMessiri.copyWith(
                              color: AppColors.textLight,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...branches.map((branch) => _buildBranchCard(branch)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    int openBranchesCount,
    Branch? selectedBranch,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "فروعنا",
                                    style: AppTypography.elMessiri.copyWith(
                                      fontSize: 36,
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${toArabicNum(openBranchesCount)} فروع مفتوحة الآن",
                                    style: AppTypography.tajawal.copyWith(
                                      color: AppColors.secondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const LogoCircle(size: 64),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "جميع الفروع",
                              style: AppTypography.elMessiri.copyWith(
                                color: AppColors.textLight,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...branches.map(
                              (branch) => _buildBranchCard(branch),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                  child: Column(
                    children: [
                      _buildMapSection(
                        context,
                        openBranchesCount,
                        selectedBranch,
                      ),
                      if (selectedBranch != null) ...[
                        const SizedBox(height: 24),
                        Expanded(
                          child: SingleChildScrollView(
                            child: _buildBranchInfo(selectedBranch),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection(
    BuildContext context,
    int openBranchesCount,
    Branch? selectedBranch,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 280,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0A00), Color(0xFF0D0500)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: MapPainter())),
            ...branches.map((branch) {
              final isSelected = _selectedBranchId == branch.id;
              return Positioned(
                left:
                    (branch.x / 100) * (MediaQuery.of(context).size.width - 40),
                top: (branch.y / 100) * 280,
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedBranchId = isSelected ? null : branch.id;
                  }),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DallahLocationPin(
                            size: 32,
                            color: branch.isOpen
                                ? AppColors.primary
                                : AppColors.secondary,
                          )
                          .animate(target: isSelected ? 1 : 0)
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.2, 1.2),
                            duration: 300.ms,
                          ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xCC0D0500),
                          border: Border.all(
                            color: branch.isOpen
                                ? AppColors.primary.withValues(alpha: 0.4)
                                : AppColors.secondary.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          branch.city,
                          style: AppTypography.cairo.copyWith(
                            color: branch.isOpen
                                ? AppColors.primary
                                : AppColors.secondary,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xB30D0500),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 3,
                          backgroundColor: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "مفتوح",
                          style: AppTypography.cairo.copyWith(
                            fontSize: 10,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 3,
                          backgroundColor: Color(0xFF4A4040),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "مغلق",
                          style: AppTypography.cairo.copyWith(
                            fontSize: 10,
                            color: AppColors.secondary,
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
    );
  }

  Widget _buildBranchInfo(Branch selectedBranch) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            const Color(0xFFB5682A).withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedBranch.name,
                    style: AppTypography.elMessiri.copyWith(
                      color: AppColors.textLight,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    selectedBranch.city,
                    style: AppTypography.cairo.copyWith(
                      color: AppColors.secondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      (selectedBranch.isOpen
                              ? const Color(0xFF2B7A2B)
                              : const Color(0xFFB42828))
                          .withValues(alpha: 0.2),
                  border: Border.all(
                    color:
                        (selectedBranch.isOpen
                                ? const Color(0xFF2B7A2B)
                                : const Color(0xFFB42828))
                            .withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  selectedBranch.isOpen ? "مفتوح" : "مغلق",
                  style: AppTypography.cairo.copyWith(
                    color: selectedBranch.isOpen
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE57373),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.location_on_outlined, selectedBranch.address),
          _buildInfoRow(
            Icons.access_time,
            "أوقات العمل: ${selectedBranch.hours}",
          ),
          if (selectedBranch.isOpen)
            _buildInfoRow(
              Icons.timer_outlined,
              "وقت الانتظار: ${selectedBranch.waitTime}",
            ),
          _buildInfoRow(Icons.phone_outlined, selectedBranch.phone),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildActionBtn("الاتجاهات", isPrimary: true)),
              const SizedBox(width: 12),
              Expanded(child: _buildActionBtn("اتصل بنا")),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTypography.cairo.copyWith(
                color: AppColors.secondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(String label, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const LinearGradient(
                colors: [AppColors.primary, Color(0xFFB5682A)],
              )
            : null,
        color: isPrimary ? null : Colors.white.withValues(alpha: 0.05),
        border: isPrimary
            ? null
            : Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTypography.cairo.copyWith(
            color: isPrimary ? AppColors.background : AppColors.primary,
            fontSize: 14,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBranchCard(Branch branch) {
    final isSelected = _selectedBranchId == branch.id;
    return GestureDetector(
      onTap: () =>
          setState(() => _selectedBranchId = isSelected ? null : branch.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.03),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.06),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.location_pin,
                  size: 26,
                  color: branch.isOpen
                      ? AppColors.primary
                      : AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        branch.name,
                        style: AppTypography.elMessiri.copyWith(
                          color: AppColors.textLight,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        branch.isOpen ? "● مفتوح" : "● مغلق",
                        style: AppTypography.cairo.copyWith(
                          fontSize: 11,
                          color: branch.isOpen
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE57373),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    branch.address,
                    style: AppTypography.cairo.copyWith(
                      color: AppColors.secondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${branch.hours}${branch.isOpen ? ' • انتظار ${branch.waitTime}' : ''}",
                    style: AppTypography.cairo.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Grid
    for (double i = 0; i <= size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i <= size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Simplified Mansoura-like Outline (Dakahlia/Nile)
    final outlinePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.1)
      ..lineTo(size.width * 0.6, size.height * 0.15)
      ..lineTo(size.width * 0.8, size.height * 0.4)
      ..lineTo(size.width * 0.75, size.height * 0.7)
      ..lineTo(size.width * 0.5, size.height * 0.85)
      ..lineTo(size.width * 0.2, size.height * 0.6)
      ..lineTo(size.width * 0.15, size.height * 0.3)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, outlinePaint);

    // Some road lines
    final roadPaint = Paint()
      ..color = const Color(0xFFB5682A).withValues(alpha: 0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.5),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.7),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
