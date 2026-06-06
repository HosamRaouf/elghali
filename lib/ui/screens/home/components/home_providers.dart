import 'package:flutter_riverpod/flutter_riverpod.dart';

class _ActiveCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void update(String category) => state = category;
}

final activeCategoryProvider =
    NotifierProvider<_ActiveCategoryNotifier, String>(
      _ActiveCategoryNotifier.new,
    );

class _OrderTypeNotifier extends Notifier<String> {
  @override
  String build() => 'delivery';

  void update(String type) => state = type;
}

final orderTypeProvider = NotifierProvider<_OrderTypeNotifier, String>(
  _OrderTypeNotifier.new,
);

class _ScrollOffsetNotifier extends Notifier<double> {
  @override
  double build() => 0;

  void update(double offset) => state = offset;
}

final scrollOffsetProvider = NotifierProvider<_ScrollOffsetNotifier, double>(
  _ScrollOffsetNotifier.new,
);

class _HoverStateNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setHover(bool value) => state = value;
}

final hoverStateProvider = NotifierProvider.family
    .autoDispose<_HoverStateNotifier, bool, String>(
      (String id) => _HoverStateNotifier(),
    );
