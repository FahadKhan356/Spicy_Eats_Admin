import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/adddishform.dart';

import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
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
  bool isLoading = false;
  List<CategoryModel> categories = [];
  int length = 0;
  int availbleItems = 0;
  int unAvailableitems = 0;

  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      children: [
                        buildHeader(restData!, ref, context),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : buildMenuContent(length: length, ref: ref),
                      ],
                    ),
                  ),
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
