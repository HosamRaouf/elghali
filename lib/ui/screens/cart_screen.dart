import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/breakpoints.dart';
import '../../data/coffee_data.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../components/core/logo_circle.dart';
import '../components/core/empty_state.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            getDeviceType(constraints.maxWidth) == DeviceType.desktop;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "السلة",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cartState.isEmpty
                                      ? "سلّتك فارغة"
                                      : "${toArabicNum(cartState.items.length)} منتجات",
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

                // Content
                Expanded(
                  child: cartState.isEmpty
                      ? _buildEmptyState(context)
                      : isDesktop
                      ? _buildDesktopCart(context, ref, cartState)
                      : _buildCartList(context, ref, cartState),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      title: "ما شربتش القهوة؟",
      subtitle: "سلّتك فارغة... اكتشف قائمتنا الأصيلة وأضف ما يغريك",
      icon: "☕",
      action: ElevatedButton(
        onPressed: () => context.go('/menu'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "تصفح القائمة",
          style: AppTypography.cairo.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context, WidgetRef ref, CartState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        item.product.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.product.name,
                                  style: AppTypography.elMessiri.copyWith(
                                    color: AppColors.textLight,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .removeItem(item.id),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.secondary,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          if (item.selectedSize != null) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.selectedSize!.label,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${toArabicNum(item.totalPrice)} ج.م ",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(cartProvider.notifier)
                                        .updateQuantity(
                                          item.id,
                                          item.quantity - 1,
                                        ),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.08,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 16,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    child: Text(
                                      toArabicNum(item.quantity),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(cartProvider.notifier)
                                        .updateQuantity(
                                          item.id,
                                          item.quantity + 1,
                                        ),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            Color(0xFFB5682A),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                            color: AppColors.background,
                                            fontSize: 16,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideX(
                begin: 0.2,
                end: 0,
                duration: 300.ms,
                curve: Curves.easeOutQuad,
              );
            },
          ),
        ),

        // Order Summary
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ملخص الطلب",
                style: TextStyle(color: AppColors.textLight, fontSize: 18),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "المنتجات",
                    style: TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),
                  Text(
                    "${toArabicNum(state.subtotal)} ج.م ",
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "رسوم التوصيل",
                    style: TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),
                  Text(
                    "${toArabicNum(state.deliveryFee)} ج.م ",
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  height: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "الإجمالي",
                    style: TextStyle(color: AppColors.textLight, fontSize: 18),
                  ),
                  Text(
                    "${toArabicNum(state.total)} ج.م ",
                    style: AppTypography.cairo.copyWith(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Checkout Button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: ElevatedButton(
            onPressed: () => context.push('/checkout'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: AppTypography.cairo.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              elevation: 8,
              shadowColor: AppColors.primary.withValues(alpha: 0.4),
            ),
            child: Text("المتابعة للدفع • ${toArabicNum(state.total)} ج.م"),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopCart(
    BuildContext context,
    WidgetRef ref,
    CartState state,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              item.product.image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.product.name,
                                        style: AppTypography.elMessiri.copyWith(
                                          color: AppColors.textLight,
                                          fontSize: 18,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => ref
                                          .read(cartProvider.notifier)
                                          .removeItem(item.id),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: AppColors.secondary,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.selectedSize != null) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.selectedSize!.label,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${toArabicNum(item.totalPrice)} ج.م ",
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        _buildQuantityBtn(
                                          ref,
                                          item.id,
                                          item.quantity - 1,
                                          "-",
                                        ),
                                        SizedBox(
                                          width: 48,
                                          child: Text(
                                            toArabicNum(item.quantity),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: AppColors.textLight,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        _buildQuantityBtn(
                                          ref,
                                          item.id,
                                          item.quantity + 1,
                                          "+",
                                          isPrimary: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideX(
                      begin: 0.2,
                      end: 0,
                      duration: (300 + index * 100).ms,
                      curve: Curves.easeOutQuad,
                    );
                  },
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "ملخص الطلب",
                        style: AppTypography.elMessiri.copyWith(
                          color: AppColors.textLight,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSummaryRow(
                        "المنتجات",
                        "${toArabicNum(state.subtotal)} ج.م ",
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        "رسوم التوصيل",
                        "${toArabicNum(state.deliveryFee)} ج.م ",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Divider(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          height: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "الإجمالي",
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${toArabicNum(state.total)} ج.م ",
                            style: AppTypography.cairo.copyWith(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => context.push('/checkout'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 64),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: AppTypography.cairo.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 12,
                          shadowColor: AppColors.primary.withValues(alpha: 0.5),
                        ),
                        child: Text(
                          "المتابعة للدفع • ${toArabicNum(state.total)} ج.م",
                        ),
                      ),
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

  Widget _buildQuantityBtn(
    WidgetRef ref,
    String itemId,
    int newQuantity,
    String label, {
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: () =>
          ref.read(cartProvider.notifier).updateQuantity(itemId, newQuantity),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFB5682A)],
                )
              : null,
          color: isPrimary ? null : Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: isPrimary
              ? null
              : Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isPrimary ? AppColors.background : AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.secondary, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
