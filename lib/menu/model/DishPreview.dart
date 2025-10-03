class DishPreview {
  final int id;
  final String dihsName;
  final String dishImageUrl;
  final double dishPrice;
  final String categoryId;
  
  const DishPreview({
    required this.id,
    required this.dihsName,
    required this.dishImageUrl,
    required this.dishPrice,
    required this.categoryId,
  });

  factory DishPreview.fromJson(Map<String, dynamic> json) {
    return DishPreview(
      id: json['id'],
      dihsName: json['dish_name'] ?? '',
      dishImageUrl: json['dish_imageurl']?? '',
      dishPrice: (json['dish_price'] as num ).toDouble() ,
      categoryId: json['category_id'] ?? '',
    );
  }
}