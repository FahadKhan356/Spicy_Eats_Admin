import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
import 'package:spicy_eats_admin/menu/model/RestaurantModel.dart';
import 'package:spicy_eats_admin/menu/widgets/ElevatedCustomButton.dart';

Widget buildHeader(RestaurantModel restData, WidgetRef ref, context) {
  final size = MediaQuery.of(context).size;
  final showAddScreen = ref.watch(showAddsScreenProvider);
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
              child: Flexible(
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
                      color: Color(0xFF2D3748),
                    ),
                  ),
                   Text(
                    'Menu Manager',
                    style: TextStyle(
                      fontSize: size.width>300?14 : size.width * 0.025,
                      color: Color(0xFF718096),
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
        _buildSearchAndFilter(ref),
      ],
    ),
  );
}

Widget _buildSearchAndFilter(WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();
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
