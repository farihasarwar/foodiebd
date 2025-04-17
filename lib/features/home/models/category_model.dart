class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final String? description;
  final bool isActive;
  final int order;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    this.isActive = true,
    required this.order,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 