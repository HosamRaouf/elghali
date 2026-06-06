import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/coffee_data.dart';
import '../../../models/order/order.dart';
import '../../../viewmodels/admin_viewmodel.dart';
import '../../components/core/empty_state.dart';

class AdminOrders extends ConsumerStatefulWidget {
  const AdminOrders({super.key});

  @override
  ConsumerState<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends ConsumerState<AdminOrders> {
  OrderStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProvider);
    final orders = _filter == null
        ? state.orders
        : state.orders.where((o) => o.status == _filter!).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("إدارة الطلبات",
            style: AppTypography.elMessiri.copyWith(fontSize: 28, color: AppColors.textLight, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("عرض وإدارة طلبات العملاء",
            style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 14)),
          const SizedBox(height: 20),
          _buildFilters(state),
          const SizedBox(height: 20),
          if (orders.isEmpty)
            const EmptyState(title: "لا توجد طلبات", subtitle: "لا توجد طلبات تطابق معايير البحث", icon: "📦")
          else
            ...orders.map((order) => _buildOrderCard(order, state)),
        ],
      ),
    );
  }

  Widget _buildFilters(AdminState state) {
    final counts = {
      null: state.totalOrders,
      OrderStatus.pending: state.pendingOrders,
      OrderStatus.processing: state.processingOrders,
      OrderStatus.completed: state.completedOrders,
      OrderStatus.cancelled: state.cancelledOrders,
    };
    final labels = {
      null: "الكل",
      OrderStatus.pending: "قيد الانتظار",
      OrderStatus.processing: "قيد التنفيذ",
      OrderStatus.completed: "مكتمل",
      OrderStatus.cancelled: "ملغي",
    };
    final colors = {
      null: AppColors.primary,
      OrderStatus.pending: const Color(0xFFFFA726),
      OrderStatus.processing: const Color(0xFF42A5F5),
      OrderStatus.completed: AppColors.success,
      OrderStatus.cancelled: AppColors.error,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: counts.entries.map((entry) {
          final key = entry.key;
          final isActive = _filter == key;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => setState(() => _filter = key),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isActive ? AppColors.primaryGradient : null,
                  color: isActive ? null : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? Colors.transparent : AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: colors[key], shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text("${labels[key]} (${toArabicNum(entry.value)})",
                      style: AppTypography.cairo.copyWith(
                        color: isActive ? AppColors.background : AppColors.secondary,
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderCard(Order order, AdminState state) {
    final index = state.orders.indexOf(order);
    final statusColors = {
      OrderStatus.pending: const Color(0xFFFFA726),
      OrderStatus.processing: const Color(0xFF42A5F5),
      OrderStatus.completed: AppColors.success,
      OrderStatus.cancelled: AppColors.error,
    };
    final statusLabels = {
      OrderStatus.pending: "قيد الانتظار",
      OrderStatus.processing: "قيد التنفيذ",
      OrderStatus.completed: "مكتمل",
      OrderStatus.cancelled: "ملغي",
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColors[order.status]!.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(statusLabels[order.status]!,
                  style: AppTypography.tajawal.copyWith(color: statusColors[order.status], fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Text(order.id,
                style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text("${toArabicNum(order.totalAmount.toInt())} ج.م",
                style: AppTypography.elMessiri.copyWith(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: AppColors.secondary),
              const SizedBox(width: 6),
              Expanded(child: Text(order.location,
                style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 14, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text(order.phone,
                style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
              const SizedBox(width: 20),
              Icon(Icons.payment_outlined, size: 14, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text(order.paymentMethod,
                style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: order.items.map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text("${item.product.name} × ${toArabicNum(item.quantity)}",
                style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 11)),
            )).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (order.status == OrderStatus.pending) ...[
                _buildStatusButton("قيد التنفيذ", OrderStatus.processing, statusColors[OrderStatus.processing]!, index, state),
                const SizedBox(width: 8),
              ],
              if (order.status == OrderStatus.processing) ...[
                _buildStatusButton("مكتمل", OrderStatus.completed, AppColors.success, index, state),
                const SizedBox(width: 8),
              ],
              if (order.status.isLive) ...[
                _buildStatusButton("إلغاء", OrderStatus.cancelled, AppColors.error, index, state, outline: true),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String label, OrderStatus status, Color color, int index, AdminState state, {bool outline = false}) {
    return GestureDetector(
      onTap: () => ref.read(adminProvider.notifier).updateOrderStatus(index, status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: outline ? null : LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
          color: outline ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(8),
          border: outline ? Border.all(color: color.withValues(alpha: 0.5)) : null,
        ),
        child: Text(label,
          style: AppTypography.cairo.copyWith(
            color: outline ? color : AppColors.background,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
