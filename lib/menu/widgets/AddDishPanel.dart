import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/menu/adddishform.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';

class AddDishPanel extends ConsumerWidget {
  const AddDishPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    if (categories == null || categories.isEmpty) {
      return ColoredBox(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.folder_off_outlined, size: 40, color: Colors.black26),
                const SizedBox(height: 12),
                const Text(
                  'Create a category first',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'A dish must belong to a category. Add a category to your menu '
                  'before adding dishes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      ref.read(showAddsScreenProvider.notifier).state = false,
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AddDishForm(categories: categories);
  }
}
