import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/breakpoints.dart';
import '../../../viewmodels/orders_viewmodel.dart';
import '../components/order/coffee_divider.dart';
import '../components/core/empty_state.dart';
import '../components/order/order_card.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersProvider);
    final liveOrders = ordersState.liveOrders;
    final finishedOrders = ordersState.finishedOrders;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            getDeviceType(constraints.maxWidth) == DeviceType.desktop;
        final padding = isDesktop ? 24.0 : 20.0;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    "طلباتي",
                    style: AppTypography.elMessiri.copyWith(
                      color: AppColors.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textLight,
                    ),
                    onPressed: () => context.pop(),
                  ),
                ),
          body: ordersState.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 1000 : 800,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isDesktop ? 48 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isDesktop)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: padding,
                                vertical: 16,
                              ),
                              child: Text(
                                "طلباتي",
                                style: AppTypography.elMessiri.copyWith(
                                  color: AppColors.textLight,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          if (liveOrders.isEmpty && finishedOrders.isEmpty)
                            _buildEmptyState(context)
                          else ...[
                            // Live Orders Section
                            if (liveOrders.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: padding,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4CAF50),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "الطلبات الحالية",
                                      style: AppTypography.cairo.copyWith(
                                        color: AppColors.textLight,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isDesktop)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: padding,
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          mainAxisExtent: 180,
                                        ),
                                    itemCount: liveOrders.length,
                                    itemBuilder: (context, index) =>
                                        OrderCard(order: liveOrders[index]),
                                  ),
                                )
                              else
                                ...liveOrders.map(
                                  (order) => OrderCard(order: order),
                                ),
                            ],

                            const SizedBox(height: 24),

                            // Coffee Divider
                            if (finishedOrders.isNotEmpty)
                              const CoffeeDivider(label: "طلبات سابقة"),

                            // Finished Orders Section
                            if (finishedOrders.isNotEmpty)
                              if (isDesktop)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: padding,
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          mainAxisExtent: 180,
                                        ),
                                    itemCount: finishedOrders.length,
                                    itemBuilder: (context, index) =>
                                        OrderCard(order: finishedOrders[index]),
                                  ),
                                )
                              else
                                ...finishedOrders.map(
                                  (order) => OrderCard(order: order),
                                ),

                            const SizedBox(height: 60),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      title: "لا توجد طلبات بعد",
      subtitle: "اطلب الآن واستمتع بأفضل أنواع البن",
      icon: "📦",
      action: ElevatedButton(
        onPressed: () => context.go('/menu'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text("تصفح القائمة", style: AppTypography.cairo.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
