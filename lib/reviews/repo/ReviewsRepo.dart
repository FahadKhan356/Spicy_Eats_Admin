import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/config/supabaseconfig.dart';

class ReviewModel {
  final int id;
  final int rating;
  final String? body;
  final String? reply;
  final String reviewer;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.rating,
    required this.reviewer,
    required this.createdAt,
    this.body,
    this.reply,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
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
    );
  }
}

class ReviewsRepo {
  Future<List<ReviewModel>> fetch(String restUid) async {
    var res = await _query(restUid, embedProfile: true);
    if (res == null) {
      res = await _query(restUid, embedProfile: false) ?? const [];
    }
    return res.map(ReviewModel.fromJson).toList();
  }

  Future<List<Map<String, dynamic>>?> _query(
    String restUid, {
    required bool embedProfile,
  }) async {
    try {
      return await supabaseClient
          .from('restaurant_reviews')
          .select(embedProfile
              ? '*, profiles:users!restaurant_reviews_user_id_fkey(email)'
              : '*')
          .eq('restaurant_id', restUid)
          .eq('is_hidden', false)
          .order('created_at', ascending: false)
          .limit(6);
    } catch (_) {
      return null;
    }
  }
}

final reviewsRepoProvider = Provider<ReviewsRepo>((ref) => ReviewsRepo());

final reviewsProvider =
    FutureProvider.autoDispose.family<List<ReviewModel>, String>((ref, restUid) {
  return ref.read(reviewsRepoProvider).fetch(restUid);
});
