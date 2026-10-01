import 'package:spicy_eats_admin/utils/json_coercion.dart';

class DishModel{
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

  DishModel({
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
    };
  }

//fromjson
  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      dishid: asIntOrNull(json['id']),
      dish_name: asString(json['dish_name']),
      dish_price: asDoubleOrNull(json['dish_price']),
      dish_discount: asDoubleOrNull(json['dish_discount']),
      dish_description: asString(json['dish_description']),
      dish_imageurl: asString(json['dish_imageurl']),
      cusine: asString(json['cusine']),
      category_id: asStringOrNull(json['category_id']),
      isVariation: asBool(json['isVariation']),
      restuid: asStringOrNull(json['rest_uid']),
      frequentlyid: asIntOrNull(json['frequentlyid']),
      id: asIntOrNull(json['id']),
      isVeg: asBool(json['isVeg']),
    );
  }
}
