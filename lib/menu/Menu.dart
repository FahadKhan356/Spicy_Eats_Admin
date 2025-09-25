import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/model/CategoryItem.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/adddishform.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
import 'package:spicy_eats_admin/menu/model/RestaurantModel.dart';
import 'package:spicy_eats_admin/menu/widgets/BuildMenuContent.dart';

final categoriesProvider= StateProvider<List<CategoryModel>?>((ref)=>null);
final showAddsScreenProvider = StateProvider<bool>((ref)=>false);

class MenuManagerScreen extends ConsumerStatefulWidget {
  static const String routename='/menu';
   const MenuManagerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuManagerScreenState createState() => _MenuManagerScreenState();
}

class _MenuManagerScreenState extends ConsumerState<MenuManagerScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  List<CategoryModel> categories=[];
  int length=0;
  int availbleItems=0;
  int unAvailableitems=0;
  
  



  @override
  Widget build(BuildContext context) {
    final showAddScreen= ref.watch(showAddsScreenProvider);
    final size= MediaQuery.of(context).size;
    final restData=ref.watch(restaurantProvider);
    return Scaffold(
      backgroundColor: Colors.grey[50],
     body: SafeArea(
  child: LayoutBuilder(
    builder: (context, constraints) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  _buildHeader(restData!),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildMenuContent(length: length, ref: ref),
                ],
              ),
            ),
          ),
        showAddScreen?  Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            left: constraints.maxWidth>500?  0 : size.width * 0.5,
            child:  AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.bounceInOut,
              width: 500,
              color: Colors.blue,
              child:  
              // Column(
              //   children: [
              //     IconButton(icon:const Icon(Icons.cancel),onPressed: (){setState(() {
              //       showAddScreen=false;
              //     });},),
               
               AddDishForm(categories: ref.read(categoriesProvider),)
              //   ],
              // ),
            ),
          ) : SizedBox(),
        ],
      );
    },
  ),
),
    );
  }

  Widget _buildHeader(RestaurantModel restData) {
    final showAddScreen=ref.watch(showAddsScreenProvider);
    return Container(
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
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const Text(
                      'Menu Manager',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: (){
                 ref.read(showAddsScreenProvider.notifier).state=!showAddScreen;
                  
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Dish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchAndFilter(),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
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
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search dishes...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF718096)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            ref.read(itemsFilterProvider.notifier).state=value;
            },
          ),
        ),
      ],
    );
  }


}

