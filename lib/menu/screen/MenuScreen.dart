import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/adddishform.dart';

import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
import 'package:spicy_eats_admin/menu/model/DishModel.dart';
import 'package:spicy_eats_admin/menu/widgets/BuildHeader.dart';
import 'package:spicy_eats_admin/menu/widgets/BuildMenuContent.dart';

final categoriesProvider = StateProvider<List<CategoryModel>?>((ref) => null);
final showAddsScreenProvider = StateProvider<bool>((ref) => false);

class MenuManagerScreen extends ConsumerStatefulWidget {
  static const String routename = '/menu';
  const MenuManagerScreen({super.key});

 
 
 
  @override
  // ignore: library_private_types_in_public_api
  _MenuManagerScreenState createState() => _MenuManagerScreenState();
}




class _MenuManagerScreenState extends ConsumerState<MenuManagerScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(menuManagerRepoProvider).preLoadDishes(context: context,);
    });
    // TODO: implement initState
    super.initState();
  }



  bool isLoading = false;
  List<CategoryModel> categories = [];
  int length = 0;
  int availbleItems = 0;
  int unAvailableitems = 0;
    void showDishDetail(int dishId, WidgetRef ref,context) {
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
  Widget build(BuildContext context) {
    

 final searchResults = ref.watch(seacrhedDishesProvider);

    final showAddScreen = ref.watch(showAddsScreenProvider);
    final size = MediaQuery.of(context).size;
    final restData = ref.watch(restaurantProvider);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Positioned(
                      child: Stack(
                        children:[ Column(
                          children: [
                            Positioned(
                              top:0,
                              bottom: size.height * 0.21,
                              left: 0,
                              right: 0,
                              child: BuildHeader(restData:  restData!)),
                            isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : buildMenuContent(length: length, ref: ref),
                          ],
                        ),
                        ],
                      ),
                    ),
                  ),
                ),
                 Positioned(
                   top:size.height * 0.27,
                   right: 0,
                   left: 0,
        child: Container(
          
          color: Colors.white,
       
         child: ListView.builder(
          shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final dishPreview = searchResults[index];
          
            return DishPreviewTile(
              dish: dishPreview,
              onTap: ()=>  showDishDetail(dishPreview.id, ref,context),
            );
          },
             ),),
      ),
                showAddScreen
                    ? Positioned(
                        right: 0,
                        bottom: 0,
                        top: 0,
                        left: constraints.maxWidth > 700
                            ? size.width * 0.4
                            : constraints.maxWidth < 700 &&
                                    constraints.maxWidth > 500
                                ? size.width * 0.4
                                : 0,
                        child: AnimatedContainer(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(1, 1),
                                    spreadRadius: 2,
                                    blurRadius: 5)
                              ],
                            ),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.bounceInOut,
                            width: 500,
                            child:
                      

                                AddDishForm(
                              categories: ref.read(categoriesProvider),
                            )
                           
                            ),
                      )
                    :const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
