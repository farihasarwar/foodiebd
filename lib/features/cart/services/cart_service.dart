import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodiebd/core/constants/firebase_constants.dart';
import 'package:foodiebd/shared/models/food_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get cart items for current user
  Stream<List<CartItem>> getCartItems() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection(FirebaseConstants.cartCollection)
        .doc(user.uid)
        .collection('items')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CartItem.fromJson(doc.data())).toList();
    });
  }

  // Add item to cart
  Future<void> addToCart(FoodModel food, int quantity) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final cartItem = CartItem(
      foodId: food.id,
      foodName: food.name,
      price: food.discountedPrice ?? food.price,
      quantity: quantity,
      total: (food.discountedPrice ?? food.price) * quantity,
      imageUrl: food.imageUrl,
    );

    await _firestore
        .collection(FirebaseConstants.cartCollection)
        .doc(user.uid)
        .collection('items')
        .doc(food.id)
        .set(cartItem.toJson());
  }

  // Update cart item quantity
  Future<void> updateQuantity(String foodId, int quantity) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final docRef = _firestore
        .collection(FirebaseConstants.cartCollection)
        .doc(user.uid)
        .collection('items')
        .doc(foodId);

    final doc = await docRef.get();
    if (!doc.exists) throw Exception('Item not found in cart');

    final cartItem = CartItem.fromJson(doc.data()!);
    final updatedItem = cartItem.copyWith(
      quantity: quantity,
      total: cartItem.price * quantity,
    );

    await docRef.update(updatedItem.toJson());
  }

  // Remove item from cart
  Future<void> removeFromCart(String foodId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore
        .collection(FirebaseConstants.cartCollection)
        .doc(user.uid)
        .collection('items')
        .doc(foodId)
        .delete();
  }

  // Clear cart
  Future<void> clearCart() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final cartRef = _firestore
        .collection(FirebaseConstants.cartCollection)
        .doc(user.uid)
        .collection('items');

    final cartItems = await cartRef.get();
    final batch = _firestore.batch();

    for (var doc in cartItems.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}

class CartItem {
  final String foodId;
  final String foodName;
  final double price;
  final int quantity;
  final double total;
  final String imageUrl;

  CartItem({
    required this.foodId,
    required this.foodName,
    required this.price,
    required this.quantity,
    required this.total,
    required this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      foodId: json['foodId'] as String,
      foodName: json['foodName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      total: (json['total'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'price': price,
      'quantity': quantity,
      'total': total,
      'imageUrl': imageUrl,
    };
  }

  CartItem copyWith({
    String? foodId,
    String? foodName,
    double? price,
    int? quantity,
    double? total,
    String? imageUrl,
  }) {
    return CartItem(
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
} 