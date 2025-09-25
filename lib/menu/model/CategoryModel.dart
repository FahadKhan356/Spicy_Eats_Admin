
class CategoryModel {

  final String categoryId;
  final DateTime createdAt;
  final String categoryName;
  final String restUid;
  final String categoryDescription;

  CategoryModel({
    required this.categoryId,
    required this.createdAt,
    required this.categoryName,
    required this.restUid,
    required this.categoryDescription,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      categoryName: json['category_name'] ?? '',
      restUid: json['rest_uid'] ?? '',
      categoryDescription: json['category_description'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      // Convert the DateTime object back to an ISO 8601 string for database storage.
      'created_at': createdAt.toIso8601String(),
      'category_name': categoryName,
      'rest_uid': restUid,
      'category_description': categoryDescription,
    };
  }
}
