import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../components/core/logo_circle.dart';

class SettingsToggle {
  final String id;
  final String label;
  final String desc;
  final bool value;

  const SettingsToggle({
    required this.id,
    required this.label,
    required this.desc,
    required this.value,
  });

  SettingsToggle copyWith({bool? value}) => SettingsToggle(
    id: id,
    label: label,
    desc: desc,
    value: value ?? this.value,
  );
}

class SettingsNotifier extends Notifier<List<SettingsToggle>> {
  @override
  List<SettingsToggle> build() {
    return const [
      SettingsToggle(
        id: "notif",
        label: "الإشعارات",
        desc: "تنبيهات العروض والطلبات",
        value: true,
      ),
      SettingsToggle(
        id: "promo",
        label: "العروض الترويجية",
        desc: "رسائل العروض الخاصة",
        value: false,
      ),
      SettingsToggle(
        id: "sound",
        label: "الأصوات",
        desc: "أصوات تأكيد الطلب",
        value: true,
      ),
    ];
  }

  void toggle(String id, bool value) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(value: value) else t,
    ];
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, List<SettingsToggle>>(() {
      return SettingsNotifier();
    });

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggles = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 16),
                        Text(
                          "الإعدادات",
                          style: AppTypography.elMessiri.copyWith(
                            fontSize: 28,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Center(
                child: Column(
                  children: [
                    const LogoCircle(size: 80),
                    const SizedBox(height: 8),
                    Text(
                      "بن الغالي",
                      style: AppTypography.elMessiri.copyWith(
                        color: AppColors.primary,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "الإصدار ١.٠.٠",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "جميع الحقوق محفوظة © ٢٠٢٦ بن الغالي",
                      style: AppTypography.cairo.copyWith(
                        color: const Color(0xFF2B2118),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Toggles Section
              _buildSectionTitle("التطبيق"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: toggles.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        return _buildToggleItem(
                          item,
                          idx == toggles.length - 1,
                          ref,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // Account Section
              _buildSectionTitle("الحساب"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        _buildActionItem(
                          "تعديل الملف الشخصي",
                          "✏️",
                          isLast: false,
                        ),
                        _buildActionItem(
                          "تغيير رقم الهاتف",
                          "📱",
                          isLast: false,
                        ),
                        _buildActionItem(
                          "اللغة",
                          "🌐",
                          value: "العربية",
                          isLast: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // About Section
              _buildSectionTitle("عن التطبيق"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        _buildActionItem(
                          "الشروط والأحكام",
                          "📋",
                          isLast: false,
                        ),
                        _buildActionItem("سياسة الخصوصية", "🔒", isLast: false),
                        _buildActionItem("تقييم التطبيق", "⭐", isLast: true),
                      ],
                    ),
                  ),
                ),
              ),

              // Logout Button
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.error.withValues(alpha: 0.05),
                    ),
                    child: Center(
                      child: Text(
                        "تسجيل الخروج",
                        style: AppTypography.cairo.copyWith(
                          color: AppColors.error,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Version Info
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Text(
        title,
        style: AppTypography.cairo.copyWith(
          color: AppColors.secondary,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildToggleItem(SettingsToggle item, bool isLast, WidgetRef ref) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTypography.cairo.copyWith(
                    color: AppColors.textLight,
                    fontSize: 15,
                  ),
                ),
                Text(
                  item.desc,
                  style: AppTypography.cairo.copyWith(
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: item.value,
            activeTrackColor: AppColors.primary,
            onChanged: (val) {
              ref.read(settingsProvider.notifier).toggle(item.id, val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    String label,
    String icon, {
    String? value,
    required bool isLast,
  }) {
    return Container(
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
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTypography.cairo.copyWith(
                color: AppColors.textLight,
                fontSize: 15,
              ),
            ),
          ),
          if (value != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                value,
                style: AppTypography.cairo.copyWith(
                  color: AppColors.secondary,
                  fontSize: 13,
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
    );
  }
}
