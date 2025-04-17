class FoodModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double? discountedPrice;
  final String category;
  final bool isAvailable;
  final bool isFeatured;
  final bool isHot;
  final DateTime createdAt;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.discountedPrice,
    required this.category,
    this.isAvailable = true,
    this.isFeatured = false,
    this.isHot = false,
    required this.createdAt,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      discountedPrice: json['discountedPrice'] != null
          ? (json['discountedPrice'] as num).toDouble()
          : null,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isHot: json['isHot'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'discountedPrice': discountedPrice,
      'category': category,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'isHot': isHot,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  FoodModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    double? discountedPrice,
    String? category,
    bool? isAvailable,
    bool? isFeatured,
    bool? isHot,
    DateTime? createdAt,
  }) {
    return FoodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      isHot: isHot ?? this.isHot,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 