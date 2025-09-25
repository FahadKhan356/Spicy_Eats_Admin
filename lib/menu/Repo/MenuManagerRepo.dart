import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
import 'package:spicy_eats_admin/menu/model/RestaurantModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final menuManagerRepoProvider = Provider((ref) => MenuManagerRepo(ref: ref));
final restaurantProvider = StateProvider<RestaurantModel?>((ref) => null);
final loadingProvider= StateProvider((ref)=>false);

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

  Future<List<CategoryModel>?>fetchCategories({required restId})async{
    
    ref.read(loadingProvider.notifier).state=true;
    try{
     
      final response = await supabaseClient.from('categories').select('*').eq('rest_uid',restId).order('created_at',ascending:true);
      if(response.isNotEmpty){
        final data=response.map((e)=>CategoryModel.fromJson(e)).toList();
       return data;
      }

    }on PostgrestException catch (e) {
      debugPrint('Supabase Error: Failed to fetch categories: ${e.message}');
      rethrow;
    } catch (e) {
   
      debugPrint('Unexpected Error: Failed to fetch categories: $e');
      rethrow;

    }finally{
       ref.read(loadingProvider.notifier).state=false;
    }
  return null;

  }

Future<List<CategoryItemModel>?> fetchCategoryitems({required String categoryId})async{
  try{
    final response= await supabaseClient.from('dishes').select('*').eq('category_id',categoryId).order('created_at',ascending:true);
    if(response.isNotEmpty){
      final data = response.map((e)=>CategoryItemModel.fromJson(e)).toList();
        debugPrint('Restaurant fetched: ${data.length}');
      
      return data;
    }

  }on PostgrestException catch(e){
    debugPrint('Supabase Erorr: failed to fetch category items: ${e.message}');
  }catch(e){
 debugPrint('Supabase Erorr: failed to fetch category items: $e');
  }

return null;
}





Future<void> setInOutStock({required bool isAvailble, required dishId,required context})async{
  try{
final response=await supabaseClient.from('dishes').update({'isAvailable':isAvailble}).eq('id',dishId);
if(response!=null){
  showCustomSnackbar(context: context, message: 'Stock Updated');
}
debugPrint('stack updated for dish to $isAvailble  for id $dishId');

  }catch(e){
    debugPrint('Failed to update stock status: $e');
  }
}


//show real time menu screen stats
//Dishes Table Stream Funtion to listen Stream of data 

Stream<List<Map<String,dynamic>>>listenDishStream(){
return supabaseClient
      .from('dishes')
      .stream(primaryKey: ['id'])
      .order('id');// must include some ordering

}


//Real time Available items
 int streamAvailableItems({required  List<Map<String,dynamic>> snapshot, required String restUid}){
 final res= snapshot
        .where((item) =>
            item['rest_uid'] == restUid &&
            item['isAvailable'] == true)
        .toList();

   if(res.isNotEmpty){
   
  return res.length;

   }
    return 0;
  }

//Real time total items

  int streamTotalItems({required  List<Map<String,dynamic>> snapshot, required String restUid}){
     final res= snapshot.where((item)=>item['rest_uid']==restUid);
  if(res.isNotEmpty){
    return res.length;
  }
  return 0;
  }


}
