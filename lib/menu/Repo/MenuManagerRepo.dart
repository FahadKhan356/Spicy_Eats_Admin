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
final loadingProvider = StateProvider((ref) => false);

class MenuManagerRepo {
  MenuManagerRepo({required this.ref});
  Ref ref;

  Future<void> fetchRestaurantData() async {
    final userId = supabaseClient.auth.currentUser;
    if (userId == null) return;
    try {
      final response = await supabaseClient
          .from('restaurants')
          .select()
          .eq('user_id', userId.id)
          .maybeSingle();

      if (response != null) {
        final data = RestaurantModel.fromJson(response);
        ref.read(restaurantProvider.notifier).state = data;
        debugPrint('Restaurant fetched: ${data.restaurantName}');
      }
    } catch (e) {
      debugPrint('Failed to Fecth Restaurant Data $e');
    }
    return;
  }

  Future<List<CategoryModel>?> fetchCategories({required restId}) async {
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
      String? varTitle,
      required bool isVeg,
      List<Map<String,dynamic>>? variations,
      }) async {
    try {
    // int? variationId;
    int? dishId;
    const bucketName='Dish_Images';
    final userId= supabaseClient.auth.currentUser!.id;
    final path= '/$userId/$bucketName/${DateTime.now().millisecondsSinceEpoch}';


    String? imgUrl = await uploadImageToSupabase(context, dishImage, bucketName, path);
    

    final dish = await supabaseClient.from('dishes').insert({
   'rest_uid': restUid,
   'dish_description': dishDisc,
   'dish_price': dishPrice,
   'dish_imageurl': imgUrl,
   'dish_name': dishName,
   'category_id':category.categoryId,
   'dish_discount': dishDisPrice,
   'frequentlyid': null,
   'isVeg': isVeg,
   'isAvailable':true,


    }).select('id');

    if(dish.isNotEmpty){

      final dishData = dish.first;
     dishId= dishData['id'];
    }
if (variations != null && variations.isNotEmpty) {
  for (int i = 0; i < variations.length; i++) {
    final res = await supabaseClient
        .from('titleVariations')
        .insert({
          'title': variations[i]['title'],
          'isRequired': variations[i]['required'],
          'subtitle': variations[i]['subtitleMaxSelect'],
          'maxSeleted': variations[i]['maxSelect'],
          'dishid': dishId,
        })
        .select('id'); // fetch only the id

    if (res.isNotEmpty) {
      final variationId = res.first['id'];

      // Prepare all options in one go
      final options = (variations[i]['options'] as List)
          .map((opt) => {
                'variation_id': variationId,
                'variation_name': opt['name'],
                'variation_price': opt['price'],
              })
          .toList();

      // Batch insert
      if (options.isNotEmpty) {
        await supabaseClient.from('variations').insert(options);
      }
    }
  }
}

showCustomSnackbar(context: context, message: 'Dish Added Successfully',backgroundColor: Colors.black);

    } on PostgrestException catch (e) {
      showCustomSnackbar(
          context: context, message: 'Failed Upload Unexpected Error:$e',backgroundColor: Colors.black);
          debugPrint('erorr in loading dish ...$e');
    } catch (e) {
      showCustomSnackbar(context: context, message: 'Failed to upload :$e',backgroundColor: Colors.black);
        debugPrint('erorr in loading dish ...$e');
    }
  }

Future<List<Map<String,dynamic>>>deleteDish ({required context,required int dishId})async{
  try{
   final res = await supabaseClient.from('dishes').delete().eq('id', dishId).select();
   if(res.isNotEmpty){
     debugPrint('Error: Failed To Delete Dish');
  return res;
   }
  }catch(e){
    debugPrint('Error: Failed To Delete Dish $e');
  }
  return [];
}
  

//Load preload dishes for search and others use
Future<void> preLoadDishes({required context})async{
    final restData = ref.watch(restaurantProvider);

  try{
final res = await supabaseClient.from('dishes').select('id , dish_name , dish_price , dish_imageurl, category_id').eq('rest_uid', restData!.restuid!);
  if (res.isNotEmpty) {
    ref.read(dishesPreviewList.notifier).state = res.map<DishPreview>((e) => DishPreview.fromJson(e)).toList();
  }

  }catch(e){
    debugPrint(e.toString());
    showCustomSnackbar(context: context, message: 'Erorr: Failed to load Data for dishes',backgroundColor: Colors.black);
  }

}

//for searching dish
List<DishPreview> searchDishes({required String? query}){
final dishes = ref.watch(dishesPreviewList);
return dishes.where((dish)=>dish.dihsName.toLowerCase().contains(query!.toLowerCase())).toList();


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