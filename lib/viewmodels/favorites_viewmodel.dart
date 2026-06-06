import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesViewModel extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {};
  }

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state}..add(productId);
    }
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}

final favoritesProvider = NotifierProvider<FavoritesViewModel, Set<String>>(() {
  return FavoritesViewModel();
});
