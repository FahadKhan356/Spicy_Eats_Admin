import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/dummyMenu/CategoryCard.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';

final itemsFilterProvider=StateProvider<String?>((ref)=>'All');
final categoryItemsProvider=StateProvider<Map<String,List<CategoryItemModel>>>((ref)=>{});



// Main expandable category widget
class ExpandableCategoryMenu extends ConsumerStatefulWidget {
  static const String routename = '/Expandable';

  final Future<List<CategoryModel>?> Function() loadCategories;
  final Future<List<CategoryItemModel>?> Function(String categoryId)
      loadCategoryItems;
  final Function(CategoryItemModel item)? onItemEdit;
  final Function(CategoryItemModel item)? onItemDelete;
  final Function(CategoryItemModel item, bool isAvailable)? onItemToggle;

   const ExpandableCategoryMenu({
    super.key,
    required this.loadCategories,
    required this.loadCategoryItems,
    this.onItemEdit,
    this.onItemDelete,
    this.onItemToggle,
  });

  @override
  ConsumerState<ExpandableCategoryMenu> createState() => _ExpandableCategoryMenuState();
}

class _ExpandableCategoryMenuState extends ConsumerState<ExpandableCategoryMenu> {
  List<CategoryModel> categories = [];
  Set<String> expandedCategories = {};
  // Map<String, List<CategoryItemModel>> categoryItems = {};
  Map<String, bool> loadingStates = {};
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories(ref);
  }

  Future<void> _loadCategories(WidgetRef ref) async {
    try {
      final loadedCategories = await widget.loadCategories();
      setState(() {
        categories = loadedCategories!;
        isLoadingCategories = false;
      });
      ref.read(categoriesProvider.notifier).state=loadedCategories;
    } catch (e) {
      setState(() => isLoadingCategories = false);
      _showError('Failed to load categories: $e');
    }
  }

  

  Future<void> _toggleCategory(String categoryId) async {
    if (expandedCategories.contains(categoryId)) {
      // Collapse category
      setState(() => expandedCategories.remove(categoryId));
    } else {
      // Expand category and load items if not already loaded
      setState(() => expandedCategories.add(categoryId));

      if (!ref.read(categoryItemsProvider.notifier).state.containsKey(categoryId)) {
        await loadCategoryItems(categoryId);
      }
    }
  }




  Future<void> loadCategoryItems(String categoryId) async {
    setState(() => loadingStates[categoryId] = true);

    try {
      final items = await widget.loadCategoryItems(categoryId);
      setState(() {
        ref.read(categoryItemsProvider.notifier).state[categoryId] = items!;
        loadingStates[categoryId] = false;
     debugPrint('Inside load category');
     
      });
    } catch (e) {
      setState(() => loadingStates[categoryId] = false);
      _showError('Failed to load items : $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    debugPrint('Erorr: in load categories items: $message');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    // FIXED: Removed Container with fixed height and ListView.builder
    // Now using Column with shrinkWrap to let parent handle scrolling
    return Column(
      children: categories.map((category) {
        final index = categories.indexOf(category);
        final isExpanded = expandedCategories.contains(category.categoryId);
      final categoryItems = ref.watch(categoryItemsProvider);
final items = categoryItems[category.categoryId] ?? [];
        final isLoading = loadingStates[category.categoryId] ?? false;
    
        return CategoryCard(
          categoryCartloadCategoryItems:(String categoryId)=> loadCategoryItems(categoryId),
          index: index,
          category: category,
          isExpanded: isExpanded,
          items: items,
          isLoading: isLoading,
          onToggle: () => _toggleCategory(category.categoryId),
          onItemEdit: widget.onItemEdit,
          onItemDelete: widget.onItemDelete,
          onItemToggle: widget.onItemToggle,
        );
      }).toList(),
    );
  }
}

// Category card widget - No changes needed here


// Usage example
// class MenuScreen extends ConsumerWidget {
//   static const String routename = '/MenuScreen';
//   MenuScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: ExpandableCategoryMenu(
//         loadCategories: () => _loadCategories(ref),
//         loadCategoryItems: (categoryId) =>
//             _loadCategoryItems(categoryId: categoryId, ref: ref),
//         onItemEdit: (item) => _showEditDialog(context, item),
//         onItemDelete: (item) => _showDeleteDialog(context, item),
//         onItemToggle: (item, isAvailable) =>
//             _toggleItemAvailability(item, isAvailable),
//       ),
//     );
//   }

//   // Mock data loading functions (replace with your Supabase calls)
//   Future<List<CategoryModel>?> _loadCategories(WidgetRef ref) async {
//     // Simulate API delay
//     await Future.delayed(const Duration(milliseconds: 500));

//     // All categories are fetched initially - matches your image
//     final list = await ref
//         .read(menuManagerController)
//         .fetchCategories(restId: ref.read(restaurantProvider)!.restuid!);
//     return list ?? [];
//   }

//   Future<List<CategoryItemModel>?> _loadCategoryItems(
//       {required String categoryId, required WidgetRef ref}) async {
//     // Simulate API delay
//     await Future.delayed(const Duration(milliseconds: 800));
//     final list = await ref
//         .read(menuManagerController)
//         .fetchCategoriesItems(categoryId: categoryId);
//     return list;
//   }

//   void _showEditDialog(BuildContext context, CategoryItemModel item) {
//     // Implement edit dialog
//     print('Edit item: ${item.dish_name}');
//   }

//   void _showDeleteDialog(BuildContext context, CategoryItemModel item) {
//     // Implement delete confirmation
//     print('Delete item: ${item.dish_name}');
//   }

//   void _toggleItemAvailability(CategoryItemModel item, bool isAvailable) {
//     // Implement toggle functionality

//     print(
//         'Toggle ${item.dish_name} to ${item.isAvailable ? 'available' : 'unavailable'}');
//   }
// }
