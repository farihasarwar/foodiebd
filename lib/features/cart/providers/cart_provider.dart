import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/features/cart/services/cart_service.dart';
import 'package:foodiebd/shared/models/food_model.dart';

final cartServiceProvider = Provider<CartService>((ref) => CartService());

final cartItemsProvider = StreamProvider<List<CartItem>>((ref) {
  return ref.watch(cartServiceProvider).getCartItems();
});

final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartItemsProvider);
  return cartItems.when(
    data: (items) => items.fold(0, (sum, item) => sum + item.total),
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartItemsProvider);
  return cartItems.when(
    data: (items) => items.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}); 