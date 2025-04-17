class ComboDealModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final List<String> items;
  final bool isActive;
  final DateTime validUntil;
  final DateTime createdAt;

  ComboDealModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.items,
    this.isActive = true,
    required this.validUntil,
    required this.createdAt,
  });

  factory ComboDealModel.fromJson(Map<String, dynamic> json) {
    return ComboDealModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
      isActive: json['isActive'] as bool? ?? true,
      validUntil: DateTime.parse(json['validUntil'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'items': items,
      'isActive': isActive,
      'validUntil': validUntil.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  double get discountPercentage =>
      ((originalPrice - discountedPrice) / originalPrice * 100).roundToDouble();
} 