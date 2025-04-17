import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/features/home/models/banner_model.dart';
import 'package:foodiebd/features/home/models/category_model.dart';
import 'package:foodiebd/features/home/models/combo_deal_model.dart';

// Dummy data providers (will be replaced with Firebase data later)
final bannersProvider = Provider<List<BannerModel>>((ref) {
  return [
    BannerModel(
      id: '1',
      imageUrl: 'https://picsum.photos/800/400?random=1',
      title: '50% Off on First Order',
      description: 'Use code WELCOME50',
      isActive: true,
      createdAt: DateTime.now(),
    ),
    BannerModel(
      id: '2',
      imageUrl: 'https://picsum.photos/800/400?random=2',
      title: 'Free Delivery',
      description: 'On orders above \$20',
      isActive: true,
      createdAt: DateTime.now(),
    ),
    BannerModel(
      id: '3',
      imageUrl: 'https://picsum.photos/800/400?random=3',
      title: 'Special Weekend Offer',
      description: '20% off on all items',
      isActive: true,
      createdAt: DateTime.now(),
    ),
  ];
});

final comboDealsProvider = Provider<List<ComboDealModel>>((ref) {
  return [
    ComboDealModel(
      id: '1',
      name: 'Family Feast',
      description: '2 Large Pizzas + 4 Drinks + 2 Sides',
      imageUrl: 'https://picsum.photos/400/300?random=1',
      originalPrice: 49.99,
      discountedPrice: 39.99,
      items: ['Pizza', 'Drinks', 'Sides'],
      validUntil: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    ),
    ComboDealModel(
      id: '2',
      name: 'Burger Combo',
      description: '2 Burgers + Fries + 2 Drinks',
      imageUrl: 'https://picsum.photos/400/300?random=2',
      originalPrice: 29.99,
      discountedPrice: 24.99,
      items: ['Burger', 'Fries', 'Drinks'],
      validUntil: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    ),
    ComboDealModel(
      id: '3',
      name: 'Party Pack',
      description: '3 Large Pizzas + 6 Drinks + 3 Sides',
      imageUrl: 'https://picsum.photos/400/300?random=3',
      originalPrice: 69.99,
      discountedPrice: 54.99,
      items: ['Pizza', 'Drinks', 'Sides'],
      validUntil: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    ),
  ];
});

final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  return [
    CategoryModel(
      id: '1',
      name: 'All',
      imageUrl: 'https://picsum.photos/200/200?random=1',
      order: 0,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: '2',
      name: 'Burger',
      imageUrl: 'https://picsum.photos/200/200?random=2',
      order: 1,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: '3',
      name: 'Pizza',
      imageUrl: 'https://picsum.photos/200/200?random=3',
      order: 2,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: '4',
      name: 'Nachos',
      imageUrl: 'https://picsum.photos/200/200?random=4',
      order: 3,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: '5',
      name: 'Drinks',
      imageUrl: 'https://picsum.photos/200/200?random=5',
      order: 4,
      createdAt: DateTime.now(),
    ),
  ];
});

// Selected category provider
final selectedCategoryProvider = StateProvider<String>((ref) => 'All'); 