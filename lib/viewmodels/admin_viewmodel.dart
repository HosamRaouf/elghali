import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/coffee_data.dart';
import '../models/cart_item/cart_item.dart';
import '../models/category/category.dart';
import '../models/category/category_data.dart';
import '../models/order/order.dart';
import '../models/product/product.dart';
import '../models/user/user.dart';

class AdminState {
  final List<Product> products;
  final List<Category> categories;
  final List<Order> orders;
  final List<User> users;

  const AdminState({
    required this.products,
    required this.categories,
    required this.orders,
    required this.users,
  });

  int get totalOrders => orders.length;
  int get pendingOrders => orders.where((o) => o.status == OrderStatus.pending).length;
  int get processingOrders => orders.where((o) => o.status == OrderStatus.processing).length;
  int get completedOrders => orders.where((o) => o.status == OrderStatus.completed).length;
  int get cancelledOrders => orders.where((o) => o.status == OrderStatus.cancelled).length;
  double get totalRevenue => orders.where((o) => o.status == OrderStatus.completed).fold(0.0, (sum, o) => sum + o.totalAmount);
  int get totalProducts => products.length;
  int get totalUsers => users.length;

  List<Order> get liveOrders {
    final list = orders.where((o) => o.status.isLive).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}

class AdminViewModel extends Notifier<AdminState> {
  int _nextId = 100;

  @override
  AdminState build() {
    _nextId = products.length + categories.length + 100;
    return AdminState(
      products: List.from(products),
      categories: List.from(categories),
      orders: _mockOrders,
      users: _mockUsers,
    );
  }

  List<Order> get _mockOrders => [
    Order(
      id: "ORD-7742",
      items: [
        CartItem(id: "ci1", product: products[0], quantity: 2, selectedSize: products[0].sizes![0]),
        CartItem(id: "ci2", product: products[3], quantity: 1, selectedSize: products[3].sizes![1]),
      ],
      totalAmount: 48.0,
      status: OrderStatus.processing,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      location: "المنصورة، المشاية السفلية، برج الصفوة",
      phone: "+201012345678",
      paymentMethod: "نقداً عند الاستلام",
    ),
    Order(
      id: "ORD-7741",
      items: [
        CartItem(id: "ci3", product: products[5], quantity: 3, selectedSize: products[5].sizes![0]),
      ],
      totalAmount: 66.0,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      location: "المنصورة، حي الجامعة، أمام بوابة توشكى",
      phone: "+201012345678",
      paymentMethod: "بطاقة ائتمان",
    ),
    Order(
      id: "ORD-7735",
      items: [
        CartItem(id: "ci4", product: products[2], quantity: 1, selectedSize: products[2].sizes![2]),
      ],
      totalAmount: 16.0,
      status: OrderStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      location: "المنصورة، شارع جيهان، عمارة الفتح",
      phone: "+201012345678",
      paymentMethod: "محفظة إلكترونية",
    ),
    Order(
      id: "ORD-7730",
      items: [
        CartItem(id: "ci5", product: products[4], quantity: 4, selectedSize: products[4].sizes![0]),
      ],
      totalAmount: 88.0,
      status: OrderStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      location: "المنصورة، توريل، شارع المختلط",
      phone: "+201012345678",
      paymentMethod: "نقداً عند الاستلام",
    ),
    Order(
      id: "ORD-7720",
      items: [
        CartItem(id: "ci6", product: products[1], quantity: 1, selectedSize: products[1].sizes![1]),
        CartItem(id: "ci7", product: products[6], quantity: 2, selectedSize: products[6].sizes![0]),
      ],
      totalAmount: 82.0,
      status: OrderStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      location: "المنصورة، شارع الجيش، عمارة النور",
      phone: "+201098765432",
      paymentMethod: "بطاقة ائتمان",
    ),
    Order(
      id: "ORD-7715",
      items: [
        CartItem(id: "ci8", product: products[8], quantity: 1, selectedSize: null),
      ],
      totalAmount: 28.0,
      status: OrderStatus.cancelled,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      location: "المنصورة، شارع سعد زغلول",
      phone: "+201055555555",
      paymentMethod: "محفظة إلكترونية",
    ),
    Order(
      id: "ORD-7743",
      items: [
        CartItem(id: "ci9", product: products[7], quantity: 2, selectedSize: products[7].sizes![1]),
        CartItem(id: "ci10", product: products[0], quantity: 1, selectedSize: products[0].sizes![0]),
      ],
      totalAmount: 73.0,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      location: "المنصورة، حي الجامعة، بجوار مسجد الرحمن",
      phone: "+201011111111",
      paymentMethod: "نقداً عند الاستلام",
    ),
    Order(
      id: "ORD-7744",
      items: [
        CartItem(id: "ci11", product: products[3], quantity: 1, selectedSize: products[3].sizes![0]),
      ],
      totalAmount: 18.0,
      status: OrderStatus.processing,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      location: "المنصورة، المشاية الجديدة",
      phone: "+201022222222",
      paymentMethod: "بطاقة ائتمان",
    ),
  ];

  List<User> get _mockUsers => [
    const User(id: "u1", name: "حسام عبدالرؤوف", phone: "+201012345678", points: 1250),
    const User(id: "u2", name: "أحمد علي", phone: "+201098765432", points: 780),
    const User(id: "u3", name: "سارة محمد", phone: "+201055555555", points: 2100),
    const User(id: "u4", name: "محمد حسن", phone: "+201044444444", points: 450),
    const User(id: "u5", name: "فاطمة الزهراء", phone: "+201033333333", points: 3200),
    const User(id: "u6", name: "خالد عبدالله", phone: "+201066666666", points: 150),
  ];

  void addProduct(Product product) {
    state = AdminState(
      products: [...state.products, product],
      categories: state.categories,
      orders: state.orders,
      users: state.users,
    );
  }

  void updateProduct(int index, Product product) {
    final updated = List<Product>.from(state.products);
    updated[index] = product;
    state = AdminState(
      products: updated,
      categories: state.categories,
      orders: state.orders,
      users: state.users,
    );
  }

  void deleteProduct(int index) {
    final updated = List<Product>.from(state.products);
    updated.removeAt(index);
    state = AdminState(
      products: updated,
      categories: state.categories,
      orders: state.orders,
      users: state.users,
    );
  }

  void addCategory(Category category) {
    state = AdminState(
      products: state.products,
      categories: [...state.categories, category],
      orders: state.orders,
      users: state.users,
    );
  }

  void deleteCategory(int index) {
    final updated = List<Category>.from(state.categories);
    updated.removeAt(index);
    state = AdminState(
      products: state.products,
      categories: updated,
      orders: state.orders,
      users: state.users,
    );
  }

  void updateOrderStatus(int index, OrderStatus newStatus) {
    final updated = List<Order>.from(state.orders);
    final old = updated[index];
    updated[index] = Order(
      id: old.id,
      items: old.items,
      totalAmount: old.totalAmount,
      status: newStatus,
      createdAt: old.createdAt,
      location: old.location,
      phone: old.phone,
      paymentMethod: old.paymentMethod,
    );
    state = AdminState(
      products: state.products,
      categories: state.categories,
      orders: updated,
      users: state.users,
    );
  }

  void updateUserPoints(int index, int points) {
    final updated = List<User>.from(state.users);
    final old = updated[index];
    updated[index] = User(id: old.id, name: old.name, phone: old.phone, points: points);
    state = AdminState(
      products: state.products,
      categories: state.categories,
      orders: state.orders,
      users: updated,
    );
  }

  String generateId() => "p-${_nextId++}";
}

final adminProvider = NotifierProvider<AdminViewModel, AdminState>(() {
  return AdminViewModel();
});
