 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/menu/widgets/BuildStats.dart';
import 'package:spicy_eats_admin/menu/widgets/MenuContent.dart' show MenuContent;

Widget buildMenuContent({required int length, required WidgetRef ref}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStats(ref: ref),
          const SizedBox(height: 24),
          // FIXED: Remove Expanded wrapper and nested SingleChildScrollView
          const MenuContent(),
        ],
      ),
    );
  }