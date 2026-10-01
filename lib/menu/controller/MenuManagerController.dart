import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';

final menuManagerControllerProvider = Provider<MenuManagerController>((ref) {
  return MenuManagerController(repo: ref.watch(menuManagerRepoProvider));
});

@Deprecated('Use menuManagerControllerProvider instead')
final menuManagerController = menuManagerControllerProvider;

class MenuManagerController {
  final MenuManagerRepo repo;

  MenuManagerController({required this.repo});

  Future<void> fetchRestaurantData() => repo.fetchRestaurantData();

  Future<List<CategoryModel>?> fetchCategories({required String restId}) =>
      repo.fetchCategories(restId: restId);

  Future<List<CategoryItemModel>?> fetchCategoriesItems({
    required String categoryId,
  }) =>
      repo.fetchCategoryitems(categoryId: categoryId);

  Future<void> setInOutStock({
    required bool isAvailble,
    required int dishId,
    required context,
  }) =>
      repo.setInOutStock(isAvailble: isAvailble, dishId: dishId, context: context);

  Stream<List<Map<String, dynamic>>> listenDishStream() => repo.listenDishStream();

  int streamAvailableItems({
    required List<Map<String, dynamic>> snapshot,
    required String restUid,
  }) =>
      repo.streamAvailableItems(snapshot: snapshot, restUid: restUid);

  int streamTotalItems({
    required List<Map<String, dynamic>> snapshot,
    required String restUid,
  }) =>
      repo.streamTotalItems(snapshot: snapshot, restUid: restUid);

  double totalAvgPrice({required List<Map<String, dynamic>> snapshot}) =>
      repo.toalAvgPrice(snapshot: snapshot);

  Future<void> addDish({
    required context,
    required String restUid,
    required String dishName,
    required String dishDisc,
    required String dishPrice,
    required String dishDisPrice,
    required Uint8List dishImage,
    required CategoryModel category,
    required bool isVeg,
    List<Map<String, dynamic>>? variations,
  }) =>
      repo.addDish(
        context: context,
        restUid: restUid,
        dishName: dishName,
        dishDisc: dishDisc,
        dishPrice: dishPrice,
        dishDisPrice: dishDisPrice,
        dishImage: dishImage,
        category: category,
        isVeg: isVeg,
        variations: variations,
      );

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
  }) =>
      repo.updateDish(
        context: context,
        dishId: dishId,
        dishName: dishName,
        dishDisc: dishDisc,
        dishPrice: dishPrice,
        dishDisPrice: dishDisPrice,
        category: category,
        isVeg: isVeg,
        dishImage: dishImage,
      );

  Future<bool> deleteDish({required int dishId}) => repo.deleteDish(dishId: dishId);
}
