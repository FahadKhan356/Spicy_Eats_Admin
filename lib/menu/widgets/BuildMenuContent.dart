import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';

Widget buildMenuContent({required int length, required WidgetRef ref}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ExpandableCategoryMenu(
          loadCategories: () => _loadCategories(ref),
          loadCategoryItems: (categoryId) =>
              _loadCategoryItems(categoryId: categoryId, ref: ref),
        ),
      ],
    ),
  );
}

Future<List<CategoryModel>> _loadCategories(WidgetRef ref) async {
  final restUid = ref.read(restaurantProvider)?.restuid;
  if (restUid == null || restUid.isEmpty) return const [];

  final list = await ref
      .read(menuManagerControllerProvider)
      .fetchCategories(restId: restUid);
  return list ?? const [];
}

Future<List<CategoryItemModel>> _loadCategoryItems({
  required String categoryId,
  required WidgetRef ref,
}) async {
  final list = await ref
      .read(menuManagerControllerProvider)
      .fetchCategoriesItems(categoryId: categoryId);
  return list ?? const [];
}
