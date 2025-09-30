import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';

final menuManagerController = Provider((ref) {
  final repo = ref.read(menuManagerRepoProvider);
  return MenuManagerController(repo: repo);
});

class MenuManagerController {
  MenuManagerController({required this.repo});
  MenuManagerRepo repo;

  Future<void> fetchRestaurantData() async {
    await repo.fetchRestaurantData();
  }

  Future<List<CategoryModel>?> fetchCategories({required String restId}) async {
    final categories = await repo.fetchCategories(restId: restId);
    return categories;
  }

  Future<List<CategoryItemModel>?> fetchCategoriesItems(
      {required String categoryId}) async {
    final items = await repo.fetchCategoryitems(categoryId: categoryId);
    return items;
  }

  Future<void> setInOutStock(
      {required bool isAvailble, required int dishId, required context}) async {
    await repo.setInOutStock(
        isAvailble: isAvailble, dishId: dishId, context: context);
  }

//Menu Screen Real-Time Stats functions
  Stream<List<Map<String, dynamic>>> listenDishStream() {
    return repo.listenDishStream();
  }

  int streamAvailableItems(
      {required List<Map<String, dynamic>> snapshot, required String restUid}) {
    return repo.streamAvailableItems(snapshot: snapshot, restUid: restUid);
  }

  int streamTotalItems(
      {required List<Map<String, dynamic>> snapshot, required String restUid}) {
    return repo.streamTotalItems(snapshot: snapshot, restUid: restUid);
  }

  double totalAvgPrice({required List<Map<String, dynamic>> snapshot}) {
    return repo.toalAvgPrice(snapshot: snapshot);
  }

  Future<void> addDish({
    required context,
    required String restUid,
    required String dishName,
    required String dishDisc,
    required String dishPrice,
    required String dishDisPrice,
    required Uint8List dishImage,
    required CategoryModel category,
    String? varTitle,
    required bool isVeg,
    List<Map<String, dynamic>>? variations,
  }) async {
    await repo.addDish(
        context: context,
        restUid: restUid,
        dishName: dishName,
        dishDisc: dishDisc,
        dishPrice: dishPrice,
        dishDisPrice: dishDisPrice,
        dishImage: dishImage,
        category: category,
        isVeg: isVeg);
  }

Future<List<Map<String,dynamic>>>deleteDish({required context,required int dishId})async{
 return await repo.deleteDish(context: context, dishId: dishId);
}

}
