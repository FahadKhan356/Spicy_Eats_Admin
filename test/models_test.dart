import 'package:flutter_test/flutter_test.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
import 'package:spicy_eats_admin/menu/model/DishModel.dart';
import 'package:spicy_eats_admin/menu/model/RestaurantModel.dart';
import 'package:spicy_eats_admin/utils/json_coercion.dart';

void main() {
  group('RestaurantModel', () {
    test('parses the real StreetGrill row', () {
      final model = RestaurantModel.fromJson({
        'restaurantName': 'StreetGrill',
        'deliveryFee': 5.6,
        'minTime': 25,
        'maxTime': 50,
        'average_ratings': 4.0,
        'address': 'kuch bhi',
        'phoneNumber': 331324,
        'deliveryArea': 'Qasimabad',
        'rest_uid': '8cd1f2dc-1b9f-447e-ae3e-84197d841b90',
        'lat': 24.88,
        'long': 67.06,
        'businessEmail': 'StreetGrill@gmail.com',
        'cuisineIds': [2, 3, 4, 10],
        'platformfee': 5.3,
      });
      expect(model.restuid, '8cd1f2dc-1b9f-447e-ae3e-84197d841b90');
      expect(model.restaurantName, 'StreetGrill');
      expect(model.cuisineIds, [2, 3, 4, 10]);
    });

    test('survives every nullable column being null', () {
      final model = RestaurantModel.fromJson({'rest_uid': 'abc'});
      expect(model.restuid, 'abc');
      expect(model.deliveryArea, '');
      expect(model.phoneNumber, isNull);
      expect(model.openingHours, isEmpty);
    });

    test('survives phoneNumber as text after the type migration', () {
      final model = RestaurantModel.fromJson({
        'phoneNumber': '03001234567',
        'rest_uid': 'abc',
      });
      expect(model.phoneNumber, 3001234567);
    });

    test('survives numeric columns arriving as int', () {
      final model = RestaurantModel.fromJson({
        'deliveryFee': 6,
        'minTime': 20,
        'cuisineIds': <dynamic>[2, 3],
      });
      expect(model.deliveryFee, 6.0);
      expect(model.minTime, 20);
    });

    test('survives a nested openingHours object', () {
      final model = RestaurantModel.fromJson({
        'openingHours': {
          'Friday': {
            'status': false,
            'closing_time': {'mins': 0, 'hours': 0},
            'opening_period': 'AM',
          },
        },
      });
      expect(model.openingHours!.containsKey('Friday'), isTrue);
    });
  });

  group('CategoryItemModel', () {
    test('parses a dish with fractional prices', () {
      final item = CategoryItemModel.fromJson({
        'id': 25,
        'dish_name': 'Smoky BBQ Bacon Burger',
        'dish_price': 5.65,
        'dish_discount': 5.1,
        'isAvailable': true,
        'isVeg': false,
      });
      expect(item.id, 25);
      expect(item.dish_price, 5.65);
      expect(item.isAvailable, isTrue);
    });

    test('parses whole-number prices arriving as int', () {
      final item = CategoryItemModel.fromJson({
        'id': 54,
        'dish_name': 'Loaded Nachos',
        'dish_price': 18,
        'dish_discount': 15,
        'isAvailable': 1,
        'isVeg': 0,
      });
      expect(item.dish_price, 18.0);
      expect(item.dish_discount, 15.0);
      expect(item.isAvailable, isTrue);
      expect(item.isVeg, isFalse);
    });

    test('never returns null strings, so the UI cannot null-assert', () {
      final item = CategoryItemModel.fromJson({'id': 1});
      expect(item.dish_name, isNotNull);
      expect(item.dish_imageurl, isNotNull);
      expect(item.category_id, isNotNull);
    });
  });

  group('CategoryModel', () {
    test('parses a normal category', () {
      final category = CategoryModel.fromJson({
        'category_id': 'a9041768-4457-4704-b332-bedcb9540f62',
        'created_at': '2025-09-14T09:45:50.881863+00:00',
        'category_name': 'Burgers & Sandwiches',
        'rest_uid': '8cd1f2dc-1b9f-447e-ae3e-84197d841b90',
      });
      expect(category.categoryName, 'Burgers & Sandwiches');
      expect(category.createdAt.year, 2025);
    });

    test('survives a null created_at instead of FormatException', () {
      final category = CategoryModel.fromJson({'category_id': 'x'});
      expect(category.categoryId, 'x');
    });
  });

  group('DishModel', () {
    test('parses both int and double prices', () {
      expect(DishModel.fromJson({'id': 1, 'dish_price': 4}).dish_price, 4.0);
      expect(
          DishModel.fromJson({'id': 1, 'dish_price': 4.45}).dish_price, 4.45);
      expect(DishModel.fromJson({'id': 1}).dish_name, '');
    });
  });

  group('coercion helpers', () {
    test('asStringOrNull turns empty into null', () {
      expect(asStringOrNull(''), isNull);
      expect(asStringOrNull('a'), 'a');
      expect(asStringOrNull(12), '12');
    });

    test('asDoubleOrNull rejects garbage', () {
      expect(asDoubleOrNull('abc'), isNull);
      expect(asDoubleOrNull('3.5'), 3.5);
    });

    test('asBool understands postgres booleans and strings', () {
      expect(asBool(true), isTrue);
      expect(asBool('t'), isTrue);
      expect(asBool('false'), isFalse);
      expect(asBool(0), isFalse);
      expect(asBool(null), isFalse);
      expect(asBool(null, fallback: true), isTrue);
    });

    test('asDateTime never throws on bad input', () {
      expect(asDateTimeOrNull('nope'), isNull);
      expect(asDateTime('nope').year, greaterThan(2000));
    });
  });
}
