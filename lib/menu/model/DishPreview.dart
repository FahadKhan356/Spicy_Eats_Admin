class DishPreview {
  final int id;
  final String dihsName;
  final String dishImageUrl;
  final double dishPrice;
  final String categoryId;
  final bool isAvailable;

  const DishPreview({
    required this.id,
    required this.dihsName,
    required this.dishImageUrl,
    required this.dishPrice,
    required this.categoryId,
    required this.isAvailable,
  });

  factory DishPreview.fromJson(Map<String, dynamic> json) {
    return DishPreview(
      id: (json['id'] as num?)?.toInt() ?? 0,
      dihsName: json['dish_name'] ?? '',
      dishImageUrl: json['dish_imageurl'] ?? '',
      dishPrice: (json['dish_price'] as num?)?.toDouble() ?? 0,
      categoryId: json['category_id'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}