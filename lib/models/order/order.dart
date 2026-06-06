import 'package:equatable/equatable.dart';
import '../cart_item/cart_item.dart';

enum OrderStatus {
  pending,
  processing,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return "قيد الانتظار";
      case OrderStatus.processing:
        return "قيد التنفيذ";
      case OrderStatus.completed:
        return "تم التوصيل";
      case OrderStatus.cancelled:
        return "ملغي";
    }
  }

  bool get isLive => this == OrderStatus.pending || this == OrderStatus.processing;
  bool get isFinished => this == OrderStatus.completed || this == OrderStatus.cancelled;
}

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final String location;
  final String phone;
  final String paymentMethod;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.location,
    required this.phone,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        totalAmount,
        status,
        createdAt,
        location,
        phone,
        paymentMethod,
      ];
}
