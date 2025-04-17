import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodiebd/core/constants/firebase_constants.dart';
import 'package:foodiebd/features/cart/services/cart_service.dart';
import 'package:foodiebd/shared/models/order_model.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CartService _cartService;

  OrderService(this._cartService);

  // Get orders for current user
  Stream<List<OrderModel>> getOrders() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    try {
      return _firestore
          .collection(FirebaseConstants.ordersCollection)
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
      });
    } catch (e) {
      // Return empty list if index is not created yet
      return Stream.value([]);
    }
  }

  // Get all orders (for admin)
  Stream<List<OrderModel>> getAllOrders() {
    try {
      return _firestore
          .collection(FirebaseConstants.ordersCollection)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
      });
    } catch (e) {
      // Return empty list if index is not created yet
      return Stream.value([]);
    }
  }

  // Get orders by status (for admin)
  Stream<List<OrderModel>> getOrdersByStatus(String status) {
    try {
      return _firestore
          .collection(FirebaseConstants.ordersCollection)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
      });
    } catch (e) {
      // Return empty list if index is not created yet
      return Stream.value([]);
    }
  }

  // Create a new order from cart items
  Future<OrderModel> createOrder({required String deliveryAddress}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Get cart items
    final cartItems = await _cartService.getCartItems().first;
    if (cartItems.isEmpty) throw Exception('Cart is empty');

    // Calculate total
    final total = cartItems.fold(0.0, (sum, item) => sum + item.total);

    // Create order items from cart items
    final orderItems = cartItems.map((item) => OrderItem(
          foodId: item.foodId,
          foodName: item.foodName,
          price: item.price,
          quantity: item.quantity,
          total: item.total,
        )).toList();

    // Create order
    final order = OrderModel(
      id: const Uuid().v4(),
      userId: user.uid,
      items: orderItems,
      total: total,
      status: 'pending',
      deliveryAddress: deliveryAddress,
      createdAt: DateTime.now(),
    );

    // Save order to Firestore
    await _firestore
        .collection(FirebaseConstants.ordersCollection)
        .doc(order.id)
        .set(order.toJson());

    // Clear cart after successful order
    await _cartService.clearCart();

    return order;
  }

  // Update order status (for admin)
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore
        .collection(FirebaseConstants.ordersCollection)
        .doc(orderId)
        .update({'status': status});
  }
} 