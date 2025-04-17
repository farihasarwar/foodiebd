class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String? description;
  final String? link;
  final bool isActive;
  final DateTime createdAt;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.description,
    this.link,
    this.isActive = true,
    required this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      link: json['link'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'link': link,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 