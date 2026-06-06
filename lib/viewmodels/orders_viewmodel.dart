import 'package:flutter_riverpod/legacy.dart';

import '../data/coffee_data.dart';
import '../models/cart_item/cart_item.dart';
import '../models/order/order.dart';

class OrdersState {
  final List<Order> orders;
  final bool isLoading;

  OrdersState({required this.orders, this.isLoading = false});

  List<Order> get liveOrders =>
      orders.where((o) => o.status.isLive).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Order> get finishedOrders =>
      orders.where((o) => o.status.isFinished).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

class OrdersViewModel extends StateNotifier<OrdersState> {
  OrdersViewModel() : super(OrdersState(orders: [], isLoading: true)) {
    _loadMockOrders();
  }

  void _loadMockOrders() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final mockOrders = [
      Order(
        id: "ORD-7742",
        items: [
          CartItem(
            id: "ci1",
            product: products[0],
            quantity: 2,
            selectedSize: products[0].sizes![0],
          ),
          CartItem(
            id: "ci2",
            product: products[3],
            quantity: 1,
            selectedSize: products[3].sizes![1],
          ),
        ],
        totalAmount: 220.0,
        status: OrderStatus.processing,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        location: "المنصورة، المشاية السفلية، برج الصفوة",
        phone: "+201012345678",
        paymentMethod: "نقداً عند الاستلام",
      ),
      Order(
        id: "ORD-7741",
        items: [
          CartItem(
            id: "ci3",
            product: products[5],
            quantity: 3,
            selectedSize: products[5].sizes![0],
          ),
        ],
        totalAmount: 150.0,
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        location: "المنصورة، حي الجامعة، أمام بوابة توشكى",
        phone: "+201012345678",
        paymentMethod: "بطاقة ائتمان",
      ),
      Order(
        id: "ORD-7735",
        items: [
          CartItem(
            id: "ci4",
            product: products[2],
            quantity: 1,
            selectedSize: products[2].sizes![2],
          ),
        ],
        totalAmount: 190.0,
        status: OrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        location: "المنصورة، شارع جيهان، عمارة الفتح",
        phone: "+201012345678",
        paymentMethod: "محفظة إلكترونية",
      ),
      Order(
        id: "ORD-7730",
        items: [
          CartItem(
            id: "ci5",
            product: products[4],
            quantity: 4,
            selectedSize: products[4].sizes![0],
          ),
        ],
        totalAmount: 160.0,
        status: OrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        location: "المنصورة، توريل، شارع المختلط",
        phone: "+201012345678",
        paymentMethod: "نقداً عند الاستلام",
      ),
    ];

    state = OrdersState(orders: mockOrders, isLoading: false);
  }
}

final ordersProvider = StateNotifierProvider<OrdersViewModel, OrdersState>((
  ref,
) {
  return OrdersViewModel();
});
