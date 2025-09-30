import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';

class MenuContent extends ConsumerWidget {
  static const String routename = '/MenuScreen';
  const MenuContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIXED: Remove Scaffold wrapper - just return the content
    return ExpandableCategoryMenu(
      loadCategories: () => _loadCategories(ref),
      loadCategoryItems: (categoryId) =>
          _loadCategoryItems(categoryId: categoryId, ref: ref),
      onItemEdit: (item) => _showEditDialog(context, item),
      onItemDelete: (item) => _showDeleteDialog(context, item,ref),
      onItemToggle: (item, isAvailable) =>
          _toggleItemAvailability(item, isAvailable),
    );
  }

  Future<List<CategoryModel>?> _loadCategories(WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final list = await ref
        .read(menuManagerController)
        .fetchCategories(restId: ref.read(restaurantProvider)!.restuid!);
    return list ?? [];
  }

  Future<List<CategoryItemModel>?> _loadCategoryItems(
      {required String categoryId, required WidgetRef ref}) async {
    // await Future.delayed(const Duration(milliseconds: 800));
    final list = await ref
        .read(menuManagerController)
        .fetchCategoriesItems(categoryId: categoryId);
    return list;
  }

  void _showEditDialog(BuildContext context, CategoryItemModel item) {
    print('Edit item: ${item.dish_name}');
  }

  void _showDeleteDialog(BuildContext context, CategoryItemModel item,WidgetRef ref)async {
       await ref.read(menuManagerController).deleteDish(context: context, dishId: item.id!);
    print('Delete item: ${item.dish_name}');
  }

  void _toggleItemAvailability(CategoryItemModel item, bool isAvailable) {
    print(
        'Toggle ${item.dish_name} to ${item.isAvailable ? 'available' : 'unavailable'}');
  }
}