import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/menu/widgets/BuildStatCard.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

Widget buildStats({required WidgetRef ref}) {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: ref.read(menuManagerController).listenDishStream(),
    builder: (context, snapshot) {
      final dishes = snapshot.data;

      if (!snapshot.hasData)
        return const Center(
          child: CircularProgressIndicator(),
        );
      final restUid = ref.read(restaurantProvider)!.restuid!;

      final avgPrice =
          ref.read(menuManagerController).totalAvgPrice(snapshot: dishes!);

      final itemsTotalLength = ref
          .read(menuManagerController)
          .streamTotalItems(restUid: restUid, snapshot: snapshot.data!);

      final itemsAvailableLength = ref
          .read(menuManagerController)
          .streamAvailableItems(restUid: restUid, snapshot: snapshot.data!);

      final itemsUnavailableLength = itemsTotalLength - itemsAvailableLength;

      return IntrinsicHeight(
        child: Row(
          children: [
            buildStatCard('Total Items', itemsTotalLength.toString(),
                MyAppColor.orangePrimary, context),
            const SizedBox(width: 16),
            buildStatCard('Available', itemsAvailableLength.toString(),
                MyAppColor.orangePrimary, context),
            const SizedBox(width: 16),
            buildStatCard('Unavailable', itemsUnavailableLength.toString(),
                MyAppColor.orangePrimary, context),
            const SizedBox(width: 16),
            buildStatCard('Avg Price', '\$${avgPrice.toStringAsFixed(2)}',
                MyAppColor.orangePrimary, context),
          ],
        ),
      );
    },
  );
}
