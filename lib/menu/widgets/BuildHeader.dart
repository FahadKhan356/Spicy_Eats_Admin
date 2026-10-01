import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/model/DishModel.dart';
import 'package:spicy_eats_admin/menu/model/DishPreview.dart';
import 'package:spicy_eats_admin/menu/model/RestaurantModel.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
import 'package:spicy_eats_admin/menu/widgets/ElevatedCustomButton.dart';

class BuildHeader extends ConsumerWidget {
  final RestaurantModel restData;
  final ValueChanged<int> onDishTapped;

  const BuildHeader({
    super.key,
    required this.restData,
    required this.onDishTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAddScreen = ref.watch(showAddsScreenProvider);
    final searchResults = ref.watch(seacrhedDishesProvider);

    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Logo(url: restData.restaurantLogoImageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      restData.restaurantName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const Text(
                      'Menu Manager',
                      style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
                    ),
                  ],
                ),
              ),
              elevatedCustomButton(
                onpress: () {
                  ref.read(showAddsScreenProvider.notifier).state = !showAddScreen;
                },
                label: Text(
                  Responsive.isMobile(context) ? 'Add' : 'Add Dish',
                  style: const TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SearchAndFilter(),
          if (searchResults.isNotEmpty) ...[
            const SizedBox(height: 16),
            SearchedDishesResult(
              dishes: searchResults,
              onDishTapped: onDishTapped,
            ),
          ],
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String? url;

  const _Logo({this.url});

  @override
  Widget build(BuildContext context) {
    final size = Responsive.isMobile(context) ? 48.0 : 72.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: url == null || url!.isEmpty
          ? Container(
              width: size,
              height: size,
              color: Colors.grey[200],
              child: const Icon(Icons.restaurant, color: Colors.black45),
            )
          : Image.network(
              url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: size,
                height: size,
                color: Colors.grey[200],
                child: const Icon(Icons.restaurant, color: Colors.black45),
              ),
            ),
    );
  }
}

class SearchAndFilter extends ConsumerStatefulWidget {
  const SearchAndFilter({super.key});

  @override
  ConsumerState<SearchAndFilter> createState() => _SearchAndFilterState();
}

class _SearchAndFilterState extends ConsumerState<SearchAndFilter> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuRepo = ref.read(menuManagerRepoProvider);
    final filter = ref.watch(itemsFilterProvider);
    ref.listen(itemsFilterProvider, (previous, next) {
      ref.read(seacrhedDishesProvider.notifier).state =
          _controller.text.trim().isEmpty
              ? []
              : menuRepo.searchDishes(query: _controller.text, filter: next);
    });

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
              controller: _controller,
              onChanged: (value) {
                ref.read(seacrhedDishesProvider.notifier).state = value.isEmpty
                    ? []
                    : menuRepo.searchDishes(query: value, filter: filter);
              },
              decoration: const InputDecoration(
                hintText: 'Search dishes...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF718096)),
                border: InputBorder.none,
                filled: false,
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
            value: filter,
            underline: const SizedBox(),
            items: const ['All', 'Available', 'Unavailable']
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(itemsFilterProvider.notifier).state = value;
              }
            },
          ),
        ),
      ],
    );
  }
}

class SearchedDishesResult extends StatelessWidget {
  final List<DishPreview> dishes;
  final ValueChanged<int> onDishTapped;

  const SearchedDishesResult({
    super.key,
    required this.dishes,
    required this.onDishTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 260),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: dishes.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return DishPreviewTile(
            dish: dishes[index],
            onTap: () => onDishTapped(dishes[index].id),
          );
        },
      ),
    );
  }
}

class DishPreviewTile extends StatelessWidget {
  final DishPreview dish;
  final VoidCallback onTap;

  const DishPreviewTile({super.key, required this.dish, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: dish.dishImageUrl.isEmpty
          ? const Icon(Icons.photo_outlined)
          : Image.network(
              dish.dishImageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.photo_outlined),
            ),
      title: Text(dish.dihsName),
      subtitle: Text('\$${dish.dishPrice.toStringAsFixed(2)}'),
      onTap: onTap,
    );
  }
}

class DishDetailDialog extends StatelessWidget {
  final DishModel dish;

  const DishDetailDialog({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 620),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dish.dish_name ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _infoRow('Price', '\$${(dish.dish_price ?? 0).toStringAsFixed(2)}'),
                    _infoRow(
                      'Discounted',
                      '\$${(dish.dish_discount ?? 0).toStringAsFixed(2)}',
                    ),
                    _infoRow('Veg', dish.isVeg == true ? 'Yes' : 'No'),
                    if ((dish.dish_description ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        dish.dish_description ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final url = dish.dish_imageurl ?? '';

    return Stack(
      children: [
        Container(
          height: 190,
          width: double.infinity,
          color: Colors.grey[200],
          child: url.isEmpty
              ? const Icon(Icons.restaurant, size: 40, color: Colors.black26)
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.restaurant, size: 40, color: Colors.black26),
                ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            radius: 16,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${(dish.dish_price ?? 0).toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
