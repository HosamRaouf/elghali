import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/coffee_data.dart';
import '../../../models/order/order.dart';
import '../../../viewmodels/admin_viewmodel.dart';
import '../components/admin_bar_chart.dart';
import '../components/admin_stats_card.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الإحصائيات",
            style: AppTypography.elMessiri.copyWith(
              fontSize: 28,
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "نظرة عامة على أداء المتجر",
            style: AppTypography.tajawal.copyWith(
              color: AppColors.secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildStatsGrid(state),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 700) {
                return Column(
                  children: [
                    _buildRevenueChart(state),
                    const SizedBox(height: 20),
                    _buildOrderStatus(state),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildRevenueChart(state)),
                  const SizedBox(width: 20),
                  Expanded(flex: 1, child: _buildOrderStatus(state)),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _buildRecentOrders(state),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(AdminState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1000 ? 4 : 2;
        final aspectRatio = constraints.maxWidth > 1000 ? 2.8 : 2.2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
          children: [
            AdminStatsCard(
              title: "إجمالي الطلبات",
              value: toArabicNum(state.totalOrders),
              icon: Icons.receipt_long_rounded,
              subtitle: "${toArabicNum(state.pendingOrders)} قيد الانتظار",
            ),
            AdminStatsCard(
              title: "إجمالي الإيرادات",
              value: "${toArabicNum(state.totalRevenue.toInt())} ج.م",
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.success,
              subtitle: "من ${toArabicNum(state.completedOrders)} طلب مكتمل",
            ),
            AdminStatsCard(
              title: "المنتجات",
              value: toArabicNum(state.totalProducts),
              icon: Icons.coffee_rounded,
              subtitle: "في ${toArabicNum(state.categories.length)} تصنيف",
            ),
            AdminStatsCard(
              title: "المستخدمون",
              value: toArabicNum(state.totalUsers),
              icon: Icons.people_rounded,
              iconColor: const Color(0xFF64B5F6),
              subtitle: "${toArabicNum(15000)} نقطة ولاء",
            ),
          ],
        );
      },
    );
  }

  Widget _buildRevenueChart(AdminState state) {
    final days = [
      "السبت",
      "الأحد",
      "الإثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
    ];
    final revenues = [120.0, 200.0, 150.0, 280.0, 220.0, 350.0, 180.0];
    final maxRev = revenues.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الإيرادات (آخر 7 أيام)",
            style: AppTypography.cairo.copyWith(
              color: AppColors.textLight,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${toArabicNum(revenues.fold(0.0, (a, b) => a + b).toInt())} ج.م هذا الأسبوع",
            style: AppTypography.tajawal.copyWith(
              color: AppColors.primary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: AdminBarChart(
              values: revenues,
              labels: days,
              maxValue: maxRev,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(AdminState state) {
    final statusData = [
      (_SectionData(
        "قيد الانتظار",
        state.pendingOrders.toDouble(),
        const Color(0xFFFFA726),
      )),
      (_SectionData(
        "قيد التنفيذ",
        state.processingOrders.toDouble(),
        const Color(0xFF42A5F5),
      )),
      (_SectionData(
        "مكتمل",
        state.completedOrders.toDouble(),
        AppColors.success,
      )),
      (_SectionData("ملغي", state.cancelledOrders.toDouble(), AppColors.error)),
    ];
    final total = state.totalOrders.toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "حالة الطلبات",
            style: AppTypography.cairo.copyWith(
              color: AppColors.textLight,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...statusData.map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: d.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      d.label,
                      style: AppTypography.tajawal.copyWith(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    toArabicNum(d.count.toInt()),
                    style: AppTypography.cairo.copyWith(
                      color: AppColors.textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: Row(
                children: statusData.map((d) {
                  final fraction = total > 0 ? d.count / total : 0.0;
                  return Expanded(
                    flex: (fraction * 100).round().clamp(0, 100),
                    child: Container(color: d.color),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(AdminState state) {
    final recent = state.liveOrders.take(4).toList();
    if (recent.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "آخر الطلبات",
                style: AppTypography.cairo.copyWith(
                  color: AppColors.textLight,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "عرض الكل",
                style: AppTypography.tajawal.copyWith(
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recent.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: order.status == OrderStatus.processing
                          ? const Color(0xFF42A5F5).withValues(alpha: 0.15)
                          : const Color(0xFFFFA726).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      order.status == OrderStatus.processing
                          ? Icons.check_circle_outline
                          : Icons.hourglass_empty_rounded,
                      size: 18,
                      color: order.status == OrderStatus.processing
                          ? const Color(0xFF42A5F5)
                          : const Color(0xFFFFA726),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: AppTypography.cairo.copyWith(
                            color: AppColors.textLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${order.items.length} منتجات • ${order.paymentMethod}",
                          style: AppTypography.tajawal.copyWith(
                            color: AppColors.secondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${toArabicNum(order.totalAmount.toInt())} ج.م",
                    style: AppTypography.elMessiri.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionData {
  final String label;
  final double count;
  final Color color;
  const _SectionData(this.label, this.count, this.color);
}
