import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';

final editedCategoryItemProvider = StateProvider<CategoryItemModel?>((ref)=>null);


class CategoryItemTile extends ConsumerStatefulWidget {
  final Function(String categoryId) categoryItemTileloadCategoryItems;
  final CategoryItemModel item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(bool)? onToggle;
  final bool isFirst;

  const CategoryItemTile({
    super.key,
    required this.isFirst,
    required this.item,
    required this.categoryItemTileloadCategoryItems,
    this.onEdit,
    this.onDelete,
    this.onToggle,
  });

  @override
  ConsumerState<CategoryItemTile> createState() => _CategoryItemTile();
}

bool showInOutOfStockOptions = false;

// The function to show the dialog

class _CategoryItemTile extends ConsumerState<CategoryItemTile> {
  
Future<void> showDeleteConfirmationDialog(BuildContext context,WidgetRef ref,int dishId) async {
  return showDialog<void>(
    context: context,
    // Prevents the dialog from being dismissed by tapping outside
    barrierDismissible: false, 
    builder: (BuildContext dialogContext) {
      return ref.watch(isloadingprovider)?const Center(child: CircularProgressIndicator(backgroundColor: Colors.black26,color: Colors.black,),) : AlertDialog(
        backgroundColor: Colors.white,

        title: const Text('Confirm Deletion'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this dish permanently?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel',style: TextStyle(color: Colors.black,),),
            onPressed: () {
              
              Navigator.of(dialogContext).pop(false); 
            },
          ),
          TextButton(
          
            child: const Text('Delete', style: TextStyle(color: Colors.red)), 
            onPressed: () async{
               final success = await ref
                              .read(menuManagerController)
                              .deleteDish(
                                  dishId: widget.item.dishid!, context: null);

                          if (!mounted) return;

                          if (success.isNotEmpty) {
                            showCustomSnackbar(
                              context: context,
                              message: "Dish deleted permanently",
                              backgroundColor: Colors.black,
                            );
                            widget.categoryItemTileloadCategoryItems(
                                widget.item.category_id!);
                          } else {
                            showCustomSnackbar(
                              context: context,
                              message: "Failed to delete dish",
                              backgroundColor: Colors.red,
                            );
                          }
                               Navigator.of(dialogContext).pop(true);
          //       ref.read(isloadingprovider.notifier).state=true;
          //  await ref.read(menuManagerController).deleteDish(context: context, dishId: dishId);
          //  debugPrint('$dishId');
          //     ref.read(isloadingprovider.notifier).state=false;
          //     Navigator.of(dialogContext).pop(true);
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(menuManagerController);
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 790;
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  children: [
                    const Expanded(
                        flex: 2,
                        child: Text("Dish",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    !isMobile
                        ? const Expanded(
                            flex: 3,
                            child: Text("Description",
                                style: TextStyle(fontWeight: FontWeight.bold)))
                        : const SizedBox(),
                    !isMobile
                        ? const Expanded(
                            flex: 2,
                            child: Text("Discount Price",
                                style: TextStyle(fontWeight: FontWeight.bold)))
                        : const SizedBox(),
                    !isMobile
                        ? const Expanded(
                            flex: 2,
                            child: Text("Actual Price",
                                style: TextStyle(fontWeight: FontWeight.bold)))
                        : const SizedBox(),
                    !isMobile
                        ? const Expanded(
                            flex: 2,
                            child: Text("Status",
                                style: TextStyle(fontWeight: FontWeight.bold)))
                        : const SizedBox(),
                    const Expanded(
                        flex: 2,
                        child: Text("Actions",
                            style: TextStyle(fontWeight: FontWeight.bold))),
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
                                errorBuilder: (_, __, ___) =>
                                    _buildPlaceholderImage(),
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
                !isMobile
                    ? Expanded(
                        flex: 3,
                        child: Text(
                          widget.item.dish_description ?? "",
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF718096)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox(),

                // Discount price
                !isMobile
                    ? Expanded(
                        flex: 2,
                        child: Text(
                          '\$${widget.item.dish_discount?.toStringAsFixed(2) ?? "0.00"}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    : const SizedBox(),

                // Actual price
                !isMobile
                    ? Expanded(
                        flex: 2,
                        child: Text(
                          '\$${widget.item.dish_price?.toStringAsFixed(2) ?? "0.00"}',
                          style: const TextStyle(color: Color(0xFF718096)),
                        ),
                      )
                    : const SizedBox(),

                // Status
                !isMobile
                    ? Expanded(
                        flex: 2,
                        child: DropdownButton<String>(
                          value: widget.item.isAvailable
                              ? 'In stock'
                              : 'Out of stock',
                          underline: const SizedBox(),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                                value: 'In stock', child: Text("In stock")),
                            DropdownMenuItem(
                                value: 'Out of stock',
                                child: Text("Out of stock")),
                          ],
                          onChanged: (value) async {
                            if (value == null) return;
                            final isAvailable = value == 'In stock';

                            await controller.setInOutStock(
                              isAvailble: isAvailable,
                              dishId: widget.item.id!,
                              context: context,
                            );

                            setState(
                                () => widget.item.isAvailable = isAvailable);
                          },
                        ),
                      )
                    : const SizedBox(),

                // Actions
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          ref.read(editedCategoryItemProvider.notifier).state=widget.item;
                          ref.read(showAddsScreenProvider.notifier).state=true;
                          
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: Colors.black,
                      ),
                      IconButton(
                        onPressed: () async {
                          showDeleteConfirmationDialog(context,ref,widget.item.dishid!);
                         
                        },
                        //  await ref.read(menuManagerController).deleteDish(context: context, dishId: widget.item.id!);
                        //  showDeleteConfirmationDialog(context ,ref,widget.item.id!);

                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
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
