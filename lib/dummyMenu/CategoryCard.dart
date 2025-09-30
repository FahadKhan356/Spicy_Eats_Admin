import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/dummyMenu/CategoryItemTile.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';

class CategoryCard extends ConsumerWidget {
  final Function(String categoryId) categoryCartloadCategoryItems;
  final CategoryModel category;
  final bool isExpanded;
  final List<CategoryItemModel> items;
  final bool isLoading;
  final VoidCallback onToggle;
  final Function(CategoryItemModel)? onItemEdit;
  final Function(CategoryItemModel)? onItemDelete;
  final Function(CategoryItemModel, bool)? onItemToggle;
  final int index;

   const CategoryCard({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.items,
    required this.isLoading,
    required this.onToggle,
    this.onItemEdit,
    this.onItemDelete,
    this.onItemToggle,
    required this.categoryCartloadCategoryItems,
    required this.index,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final itemsFilter=ref.watch(itemsFilterProvider); 
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Category info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.categoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  // Expand/collapse icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF718096),
                  ),
                ],
              ),
            ),
          ),
          // Category items (shown when expanded)
          if (isExpanded) ...[
            const Divider(height: 1),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No items in this category',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              // FIXED: Changed from List.generate to Column for better layout
            Column(
                children: 
              itemsFilter=='All'?   items.asMap().entries.map((entry) {

                  final index = entry.key;
                  final item = entry.value;
                  final isFirst = index == 0;

                  return CategoryItemTile(
                    categoryItemTileloadCategoryItems:(String categoryId)=>categoryCartloadCategoryItems(categoryId),
                    isFirst: isFirst,
                    item: item,
                    onEdit: () => onItemEdit?.call(item),
                    onDelete: () => onItemDelete?.call(item),
                    onToggle: (isAvailable) =>
                        onItemToggle?.call(item, isAvailable),
                  );
                }).toList() : 
                itemsFilter=='Available'? 
              items.where((e)=>e.isAvailable==true).toList().asMap().entries.map((entry){
                 final index = entry.key;
                  final item = entry.value;
                  final isFirst = index == 0;

                  return CategoryItemTile( categoryItemTileloadCategoryItems:(String categoryId)=>categoryCartloadCategoryItems(categoryId),
                    isFirst: isFirst,
                    item: item,
                    onEdit: () => onItemEdit?.call(item),
                    onDelete: () => onItemDelete?.call(item),
                    onToggle: (isAvailable) =>
                        onItemToggle?.call(item, isAvailable),
                  );
              }).toList() :
               
              items.where((e)=>e.isAvailable==false).toList().asMap().entries.map((entry){ 
                 final index = entry.key;
                  final item = entry.value;
                  final isFirst = index == 0;

                  return  CategoryItemTile(
                     categoryItemTileloadCategoryItems:(String categoryId)=>categoryCartloadCategoryItems(categoryId),
                    isFirst: isFirst,
                    item: item,
                    onEdit: () => onItemEdit?.call(item),
                    onDelete: () => onItemDelete?.call(item),
                    onToggle: (isAvailable) =>
                        onItemToggle?.call(item, isAvailable),
                  );  
              }).toList()
              
              )
              
              
                
              
          
          ],
        ],
      ),
    );
  }
}
