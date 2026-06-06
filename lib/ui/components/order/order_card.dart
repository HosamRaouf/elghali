import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/coffee_data.dart';
import '../../../models/order/order.dart';

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isLive = widget.order.status.isLive;
    final statusColor = _getStatusColor(widget.order.status);
    final subtotal = widget.order.items.fold<double>(
      0,
      (sum, item) =>
          sum +
          (item.selectedSize?.price ?? item.product.price) * item.quantity,
    );

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isLive
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.cardBorder,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              children: [
                // Header
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.id,
                                  style: AppTypography.cairo.copyWith(
                                    color: AppColors.textLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  intl.DateFormat(
                                    'yyyy/MM/dd - hh:mm a',
                                    'ar',
                                  ).format(widget.order.createdAt),
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 12,
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
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isLive)
                                    Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                        .animate(onPlay: (c) => c.repeat())
                                        .scale(
                                          duration: 1.seconds,
                                          begin: const Offset(1, 1),
                                          end: const Offset(1.5, 1.5),
                                        )
                                        .fadeOut(),
                                  if (isLive) const SizedBox(width: 8),
                                  Text(
                                    widget.order.status.label,
                                    style: AppTypography.cairo.copyWith(
                                      color: statusColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.order.items.length} منتجات",
                              style: const TextStyle(
                                color: AppColors.secondary,
                              ),
                            ),
                            Text(
                              "${toArabicNum(widget.order.totalAmount)} ج.م",
                              style: AppTypography.cairo.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Expandable Content
                if (_isExpanded)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildSectionTitle("تفاصيل"),
                        const SizedBox(height: 12),
                        _buildDetailItem(
                          Icons.location_on_outlined,
                          widget.order.location,
                        ),
                        _buildDetailItem(
                          Icons.phone_outlined,
                          widget.order.phone,
                        ),
                        _buildDetailItem(
                          Icons.payment_outlined,
                          widget.order.paymentMethod,
                        ),

                        const SizedBox(height: 24),
                        _buildSectionTitle("المنتجات"),
                        const SizedBox(height: 12),
                        ...widget.order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "☕",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: const TextStyle(
                                          color: AppColors.textLight,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (item.selectedSize != null)
                                        Text(
                                          item.selectedSize!.label,
                                          style: const TextStyle(
                                            color: AppColors.secondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${toArabicNum(item.quantity)} x ${toArabicNum(item.selectedSize?.price ?? item.product.price)}",
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle("ملخص السعر"),
                        const SizedBox(height: 12),
                        _buildPriceRow("إجمالي المنتجات", subtotal),
                        _buildPriceRow("خدمة التوصيل", 20.0),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Colors.white10),
                        ),
                        _buildPriceRow(
                          "الإجمالي",
                          widget.order.totalAmount,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
              ],
            ),
          ),
        )
        .animate(target: isLive ? 1 : 0, onPlay: (c) => c.repeat(reverse: true))
        .boxShadow(
          begin: const BoxShadow(color: Colors.transparent, blurRadius: 0),
          end: BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 2,
          ),
          duration: 2.seconds,
        );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return AppColors.primary;
      case OrderStatus.completed:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.cairo.copyWith(
        color: AppColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double value, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.textLight : AppColors.secondary,
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "${isDiscount ? '' : ''}${toArabicNum(value)} ج.م",
            style: AppTypography.cairo.copyWith(
              color: isTotal
                  ? AppColors.primary
                  : (isDiscount ? AppColors.success : AppColors.textLight),
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.secondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
