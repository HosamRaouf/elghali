import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/coffee_data.dart';
import '../../../models/order/order.dart';
import '../../../models/user/user.dart';
import '../../../viewmodels/admin_viewmodel.dart';
import '../../components/core/empty_state.dart';

class AdminUsers extends ConsumerStatefulWidget {
  const AdminUsers({super.key});

  @override
  ConsumerState<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends ConsumerState<AdminUsers> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProvider);
    final users = _searchQuery.isEmpty
        ? state.users
        : state.users.where((u) =>
            u.name.contains(_searchQuery) || u.phone.contains(_searchQuery)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("إدارة المستخدمين",
            style: AppTypography.elMessiri.copyWith(fontSize: 28, color: AppColors.textLight, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("عرض وإدارة حسابات العملاء ونقاط الولاء",
            style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 14)),
          const SizedBox(height: 20),
          SizedBox(
            height: 42,
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'بحث عن مستخدم...',
                hintStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.5), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondary, size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () => setState(() => _searchQuery = ''),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, color: AppColors.secondary, size: 18),
                        ),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (users.isEmpty)
            const EmptyState(title: "لا توجد حسابات", subtitle: "لم يتم تسجيل أي مستخدم بعد", icon: "👤")
          else
            ...users.asMap().entries.map((entry) => _buildUserCard(context, entry.key, entry.value, ref)),
        ],
      ),
    );
  }

  String _level(int points) {
    if (points >= 2000) return "بلاتيني";
    if (points >= 1000) return "ذهبي";
    if (points >= 500) return "فضي";
    return "برونزي";
  }

  Color _levelColor(String level) {
    return {
      "بلاتيني": const Color(0xFFE5E4E2),
      "ذهبي": AppColors.primary,
      "فضي": const Color(0xFF9E9E9E),
      "برونزي": const Color(0xFFCD7F32),
    }[level]!;
  }

  Widget _buildUserCard(BuildContext context, int index, User user, WidgetRef ref) {
    final level = _level(user.points);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showUserDetail(context, index, user, ref),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(user.name.substring(0, 1),
                      style: AppTypography.cairo.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.background)),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                      style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(user.phone,
                      style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showUserDetail(context, index, user, ref),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${toArabicNum(user.points)} نقطة",
                  style: AppTypography.elMessiri.copyWith(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _levelColor(level).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(level,
                    style: AppTypography.tajawal.copyWith(color: _levelColor(level), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _showPointsDialog(context, index, user, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("تعديل النقاط",
                style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserDetail(BuildContext context, int index, User user, WidgetRef ref) {
    final state = ref.read(adminProvider);
    final level = _level(user.points);
    final userOrders = state.orders.where((o) => o.phone == user.phone).toList();
    final totalSpent = userOrders.fold(0.0, (sum, o) => sum + o.totalAmount);
    final uniqueProducts = <String>{};
    for (final o in userOrders) {
      for (final item in o.items) {
        uniqueProducts.add(item.product.id);
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D0500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 640),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(user.name.substring(0, 1),
                                  style: AppTypography.cairo.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.background)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.name,
                                    style: AppTypography.elMessiri.copyWith(fontSize: 20, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.phone_outlined, size: 14, color: AppColors.secondary),
                                      const SizedBox(width: 6),
                                      Text(user.phone,
                                        style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text("${toArabicNum(user.points)} نقطة",
                                  style: AppTypography.elMessiri.copyWith(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _levelColor(level).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(level,
                                    style: AppTypography.tajawal.copyWith(color: _levelColor(level), fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white10, height: 1),
                        const SizedBox(height: 20),
                        Text("الإحصائيات",
                          style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _statCard(Icons.receipt_long_rounded, "إجمالي الطلبات", toArabicNum(userOrders.length)),
                            const SizedBox(width: 12),
                            _statCard(Icons.trending_up_rounded, "إجمالي الإنفاق", "${toArabicNum(totalSpent.toInt())} ج.م"),
                            const SizedBox(width: 12),
                            _statCard(Icons.coffee_rounded, "منتجات مفضلة", toArabicNum(uniqueProducts.length)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white10, height: 1),
                        const SizedBox(height: 20),
                        Text("الطلبات",
                          style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("${toArabicNum(userOrders.length)} طلب",
                          style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
                        const SizedBox(height: 12),
                        if (userOrders.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text("لا توجد طلبات لهذا المستخدم",
                                style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13)),
                            ),
                          )
                        else
                          ...userOrders.map((o) => _buildOrderTile(o)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.primary.withValues(alpha: 0.1))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () { Navigator.pop(ctx); _showPointsDialog(context, index, user, ref); },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("تعديل النقاط",
                            style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("إغلاق", style: AppTypography.cairo.copyWith(color: AppColors.primary, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(value,
              style: AppTypography.elMessiri.copyWith(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
              style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTile(Order order) {
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: statusColors[order.status]!.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              order.status == OrderStatus.completed
                  ? Icons.check_circle_outline
                  : order.status == OrderStatus.cancelled
                      ? Icons.cancel_outlined
                      : Icons.hourglass_empty_rounded,
              size: 18, color: statusColors[order.status],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(order.id,
                      style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: statusColors[order.status]!.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(statusLabels[order.status]!,
                        style: AppTypography.tajawal.copyWith(color: statusColors[order.status], fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text("${order.items.length} منتجات • ${order.paymentMethod}",
                  style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 10)),
              ],
            ),
          ),
          Text("${toArabicNum(order.totalAmount.toInt())} ج.م",
            style: AppTypography.elMessiri.copyWith(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showPointsDialog(BuildContext context, int index, User user, WidgetRef ref) {
    final ctrl = TextEditingController(text: user.points.toString());

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D0500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("تعديل نقاط الولاء",
                style: AppTypography.elMessiri.copyWith(fontSize: 20, color: AppColors.textLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(user.name,
                style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 13)),
              const SizedBox(height: 20),
              Text("عدد النقاط", style: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 12)),
              const SizedBox(height: 6),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                style: AppTypography.tajawal.copyWith(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("إلغاء", style: AppTypography.cairo.copyWith(color: AppColors.secondary, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      final pts = int.tryParse(ctrl.text);
                      if (pts != null) {
                        ref.read(adminProvider.notifier).updateUserPoints(index, pts);
                      }
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("حفظ",
                        style: AppTypography.cairo.copyWith(color: AppColors.background, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
