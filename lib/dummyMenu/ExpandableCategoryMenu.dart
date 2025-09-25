import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/menu/Menu.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';

final itemsFilterProvider=StateProvider<String?>((ref)=>'All');


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
  Map<String, List<CategoryItemModel>> categoryItems = {};
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

      if (!categoryItems.containsKey(categoryId)) {
        await _loadCategoryItems(categoryId);
      }
    }
  }

  Future<void> _loadCategoryItems(String categoryId) async {
    setState(() => loadingStates[categoryId] = true);

    try {
      final items = await widget.loadCategoryItems(categoryId);
      setState(() {
        categoryItems[categoryId] = items!;
        loadingStates[categoryId] = false;
      });
    } catch (e) {
      setState(() => loadingStates[categoryId] = false);
      _showError('Failed to load items AsaS: $e');
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
        final items = categoryItems[category.categoryId] ?? [];
        final isLoading = loadingStates[category.categoryId] ?? false;
    
        return CategoryCard(
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
class CategoryCard extends ConsumerWidget {
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

                  return CategoryItemTile(
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

// Menu item tile widget - No changes needed
class CategoryItemTile extends ConsumerStatefulWidget {
  final CategoryItemModel item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(bool)? onToggle;
  final bool isFirst;

   const CategoryItemTile({
    super.key,
    required this.isFirst,
    required this.item,
    this.onEdit,
    this.onDelete,
    this.onToggle,
  });

  @override
  ConsumerState<CategoryItemTile> createState() => _CategoryItemTile();
}

bool showInOutOfStockOptions = false;

class _CategoryItemTile extends ConsumerState<CategoryItemTile> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(menuManagerController);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile=constraints.maxWidth<790;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[100]!),
          ),
        ),
        child: Column(
          children: [
            // Header row - only show for first item
            if (widget.isFirst)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child:  Row(
                  children: [
                   const Expanded(flex: 2, child: Text("Dish", style: TextStyle(fontWeight: FontWeight.bold))),
                   !isMobile? const Expanded(flex: 3, child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))) : const SizedBox(),
                   !isMobile?  const Expanded(flex: 2, child: Text("Discount Price", style: TextStyle(fontWeight: FontWeight.bold))): const SizedBox(),
                   !isMobile? const Expanded(flex: 2, child: Text("Actual Price", style: TextStyle(fontWeight: FontWeight.bold))) : const SizedBox(),
                   !isMobile? const Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))) : const SizedBox(),
                    Expanded(flex: 2, child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
      
            if (widget.isFirst) const Divider(height: 1),
      
            // Dish row
            Row(
              
              children: [
                // Dish name + image
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.item.dish_imageurl!.isNotEmpty
                            ? Image.network(
                                widget.item.dish_imageurl!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                              )
                            : _buildPlaceholderImage(),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.item.dish_name!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
      
                // Description
               !isMobile? Expanded(
                  flex: 3,
                  child: Text(
                    widget.item.dish_description ?? "",
                    style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ) : const SizedBox(),
      
                // Discount price
                 !isMobile? Expanded(
                  flex: 2,
                  child: Text(
                    '\$${widget.item.dish_discount?.toStringAsFixed(2) ?? "0.00"}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ) : const SizedBox(),
      
                // Actual price
               !isMobile? Expanded(
                  flex: 2,
                  child: Text(
                    '\$${widget.item.dish_price?.toStringAsFixed(2) ?? "0.00"}',
                    style: const TextStyle(color: Color(0xFF718096)),
                  ),
                ) : const SizedBox(),
      
                // Status
               !isMobile? Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: widget.item.isAvailable ? 'In stock' : 'Out of stock',
                    underline: const SizedBox(),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'In stock', child: Text("In stock")),
                      DropdownMenuItem(value: 'Out of stock', child: Text("Out of stock")),
                    ],
                    onChanged: (value) async {
                      if (value == null) return;
                      final isAvailable = value == 'In stock';
      
                      await controller.setInOutStock(
                        isAvailble: isAvailable,
                        dishId: widget.item.id!,
                        context: context,
                      );
      
                      setState(() => widget.item.isAvailable = isAvailable);
                    },
                  ),
                ) : const SizedBox(),
      
                // Actions
                Expanded(
                  flex:  2,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: widget.onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: Colors.blue[600],
                      ),
                      IconButton(
                        onPressed: widget.onDelete,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: Colors.red[600],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );}
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.fastfood, color: Colors.grey),
    );
  }
}
// Usage example
class MenuScreen extends ConsumerWidget {
  static const String routename = '/MenuScreen';
  MenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ExpandableCategoryMenu(
        loadCategories: () => _loadCategories(ref),
        loadCategoryItems: (categoryId) =>
            _loadCategoryItems(categoryId: categoryId, ref: ref),
        onItemEdit: (item) => _showEditDialog(context, item),
        onItemDelete: (item) => _showDeleteDialog(context, item),
        onItemToggle: (item, isAvailable) =>
            _toggleItemAvailability(item, isAvailable),
      ),
    );
  }

  // Mock data loading functions (replace with your Supabase calls)
  Future<List<CategoryModel>?> _loadCategories(WidgetRef ref) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // All categories are fetched initially - matches your image
    final list = await ref
        .read(menuManagerController)
        .fetchCategories(restId: ref.read(restaurantProvider)!.restuid!);
    return list ?? [];
  }

  Future<List<CategoryItemModel>?> _loadCategoryItems(
      {required String categoryId, required WidgetRef ref}) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    final list = await ref
        .read(menuManagerController)
        .fetchCategoriesItems(categoryId: categoryId);
    return list;
  }

  void _showEditDialog(BuildContext context, CategoryItemModel item) {
    // Implement edit dialog
    print('Edit item: ${item.dish_name}');
  }

  void _showDeleteDialog(BuildContext context, CategoryItemModel item) {
    // Implement delete confirmation
    print('Delete item: ${item.dish_name}');
  }

  void _toggleItemAvailability(CategoryItemModel item, bool isAvailable) {
    // Implement toggle functionality

    print(
        'Toggle ${item.dish_name} to ${item.isAvailable ? 'available' : 'unavailable'}');
  }
}
