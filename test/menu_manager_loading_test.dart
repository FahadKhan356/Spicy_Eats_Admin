import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';

/// Regression test for the crash that showed up the first time the Menu
/// Manager screen was opened:
///
///   Failed to load categories: At least listener of the StateNotifier
///   Instance of 'StateController<bool>' threw an exception when the notifier
///   tried to update its state.
///   ... Tried to modify a provider while the widget tree was building.
///
/// [ExpandableCategoryMenu] used to start loading in `initState`, which made
/// `MenuManagerRepo.fetchCategories` flip `loadingProvider` inside the build
/// phase. Riverpod forbids that, so the whole screen blew up.
void main() {
  testWidgets('menu manager loads categories without touching providers during '
      'the build phase', (tester) async {
    final errors = <FlutterErrorDetails>[];
    final previousHandler = FlutterError.onError;
    FlutterError.onError = errors.add;
    addTearDown(() => FlutterError.onError = previousHandler);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Mirrors `MenuManagerRepo.fetchCategories`: the loading flag is flipped
    // before the (fake) request is awaited.
    Future<List<CategoryModel>?> loadCategories() async {
      container.read(loadingProvider.notifier).state = true;
      final categories = [
        CategoryModel(
          categoryId: 'cat-1',
          createdAt: DateTime(2025, 9, 14),
          categoryName: 'Burgers & Sandwiches',
          restUid: 'rest-1',
          categoryDescription: '',
        ),
      ];
      container.read(loadingProvider.notifier).state = false;
      return categories;
    }

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: ExpandableCategoryMenu(
              loadCategories: loadCategories,
              loadCategoryItems: (_) async => const [],
            ),
          ),
        ),
      ),
    );

    // First pump is the build phase, the second one lets the deferred load run.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(
      errors.map((e) => e.exceptionAsString()),
      everyElement(isNot(contains('Tried to modify a provider'))),
      reason: 'providers must not be modified while the widget tree builds',
    );
    expect(container.read(loadingProvider), isFalse);
    expect(find.text('Burgers & Sandwiches'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
