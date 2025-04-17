import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/features/auth/providers/auth_provider.dart';
import 'package:foodiebd/features/cart/providers/cart_provider.dart';
import 'package:foodiebd/features/orders/services/order_service.dart';
import 'package:foodiebd/shared/models/order_model.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  final cartService = ref.watch(cartServiceProvider);
  return OrderService(cartService);
});

// For regular users - shows their orders
final ordersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(orderServiceProvider).getOrders();
});

// For admin - shows all orders
final allOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  
  // Only fetch all orders if user is admin
  if (user?.value?.isAdmin ?? false) {
    return ref.watch(orderServiceProvider).getAllOrders();
  }
  
  // Return empty list for non-admin users
  return Stream.value([]);
});

// For admin - shows orders by status
final ordersByStatusProvider = StreamProvider.family<List<OrderModel>, String>((ref, status) {
  final user = ref.watch(currentUserProvider);
  
  // Only fetch filtered orders if user is admin
  if (user?.value?.isAdmin ?? false) {
    return ref.watch(orderServiceProvider).getOrdersByStatus(status);
  }
  
  // Return empty list for non-admin users
  return Stream.value([]);
});

final orderStatusProvider = Provider<Map<String, String>>((ref) {
  return {
    'pending': 'Pending',
    'confirmed': 'Confirmed',
    'preparing': 'Preparing',
    'on_the_way': 'On the Way',
    'delivered': 'Delivered',
    'cancelled': 'Cancelled',
  };
}); 