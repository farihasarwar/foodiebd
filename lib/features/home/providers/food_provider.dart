import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/core/constants/firebase_constants.dart';
import 'package:foodiebd/shared/models/food_model.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all foods
  Stream<List<FoodModel>> getFoods() {
    return _firestore
        .collection(FirebaseConstants.foodsCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => FoodModel.fromJson(doc.data())).toList();
    });
  }

  // Get all categories
  Stream<List<String>> getCategories() {
    return _firestore
        .collection(FirebaseConstants.categoriesCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  // Add food
  Future<void> addFood(FoodModel food) async {
    await _firestore
        .collection(FirebaseConstants.foodsCollection)
        .doc(food.id)
        .set(food.toJson());
  }

  // Update food
  Future<void> updateFood(FoodModel food) async {
    await _firestore
        .collection(FirebaseConstants.foodsCollection)
        .doc(food.id)
        .update(food.toJson());
  }

  // Delete food
  Future<void> deleteFood(String id) async {
    await _firestore.collection(FirebaseConstants.foodsCollection).doc(id).delete();
  }

  // Add category
  Future<void> addCategory(String category) async {
    await _firestore
        .collection(FirebaseConstants.categoriesCollection)
        .doc(category.toLowerCase())
        .set({'name': category});
  }

  // Delete category
  Future<void> deleteCategory(String category) async {
    await _firestore
        .collection(FirebaseConstants.categoriesCollection)
        .doc(category.toLowerCase())
        .delete();
  }
}

final foodServiceProvider = Provider<FoodService>((ref) => FoodService());

final foodsProvider = StreamProvider<List<FoodModel>>((ref) {
  return ref.watch(foodServiceProvider).getFoods();
});

final categoriesProvider = StreamProvider<List<String>>((ref) {
  return ref.watch(foodServiceProvider).getCategories();
}); 