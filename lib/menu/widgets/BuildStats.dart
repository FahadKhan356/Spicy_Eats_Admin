
  import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/menu/widgets/BuildStatCard.dart';

Widget buildStats({required WidgetRef ref}) {

    return 
   StreamBuilder<List<Map<String, dynamic>>>(
  stream: ref.read(menuManagerController).listenDishStream(),
 
     
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
   final restUid=ref.read(restaurantProvider)!.restuid!;
   
   
    final itemsTotalLength=ref.read(menuManagerController).streamTotalItems(restUid:restUid ,snapshot:snapshot.data! );

final itemsAvailableLength= ref.read(menuManagerController).streamAvailableItems(restUid:restUid  ,snapshot:snapshot.data! );

final itemsUnavailableLength= itemsTotalLength-itemsAvailableLength;
 
     return Row(
       children: [
          buildStatCard('Total Items', itemsTotalLength.toString(), Colors.blue),
           const SizedBox(width: 16),
         buildStatCard('Available', itemsAvailableLength.toString(), Colors.green),
           const SizedBox(width: 16),
        buildStatCard('Unavailable', itemsUnavailableLength.toString(), Colors.red),
        const SizedBox(width: 16),
        buildStatCard('Avg Price', '\$${0.toStringAsFixed(2)}', Colors.orange),
       ],
     );
  },
);

      
     
  }