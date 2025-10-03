import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/model/DishModel.dart';
import 'package:spicy_eats_admin/menu/model/DishPreview.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
import 'package:spicy_eats_admin/menu/model/RestaurantModel.dart';
import 'package:spicy_eats_admin/menu/widgets/ElevatedCustomButton.dart';

class BuildHeader extends ConsumerWidget {
  final RestaurantModel restData;
   const BuildHeader({super.key,required this.restData});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
     
  final size = MediaQuery.of(context).size;
  final showAddScreen = ref.watch(showAddsScreenProvider);
    return Stack(
      children:[ 
        Positioned(
        
          child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
                ),
                child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        offset: const Offset(0, 5),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      restData.restaurantLogoImageUrl!,
                      width: Responsive.isMobile(context)? 50 : 100,
                      height: Responsive.isMobile(context)? 50 : 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restData.restaurantName ?? '',
                        style:  TextStyle(
                
                          fontSize: size.width>300?24 : size.width * 0.035 ,
                          fontWeight: FontWeight.bold,
                          color:const Color(0xFF2D3748),
                        ),
                      ),
                       Text(
                        'Menu Manager',
                        style: TextStyle(
                          fontSize: size.width>300?14 : size.width * 0.025,
                          color:const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
                elevatedCustomButton(
                  onpress: () {
                    ref.read(showAddsScreenProvider.notifier).state =
                        !showAddScreen;
                  },
                  label: !Responsive.isMobile(context)?  const Text(
                    'Add Dish',
                    style: TextStyle(color: Colors.white),
                  ) : const  Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Center(child:  Icon(Icons.add)),
                )
              ],
            ),
            const SizedBox(height: 20),
            // _buildSearchAndFilter(ref),
            SearchAndFilter(),
            // Expanded(child: SearchedDishesResult()),
            SizedBox(height: 20,),
            
                
          ],
                ),
                
          ),
        ),
     
      ],
    );
  }
}


// Widget buildHeader(RestaurantModel restData, WidgetRef ref, context) {
//    final searchResults = ref.watch(seacrhedDishesProvider);
//   final size = MediaQuery.of(context).size;
//   final showAddScreen = ref.watch(showAddsScreenProvider);
//   return Container(
//     padding: const EdgeInsets.all(24),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withValues(alpha: 0.05),
//           blurRadius: 10,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withValues(alpha: 0.5),
//                     offset: const Offset(0, 5),
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   restData.restaurantLogoImageUrl!,
//                   width: Responsive.isMobile(context)? 50 : 100,
//                   height: Responsive.isMobile(context)? 50 : 100,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) =>
//                       const Icon(Icons.image),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     restData.restaurantName ?? '',
//                     style:  TextStyle(
    
//                       fontSize: size.width>300?24 : size.width * 0.035 ,
//                       fontWeight: FontWeight.bold,
//                       color:const Color(0xFF2D3748),
//                     ),
//                   ),
//                    Text(
//                     'Menu Manager',
//                     style: TextStyle(
//                       fontSize: size.width>300?14 : size.width * 0.025,
//                       color:const Color(0xFF718096),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             elevatedCustomButton(
//               onpress: () {
//                 ref.read(showAddsScreenProvider.notifier).state =
//                     !showAddScreen;
//               },
//               label: !Responsive.isMobile(context)?  const Text(
//                 'Add Dish',
//                 style: TextStyle(color: Colors.white),
//               ) : const  Text(
//                 'Add',
//                 style: TextStyle(color: Colors.white),
//               ),
//               icon: const Center(child:  Icon(Icons.add)),
//             )
//           ],
//         ),
//         const SizedBox(height: 20),
//         // _buildSearchAndFilter(ref),
//         SearchAndFilter(),
//         // Expanded(child: SearchedDishesResult()),
//         SizedBox(height: 20,),
        
//      Container(
//       height: 300,
//       width: 600,
//        child: ListView.builder(
//         shrinkWrap: true,
//              physics: NeverScrollableScrollPhysics(),
//         itemCount: searchResults.length,
//         itemBuilder: (context, index) {
//           final dishPreview = searchResults[index];
        
//           return DishPreviewTile(
//             dish: dishPreview,
//             onTap: () {} // showDishDetail(dishPreview.id, ref,context),
//           );
//         },
//            ),
//      ),
//       ],
//     ),
//   );
// }

class SearchAndFilter extends ConsumerStatefulWidget {
  const SearchAndFilter({super.key});

  @override
  ConsumerState<SearchAndFilter> createState() => _SearchAndFilterState();
}

class _SearchAndFilterState extends ConsumerState<SearchAndFilter> {
   final TextEditingController searchController = TextEditingController();

   @override
  void dispose() {
   searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     final menuRepo= ref.read(menuManagerRepoProvider);
    
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 245, 245, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            onChanged: (value){
              if(value.isNotEmpty){
ref.read(seacrhedDishesProvider.notifier).state= menuRepo.searchDishes(query: value);
              }else{
                 ref.read(seacrhedDishesProvider.notifier).state=[];
              }
              
            },
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search dishes...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF718096)),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: ref.watch(itemsFilterProvider),
          underline: const SizedBox(),
          items: ['All', 'Available', 'Unavailable']
              .map((filter) => DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  ))
              .toList(),
          onChanged: (value) {
            ref.read(itemsFilterProvider.notifier).state = value;
          },
        ),
      ),
    ],
  );
}
  }


// Widget _buildSearchAndFilter(WidgetRef ref) {
//     final TextEditingController searchController = TextEditingController();
 
//  final menuRepo= ref.read(menuManagerRepoProvider);
// //  final searchedDishes= ref.watch(seacrhedDishesProvider);
// // ref.read(seacrhedDishesProvider.notifier).state= menuRepo.searchDishes(query: searchController.text);

//   return Row(
//     children: [
//       Expanded(
//         flex: 2,
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color.fromRGBO(245, 245, 245, 1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: TextField(
//             onChanged: (value){
//               ref.read(seacrhedDishesProvider.notifier).state= menuRepo.searchDishes(query: value);
//             },
//             controller: searchController,
//             decoration: const InputDecoration(
//               hintText: 'Search dishes...',
//               prefixIcon: Icon(Icons.search, color: Color(0xFF718096)),
//               border: InputBorder.none,
//               contentPadding:
//                   EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(width: 16),
//       Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: DropdownButton<String>(
//           value: ref.watch(itemsFilterProvider),
//           underline: const SizedBox(),
//           items: ['All', 'Available', 'Unavailable']
//               .map((filter) => DropdownMenuItem(
//                     value: filter,
//                     child: Text(filter),
//                   ))
//               .toList(),
//           onChanged: (value) {
//             ref.read(itemsFilterProvider.notifier).state = value;
//           },
//         ),
//       ),
//     ],
//   );
// }

class SearchedDishesResult extends ConsumerWidget {
  

  void _showDishDetail(int dishId, WidgetRef ref,context) {
    // Show loading while fetching details
    showDialog(
      context: context,
      builder: (context) => FutureBuilder<DishModel>(
        future: ref.read(menuManagerRepoProvider).getSearchedDish(dishId: dishId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return AlertDialog(title: Text('Error loading dish'));
          }
          
          return DishDetailDialog(dish: snapshot.data!);
        },
      ),
    );}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(seacrhedDishesProvider);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final dishPreview = searchResults[index];
        
        return DishPreviewTile(
          dish: dishPreview,
          onTap: () => _showDishDetail(dishPreview.id, ref,context),
        );
      },
    );
  }
}

class DishPreviewTile extends StatelessWidget {
  final DishPreview dish;
  final VoidCallback onTap;

  const DishPreviewTile({required this.dish, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(dish.dishImageUrl, width: 50, height: 50,
      errorBuilder: (context, error , stacktrace){
        return const Icon(Icons.photo);
      }
      ),
      title: Text(dish.dihsName,),
      subtitle: Text('\$${dish.dishPrice}'),
      onTap: onTap,
    );
    
  }
}
class DishDetailDialog extends StatelessWidget {
  final DishModel dish;

  const DishDetailDialog({Key? key, required this.dish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with image
            _buildHeader(context),
            
            // Content with scroll
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfo(),
                   
                  ],
                ),
              ),
            ),
            
            // Footer with actions
           
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Dish image
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            image: DecorationImage(
              image: NetworkImage(dish.dish_imageurl!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Close button
        Positioned(
          top: 12,
          right: 12,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            radius: 16,
            child: IconButton(
              icon: Icon(Icons.close, size: 18, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        
        // Price badge
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${dish.dish_price!.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dish.dish_name!,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        if (dish.category_id != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              dish.category_id!,
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          dish.dish_description!,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
