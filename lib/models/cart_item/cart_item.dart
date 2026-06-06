import 'package:equatable/equatable.dart';
import '../product/product.dart';

class CartItem extends Equatable {
  final String id;
  final Product product;
  final int quantity;
  final ProductSize? selectedSize;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.selectedSize,
  });

  double get totalPrice => (selectedSize?.price ?? product.price) * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    ProductSize? selectedSize,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, selectedSize];
}
