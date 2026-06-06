import 'package:bonn_flutter/ui/components/core/arabic_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/breakpoints.dart';
import '../../data/coffee_data.dart';
import '../../models/user/user.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../components/core/custom_icons.dart';

class ProfileMenuItem {
  final String icon;
  final String label;
  final String path;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.path,
  });
}

final List<ProfileMenuItem> menuItems = [
  const ProfileMenuItem(icon: "📦", label: "طلباتي السابقة", path: "/orders"),
  const ProfileMenuItem(icon: "❤️", label: "المفضلة", path: "/profile"),
  const ProfileMenuItem(icon: "📍", label: "عناويني", path: "/profile"),
  const ProfileMenuItem(icon: "⚙️", label: "الإعدادات", path: "/settings"),
  const ProfileMenuItem(icon: "💬", label: "تواصل معنا", path: "/profile"),
  const ProfileMenuItem(icon: "ℹ️", label: "عن بن الغالي", path: "/profile"),
];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.isAuthenticated;
    final user = authState.user;
    const loyaltyPoints = 1250;
    const loyaltyLevel = "ذهبي";

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            getDeviceType(constraints.maxWidth) == DeviceType.desktop;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            child: isDesktop
                ? _buildDesktopProfile(
                    context,
                    ref,
                    authState,
                    isLoggedIn,
                    user,
                    loyaltyPoints,
                    loyaltyLevel,
                  )
                : Column(
                    children: [
                      // Header
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 280,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.08),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 12),
                              // Avatar
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child:
                                        Container(
                                              width: 96,
                                              height: 96,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    AppColors.primary
                                                        .withValues(alpha: 0.3),
                                                    const Color(
                                                      0xFFB5682A,
                                                    ).withValues(alpha: 0.2),
                                                  ],
                                                ),
                                                border: Border.all(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.5),
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "👤",
                                                  style: TextStyle(
                                                    fontSize: 40,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .animate(onPlay: (c) => c.repeat())
                                            .boxShadow(
                                              begin: const BoxShadow(
                                                color: Color(0x33C9A84C),
                                                blurRadius: 0,
                                                spreadRadius: 0,
                                              ),
                                              end: const BoxShadow(
                                                color: Color(0x00C9A84C),
                                                blurRadius: 12,
                                                spreadRadius: 12,
                                              ),
                                              duration: 2.5.seconds,
                                            ),
                                  ),
                                  Positioned(
                                    bottom: -2,
                                    left: -2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            Color(0xFFB5682A),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const OctagonalStar(
                                            size: 10,
                                            color: Color(0xFF0D0500),
                                            filled: true,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            loyaltyLevel,
                                            style: const TextStyle(
                                              color: Color(0xFF0D0500),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isLoggedIn
                                    ? (user?.name ?? "عميل الغالي")
                                    : "زائر كريم",
                                style: AppTypography.elMessiri.copyWith(
                                  fontSize: 24,
                                  color: AppColors.textLight,
                                ),
                              ),
                              if (isLoggedIn)
                                Text(
                                  user?.phone ?? "+201XXXXXXXXX",
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 13,
                                  ),
                                ),
                              if (!isLoggedIn)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: ElevatedButton(
                                    onPressed: () => context.push('/login'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.background,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      "تسجيل الدخول",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      // Loyalty Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () => context.push('/loyalty'),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF2B1800), Color(0xFF1A0A00)],
                              ),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
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
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "نقاطك",
                                                style: TextStyle(
                                                  color: AppColors.secondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    toArabicNum(loyaltyPoints),
                                                    style: AppTypography.cairo
                                                        .copyWith(
                                                          fontSize: 36,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              AppColors.primary,
                                                          height: 1,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Text(
                                                    "نقطة",
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.secondary,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${toArabicNum(250)} نقطة لمستوى البلاتيني",
                                                style: const TextStyle(
                                                  color: AppColors.secondary,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const OctagonalStar(
                                                size: 48,
                                                color: AppColors.primary,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "عضو ${loyaltyLevel}",
                                                style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 6,
                                              color: Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor: 0.83,
                                              child: Container(
                                                height: 6,
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppColors.primary,
                                                      Color(0xFFB5682A),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ).animate().slideX(
                                              begin: -1,
                                              end: 0,
                                              duration: 1.seconds,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "ذهبي",
                                            style: TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            "بلاتيني",
                                            style: TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 10,
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

                      // Stats
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            _buildStatCard(
                              toArabicNum(47),
                              "طلب",
                              "إجمالي الطلبات",
                            ),
                            const SizedBox(width: 12),
                            _buildStatCard(toArabicNum(5), "منتج", "المفضلة"),
                            const SizedBox(width: 12),
                            _buildStatCard(
                              toArabicNum(180),
                              "ج.م",
                              "المبلغ الموفّر",
                            ),
                          ],
                        ),
                      ),

                      // Menu
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Column(
                              children: menuItems.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final item = entry.value;
                                return _buildMenuItem(
                                  item,
                                  idx == menuItems.length - 1,
                                  idx,
                                  context,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

                      if (isLoggedIn)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFB42828,
                                ).withValues(alpha: 0.1),
                                border: Border.all(
                                  color: const Color(
                                    0xFFB42828,
                                  ).withValues(alpha: 0.25),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "تسجيل الخروج",
                                  style: AppTypography.cairo.copyWith(
                                    color: const Color(0xFFE57373),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopProfile(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
    bool isLoggedIn,
    User? user,
    int loyaltyPoints,
    String loyaltyLevel,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.3),
                              const Color(0xFFB5682A).withValues(alpha: 0.2),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text("👤", style: TextStyle(fontSize: 48)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFFB5682A)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const OctagonalStar(
                              size: 12,
                              color: Color(0xFF0D0500),
                              filled: true,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              loyaltyLevel,
                              style: const TextStyle(
                                color: Color(0xFF0D0500),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isLoggedIn ? (user?.name ?? "عميل الغالي") : "زائر كريم",
                  style: AppTypography.elMessiri.copyWith(
                    fontSize: 28,
                    color: AppColors.textLight,
                  ),
                ),
                if (isLoggedIn)
                  Text(
                    user?.phone ?? "+201XXXXXXXXX",
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 14,
                    ),
                  ),
                if (!isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ElevatedButton(
                      onPressed: () => context.push('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: _buildDesktopLoyaltySection(
                      loyaltyPoints,
                      loyaltyLevel,
                      context,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 5,
                    child: _buildDesktopMenuSection(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildDesktopLoyaltySection(
    int loyaltyPoints,
    String loyaltyLevel,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.push('/loyalty'),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2B1800), Color(0xFF1A0A00)],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "نقاطك",
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    toArabicNum(loyaltyPoints),
                                    style: AppTypography.cairo.copyWith(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "نقطة",
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${toArabicNum(250)} نقطة لمستوى البلاتيني",
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const OctagonalStar(
                                size: 48,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "عضو $loyaltyLevel",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Container(
                              height: 6,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.83,
                              child: Container(
                                height: 6,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      Color(0xFFB5682A),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ذهبي",
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "بلاتيني",
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 10,
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
        const SizedBox(height: 20),
        Row(
          children: [
            _buildStatCard(toArabicNum(47), "طلب", "إجمالي الطلبات"),
            const SizedBox(width: 12),
            _buildStatCard(toArabicNum(5), "منتج", "المفضلة"),
            const SizedBox(width: 12),
            _buildStatCard(toArabicNum(180), "ج.م", "المبلغ الموفّر"),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopMenuSection(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.isAuthenticated;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Column(
              children: menuItems.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return _buildMenuItem(
                  item,
                  idx == menuItems.length - 1,
                  idx,
                  context,
                );
              }).toList(),
            ),
          ),
        ),
        if (isLoggedIn)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFB42828).withValues(alpha: 0.1),
                  border: Border.all(
                    color: const Color(0xFFB42828).withValues(alpha: 0.25),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "تسجيل الخروج",
                    style: AppTypography.cairo.copyWith(
                      color: const Color(0xFFE57373),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(String value, String unit, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.cairo.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              unit,
              style: const TextStyle(color: AppColors.secondary, fontSize: 10),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.secondary, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    ProfileMenuItem item,
    bool isLast,
    int index,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => context.push(item.path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.025),
          border: Border(
            bottom: isLast
                ? BorderSide.none
                : BorderSide(color: Colors.white.withValues(alpha: 0.04)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: AppTypography.cairo.copyWith(
                  color: AppColors.textLight,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
  }
}
