class CategoryItemModel {
  int? dishid;
  String? dish_name;
  String? dish_description;
  String? dish_imageurl;
  double? dish_price;
  String? dish_schedule_meal;
  String? cusine;
  double? dish_discount;
  String? category_id;
  bool isVariation;
  String? restuid;
  int? frequentlyid;
  int? id;
  bool? isVeg;
  bool isAvailable;

  CategoryItemModel({
    this.dishid,
    this.dish_description,
    this.dish_imageurl,
    this.dish_price,
    this.dish_schedule_meal,
    this.cusine,
    this.dish_name,
    this.dish_discount,
    this.category_id,
    required this.isVariation,
    this.restuid,
    this.id,
    this.frequentlyid,
    this.isVeg,
    required this.isAvailable,
  });

//tojson
  Map<String, dynamic> tojson() {
    return {
      'dishid': dishid,
      'dish_name': dish_name,
      'dish_price': dish_price,
      'dish_discount': dish_discount,
      'dish_description': dish_description,
      'dish_imageurl': dish_imageurl,
      'dish_schedule_meal': dish_schedule_meal,
      'cusine': cusine,
      'category_id': category_id,
      'isVariation': isVariation,
      'rest_uid': restuid,
      'frequentlyid': frequentlyid,
      'id': id,
      'isVeg': isVeg,
      'isAvailable':isAvailable,
    };
  }

//fromjson
  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      dishid: json['id'] ?? 0,
      dish_name: json['dish_name'] ?? '',
      dish_price: json['dish_price'] ?? 0.0,
      dish_discount: json['dish_discount'],
      dish_description: json['dish_description'] ?? '',
      dish_imageurl: json['dish_imageurl'] ?? '',
      dish_schedule_meal: json['dish_schedule_meal'] ?? '',
      cusine: json['cusine'] ?? '',
      category_id: json['category_id'] ?? '',
      isVariation: json['isVariation'] ?? false,
      restuid: json['rest_uid'] ?? '',
      frequentlyid: json['frequentlyid'] ?? 0,
      id: json['id'] ?? 0,
      isVeg: json['isVeg'],
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}