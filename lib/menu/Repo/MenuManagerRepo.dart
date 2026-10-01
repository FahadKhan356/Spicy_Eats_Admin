import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
import 'package:spicy_eats_admin/menu/model/DishModel.dart';
import 'package:spicy_eats_admin/menu/model/DishPreview.dart';
import 'package:spicy_eats_admin/menu/model/RestaurantModel.dart';
import 'package:spicy_eats_admin/utils/UploadImageToSupabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final menuManagerRepoProvider = Provider((ref) => MenuManagerRepo(ref: ref));
final restaurantProvider = StateProvider<RestaurantModel?>((ref) => null);
final restaurantErrorProvider = StateProvider<String?>((ref) => null);
final restaurantLoadingProvider = StateProvider<bool>((ref) => true);
final loadingProvider = StateProvider((ref) => false);

class MenuManagerRepo {
  MenuManagerRepo({required this.ref});
  Ref ref;

  Future<void> fetchRestaurantData() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return;

    // Same guard as `fetchCategories`: provider writes must never happen in
    // the same synchronous frame as a widget build.
    await Future<void>.delayed(Duration.zero);

    ref.read(restaurantErrorProvider.notifier).state = null;
    ref.read(restaurantLoadingProvider.notifier).state = true;

    try {
      final response = await supabaseClient
          .from('restaurants')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        ref.read(restaurantErrorProvider.notifier).state =
            'No restaurant is linked to this account yet. Finish registration '
            'or ask an admin to link it.';
        return;
      }

      final data = RestaurantModel.fromJson(response);
      if (data.restuid == null || data.restuid!.isEmpty) {
        ref.read(restaurantErrorProvider.notifier).state =
            'This restaurant record has no rest_uid, so its menu cannot load.';
        return;
      }

      ref.read(restaurantProvider.notifier).state = data;
      debugPrint('Restaurant fetched: ${data.restaurantName}');
    } catch (e) {
      debugPrint('Failed to fetch restaurant data: $e');
      ref.read(restaurantErrorProvider.notifier).state = '$e';
    } finally {
      ref.read(restaurantLoadingProvider.notifier).state = false;
    }
  }

  Future<List<CategoryModel>?> fetchCategories({required restId}) async {
    // Yield once before touching any provider. Callers may run this from
    // `initState`/`build`, and Riverpod throws "Tried to modify a provider
    // while the widget tree was building" for synchronous updates.
    await Future<void>.delayed(Duration.zero);
    ref.read(loadingProvider.notifier).state = true;
    try {
      final response = await supabaseClient
          .from('categories')
          .select('*')
          .eq('rest_uid', restId)
          .order('created_at', ascending: true);
      if (response.isNotEmpty) {
        final data = response.map((e) => CategoryModel.fromJson(e)).toList();
        return data;
      }
    } on PostgrestException catch (e) {
      debugPrint('Supabase Error: Failed to fetch categories: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected Error: Failed to fetch categories: $e');
      rethrow;
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
    return null;
  }

  Future<List<CategoryItemModel>?> fetchCategoryitems(
      {required String categoryId}) async {
    try {
      final response = await supabaseClient
          .from('dishes')
          .select('*')
          .eq('category_id', categoryId)
          .order('created_at', ascending: true);
      if (response.isNotEmpty) {
        final data =
            response.map((e) => CategoryItemModel.fromJson(e)).toList();
        debugPrint('Restaurant fetched: ${data.length}');

        return data;
      }
    } on PostgrestException catch (e) {
      debugPrint(
          'Supabase Erorr: failed to fetch category items: ${e.message}');
    } catch (e) {
      debugPrint('Supabase Erorr: failed to fetch category items: $e');
    }

    return null;
  }

  Future<void> setInOutStock(
      {required bool isAvailble, required dishId, required context}) async {
    try {
      final response = await supabaseClient
          .from('dishes')
          .update({'isAvailable': isAvailble}).eq('id', dishId);
      if (response != null) {
        showCustomSnackbar(context: context, message: 'Stock Updated');
      }
      debugPrint('stack updated for dish to $isAvailble  for id $dishId');
    } catch (e) {
      debugPrint('Failed to update stock status: $e');
    }
  }

//show real time menu screen stats
//Dishes Table Stream Funtion to listen Stream of data

  Stream<List<Map<String, dynamic>>> listenDishStream() {
    return supabaseClient
        .from('dishes')
        .stream(primaryKey: ['id']).order('id'); // must include some ordering
  }

//Real time Available items
  int streamAvailableItems(
      {required List<Map<String, dynamic>> snapshot, required String restUid}) {
    final res = snapshot
        .where((item) =>
            item['rest_uid'] == restUid && item['isAvailable'] == true)
        .toList();

    if (res.isNotEmpty) {
      return res.length;
    }
    return 0;
  }

//Real time total items

  int streamTotalItems(
      {required List<Map<String, dynamic>> snapshot, required String restUid}) {
    final res = snapshot.where((item) => item['rest_uid'] == restUid);
    if (res.isNotEmpty) {
      return res.length;
    }
    return 0;
  }

  double toalAvgPrice({required List<Map<String, dynamic>> snapshot}) {
    final dishes = snapshot;
    double avgPrice = 0;

    if (dishes.isNotEmpty) {
      final totalPrice = dishes.fold<double>(0, (sum, dish) {
        return sum + (dish['dish_price'] as num).toDouble();
      });
      avgPrice = totalPrice / dishes.length;
      print("Average Price: $avgPrice");
      return avgPrice;
    } else {
      print("No items available");
    }
    return 0;
  }

  Future<void> addDish(
      {required context,
      required String restUid,
      required String dishName,
      required String dishDisc,
      required String dishPrice,
      required String dishDisPrice,
      required Uint8List dishImage,
      required CategoryModel category,
      required bool isVeg,
      List<Map<String, dynamic>>? variations,
      }) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final imgUrl = await uploadImageToSupabase(
        dishImage,
        dishImagesBucket,
        path,
      );

      final inserted = await supabaseClient.from('dishes').insert({
        'rest_uid': restUid,
        'dish_description': dishDisc,
        'dish_price': double.tryParse(dishPrice) ?? 0,
        'dish_imageurl': imgUrl,
        'dish_name': dishName,
        'category_id': category.categoryId,
        'dish_discount': double.tryParse(dishDisPrice) ?? 0,
        'isVeg': isVeg,
        'isAvailable': true,
      }).select('id').single();

      final dishId = (inserted['id'] as num).toInt();

      await saveVariations(
        dishId: dishId,
        variations: variations ?? const [],
      );

      ref.read(dishesPreviewList.notifier).state = [
        ...ref.read(dishesPreviewList),
      ];

      showCustomSnackbar(
          context: context,
          message: 'Dish Added Successfully',
          backgroundColor: Colors.black);
    } on PostgrestException catch (e) {
      showCustomSnackbar(
          context: context,
          message: 'Could not save dish: ${e.message}',
          backgroundColor: Colors.red);
      rethrow;
    } catch (e) {
      showCustomSnackbar(
          context: context, message: 'Failed to upload: $e',
          backgroundColor: Colors.red);
      rethrow;
    }
  }

  Future<void> saveVariations({
    required int dishId,
    required List<Map<String, dynamic>> variations,
  }) async {
    if (variations.isEmpty) return;

    for (final variation in variations) {
      final res = await supabaseClient.from('titleVariations').insert({
        'title': variation['title'],
        'isRequired': variation['required'] ?? false,
        'subtitle': variation['subtitleMaxSelect'],
        'maxSeleted': int.tryParse('${variation['maxSelect']}') ?? 1,
        'dishid': dishId,
      }).select('id').single();

      final variationId = (res['id'] as num).toInt();
      final options = (variation['options'] as List? ?? const [])
          .whereType<Map>()
          .map((opt) => {
                'variation_id': variationId,
                'variation_name': opt['name'],
                'variation_price': opt['price'] ?? 0,
              })
          .toList();

      if (options.isNotEmpty) {
        await supabaseClient.from('variations').insert(options);
      }
    }
  }

  Future<void> updateDish({
    required context,
    required int dishId,
    required String dishName,
    required String dishDisc,
    required String dishPrice,
    required String dishDisPrice,
    required CategoryModel category,
    required bool isVeg,
    Uint8List? dishImage,
  }) async {
    try {
      final payload = <String, dynamic>{
        'dish_name': dishName,
        'dish_description': dishDisc,
        'dish_price': double.tryParse(dishPrice) ?? 0,
        'dish_discount': double.tryParse(dishDisPrice) ?? 0,
        'category_id': category.categoryId,
        'isVeg': isVeg,
      };

      if (dishImage != null) {
        final userId = supabaseClient.auth.currentUser!.id;
        final imgUrl = await uploadImageToSupabase(
          dishImage,
          dishImagesBucket,
          '$userId/$dishId-${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        payload['dish_imageurl'] = imgUrl;
      }

      await supabaseClient
          .from('dishes')
          .update(payload)
          .eq('id', dishId);

      showCustomSnackbar(
          context: context,
          message: 'Dish Updated',
          backgroundColor: Colors.black);
    } catch (e) {
      showCustomSnackbar(
          context: context, message: 'Failed to update dish: $e',
          backgroundColor: Colors.red);
      rethrow;
    }
  }

Future<bool> deleteDish({required int dishId}) async {
  try {
    final res = await supabaseClient
        .from('dishes')
        .delete()
        .eq('id', dishId)
        .select();
    return res.isNotEmpty;
  } catch (e) {
    debugPrint('Error: Failed To Delete Dish $e');
    return false;
  }
}
  

//Load preload dishes for search and others use
Future<void> preLoadDishes({required context}) async {
  final restUid = ref.read(restaurantProvider)?.restuid;
  if (restUid == null || restUid.isEmpty) {
    ref.read(dishesPreviewList.notifier).state = [];
    return;
  }

  try {
    final res = await supabaseClient
        .from('dishes')
        .select(
            'id, dish_name, dish_price, dish_imageurl, category_id, isAvailable')
        .eq('rest_uid', restUid);

    ref.read(dishesPreviewList.notifier).state =
        res.map<DishPreview>((e) => DishPreview.fromJson(e)).toList();
  } catch (e) {
    debugPrint('preLoadDishes failed: $e');
    if (context.mounted) {
      showCustomSnackbar(
          context: context,
          message: 'Error: Failed to load dishes',
          backgroundColor: Colors.black);
    }
  }
}

//for searching dish
List<DishPreview> searchDishes({required String? query, String? filter}) {
  final term = (query ?? '').trim().toLowerCase();
  final dishes = ref.watch(dishesPreviewList);

  return dishes.where((dish) {
    final matchesTerm =
        term.isEmpty || dish.dihsName.toLowerCase().contains(term);
    final matchesFilter = switch (filter) {
      'Available' => dish.isAvailable,
      'Unavailable' => !dish.isAvailable,
      _ => true,
    };
    return matchesTerm && matchesFilter;
  }).toList();
}

Future<DishModel> getSearchedDish({required int dishId})async{


if(cachedDishPreview.containsKey(dishId)){
   return cachedDishPreview[dishId]!;

}

final dish = await supabaseClient.from('dishes').select('*').eq('id', dishId).single().then(DishModel.fromJson);
cachedDishPreview[dishId]=dish;

return dish;
}




}
 Map<int,DishModel> cachedDishPreview={};

final dishesPreviewList=StateProvider<List<DishPreview>>((ref)=>[]);
final seacrhedDishesProvider=StateProvider<List<DishPreview>>((ref)=>[]);