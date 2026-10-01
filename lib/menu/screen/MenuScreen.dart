import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
import 'package:spicy_eats_admin/menu/model/DishModel.dart';
import 'package:spicy_eats_admin/menu/widgets/AddDishPanel.dart';
import 'package:spicy_eats_admin/menu/widgets/BuildHeader.dart';
import 'package:spicy_eats_admin/menu/widgets/BuildMenuContent.dart';

final categoriesProvider = StateProvider<List<CategoryModel>?>((ref) => null);
final showAddsScreenProvider = StateProvider<bool>((ref) => false);

class MenuManagerScreen extends ConsumerStatefulWidget {
  static const String routename = '/menu';

  const MenuManagerScreen({super.key});

  @override
  ConsumerState<MenuManagerScreen> createState() => _MenuManagerScreenState();
}

class _MenuManagerScreenState extends ConsumerState<MenuManagerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _preLoad());
  }

  Future<void> _preLoad() async {
    if (!mounted) return;
    try {
      await ref.read(menuManagerRepoProvider).preLoadDishes(context: context);
    } catch (_) {}
  }

  void _showDishDetail(int dishId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => FutureBuilder<DishModel>(
        future: ref.read(menuManagerRepoProvider).getSearchedDish(dishId: dishId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const AlertDialog(title: Text('Could not load this dish'));
          }
          return DishDetailDialog(dish: snapshot.data!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showAddScreen = ref.watch(showAddsScreenProvider);
    final searchResults = ref.watch(seacrhedDishesProvider);
    final restaurant = ref.watch(restaurantProvider);
    final restaurantError = ref.watch(restaurantErrorProvider);

    if (restaurant == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: restaurantError != null
              ? Padding(
                  padding: const EdgeInsets.all(28),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.storefront_outlined,
                            size: 44, color: Colors.red),
                        const SizedBox(height: 14),
                        const Text(
                          'Menu unavailable',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          restaurantError,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: () => ref
                              .read(menuManagerRepoProvider)
                              .fetchRestaurantData(),
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.black),
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                BuildHeader(
                  restData: restaurant,
                  onDishTapped: _showDishDetail,
                ),
                buildMenuContent(length: searchResults.length, ref: ref),
              ],
            ),
            if (showAddScreen)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: MediaQuery.of(context).size.width > 1100
                    ? MediaQuery.of(context).size.width * 0.45
                    : 0,
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const AddDishPanel(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
