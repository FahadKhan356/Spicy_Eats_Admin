import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/config/supabaseconfig.dart';

class ReviewModel {
  final int id;
  final int rating;
  final String? body;
  final String? reply;
  final String reviewer;
  final DateTime createdAt;
  final String? dishName;
  final int? dishId;
  final bool isDishReview;

  const ReviewModel({
    required this.id,
    required this.rating,
    required this.reviewer,
    required this.createdAt,
    this.body,
    this.reply,
    this.dishName,
    this.dishId,
    this.isDishReview = false,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, {bool isDish = false}) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    return ReviewModel(
      id: (json['id'] as num).toInt(),
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      body: json['body']?.toString(),
      reply: json['reply']?.toString(),
      reviewer:
          (profile?['email'] as String?)?.split('@').first ?? 'Customer',
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ?? DateTime.now(),
      dishName: json['dish_name']?.toString(),
      dishId: json['dish_id'] is num ? (json['dish_id'] as num).toInt() : null,
      isDishReview: isDish,
    );
  }
}

class ReviewsRepo {
  Future<List<ReviewModel>> fetch(String restUid) async {
    return fetchRestaurantReviews(restUid);
  }

  Future<List<ReviewModel>> fetchRestaurantReviews(String restUid) async {
    var res = await _query(restUid, table: 'restaurant_reviews', embedProfile: true);
    res ??= await _query(restUid, table: 'restaurant_reviews', embedProfile: false) ?? const [];
    return res.map((j) => ReviewModel.fromJson(j, isDish: false)).toList();
  }

  Future<List<ReviewModel>> fetchDishReviews(String restUid) async {
    var res = await _query(restUid, table: 'dish_reviews', embedProfile: true);
    res ??= await _query(restUid, table: 'dish_reviews', embedProfile: false) ?? const [];
    return res.map((j) => ReviewModel.fromJson(j, isDish: true)).toList();
  }

  Future<bool> replyToReview({
    required int reviewId,
    required String reply,
    bool isDishReview = false,
  }) async {
    try {
      final table = isDishReview ? 'dish_reviews' : 'restaurant_reviews';
      await supabaseClient.from(table).update({
        'reply': reply.trim(),
        'replied_at': DateTime.now().toIso8601String(),
      }).eq('id', reviewId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> _query(
    String restUid, {
    required String table,
    required bool embedProfile,
  }) async {
    try {
      final fkName = '${table}_user_id_fkey';
      return await supabaseClient
          .from(table)
          .select(embedProfile
              ? '*, profiles:users!$fkName(email)'
              : '*')
          .eq('restaurant_id', restUid)
          .eq('is_hidden', false)
          .order('created_at', ascending: false)
          .limit(10);
    } catch (_) {
      return null;
    }
  }
}

final reviewsRepoProvider = Provider<ReviewsRepo>((ref) => ReviewsRepo());

final reviewsProvider =
    FutureProvider.autoDispose.family<List<ReviewModel>, String>((ref, restUid) {
  return ref.read(reviewsRepoProvider).fetchRestaurantReviews(restUid);
});

final dishReviewsProvider =
    FutureProvider.autoDispose.family<List<ReviewModel>, String>((ref, restUid) {
  return ref.read(reviewsRepoProvider).fetchDishReviews(restUid);
});
