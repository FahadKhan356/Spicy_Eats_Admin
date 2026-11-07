import 'package:flutter_test/flutter_test.dart';
import 'package:spicy_eats_admin/reviews/repo/ReviewsRepo.dart';

void main() {
  group('ReviewModel parsing tests', () {
    test('parses restaurant review from json with profile', () {
      final json = {
        'id': 1,
        'rating': 5,
        'body': 'Crispy and fresh chicken! Fast delivery.',
        'reply': 'Thank you for your valuable feedback!',
        'created_at': '2026-11-05T13:25:48.926673+00:00',
        'profiles': {'email': 'sajidaawan90@gmail.com'},
      };

      final model = ReviewModel.fromJson(json, isDish: false);

      expect(model.id, 1);
      expect(model.rating, 5);
      expect(model.body, 'Crispy and fresh chicken! Fast delivery.');
      expect(model.reply, 'Thank you for your valuable feedback!');
      expect(model.reviewer, 'sajidaawan90');
      expect(model.isDishReview, false);
      expect(model.dishName, isNull);
    });

    test('parses dish review from json with dish_name', () {
      final json = {
        'id': 10,
        'dish_id': 12,
        'dish_name': 'Big BAIK with Cheese',
        'rating': 4,
        'body': 'Very cheesy and tender!',
        'reply': null,
        'created_at': '2026-11-06T10:00:00+00:00',
        'profiles': {'email': 'huzaifa@example.com'},
      };

      final model = ReviewModel.fromJson(json, isDish: true);

      expect(model.id, 10);
      expect(model.dishId, 12);
      expect(model.dishName, 'Big BAIK with Cheese');
      expect(model.rating, 4);
      expect(model.body, 'Very cheesy and tender!');
      expect(model.reply, isNull);
      expect(model.reviewer, 'huzaifa');
      expect(model.isDishReview, true);
    });

    test('parses full name from profile when firstname and lastname exist', () {
      final json = {
        'id': 2,
        'rating': 5,
        'body': 'Great food!',
        'created_at': '2026-11-05T13:25:48.926673+00:00',
        'profiles': {
          'firstname': 'Sajida',
          'lastname': 'Awan',
          'email': 'sajidaawan90@gmail.com',
        },
      };

      final model = ReviewModel.fromJson(json);

      expect(model.reviewer, 'Sajida Awan');
    });

    test('handles missing profile and null body safely', () {
      final json = {
        'id': 99,
        'rating': null,
        'body': null,
        'created_at': null,
        'profiles': null,
      };

      final model = ReviewModel.fromJson(json);

      expect(model.id, 99);
      expect(model.rating, 0);
      expect(model.body, isNull);
      expect(model.reviewer, 'Customer');
    });
  });
}

