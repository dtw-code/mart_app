class Category {
  const Category({
    required this.categoryId,
    required this.categoryName,
    this.categoryImageUrl,
  });

  final String categoryId;
  final String categoryName;
  final String? categoryImageUrl;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      categoryImageUrl: json['category_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'category_id': categoryId,
    'category_name': categoryName,
    'category_image_url': categoryImageUrl,
  };

  Category copyWith({
    String? categoryId,
    String? categoryName,
    String? categoryImageUrl,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryImageUrl: categoryImageUrl ?? this.categoryImageUrl,
    );
  }
}
