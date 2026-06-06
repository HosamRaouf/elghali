import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item/cart_item.dart';
import '../models/product/product.dart';

class CartState {
  final List<CartItem> items;
  final double deliveryFee;

  CartState({this.items = const [], this.deliveryFee = 15.0});

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal + deliveryFee;
  double get totalAmount => total;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  CartState copyWith({List<CartItem>? items, double? deliveryFee}) {
    return CartState(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }
}

class CartViewModel extends Notifier<CartState> {
  @override
  CartState build() {
    return CartState();
  }

  void addItem(Product product, int quantity, ProductSize? size) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == size,
    );

    if (existingIndex >= 0) {
      final existingItem = state.items[existingIndex];
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      final newItem = CartItem(
        id: const Uuid().v4(),
        product: product,
        quantity: quantity,
        selectedSize: size,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void updateQuantity(String id, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(id);
      return;
    }
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList(),
    );
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
    );
  }

  void clear() {
    state = state.copyWith(items: []);
  }

  void clearCart() => clear();
}

final cartProvider = NotifierProvider<CartViewModel, CartState>(() {
  return CartViewModel();
});
