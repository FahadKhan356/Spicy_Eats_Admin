import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/promotions/model/PromotionModel.dart';

class PromotionsRepo {
  Future<List<PromotionModel>> fetchPromotions(String restUid) async {
    final res = await supabaseClient
        .from('promotions')
        .select('*')
        .eq('restaurant_id', restUid)
        .order('created_at', ascending: false);

    return res.map(PromotionModel.fromJson).toList();
  }

  Future<void> setActive({
    required int id,
    required bool isActive,
  }) async {
    await supabaseClient
        .from('promotions')
        .update({'is_active': isActive})
        .eq('id', id);
  }

  Future<void> create({
    required String restUid,
    required String title,
    required String description,
    required String kind,
    required double value,
    required double minOrder,
    required double? maxDiscount,
    required String code,
    required int durationDays,
  }) async {
    final cleanCode = code.trim().toUpperCase();

    await supabaseClient.from('promotions').insert({
      'restaurant_id': restUid,
      'title': title,
      'description': description,
      'kind': kind,
      'value': value,
      'min_order': minOrder,
      'max_discount': maxDiscount,
      'code': cleanCode.isEmpty ? null : cleanCode,
      'starts_at': DateTime.now().toIso8601String(),
      'ends_at': durationDays > 0
          ? DateTime.now()
              .add(Duration(days: durationDays))
              .toIso8601String()
          : null,
      'is_active': true,
    });
  }

  Future<void> delete(int id) async {
    await supabaseClient.from('promotions').delete().eq('id', id);
  }
}

final promotionsRepoProvider = Provider<PromotionsRepo>((ref) => PromotionsRepo());

class PromotionsState {
  final List<PromotionModel> all;
  final String filter;

  const PromotionsState({required this.all, required this.filter});

  List<PromotionModel> get visible => switch (filter) {
        'Live' => all.where((p) => p.state == PromotionState.live).toList(),
        'Paused' => all.where((p) => p.state == PromotionState.inactive).toList(),
        'Scheduled' => all.where((p) => p.state == PromotionState.scheduled).toList(),
        'Expired' => all.where((p) => p.state == PromotionState.expired).toList(),
        _ => all,
      };

  int get liveCount =>
      all.where((p) => p.state == PromotionState.live).length;

  int get totalRedemptions => all.fold(0, (sum, p) => sum + p.usedCount);
}

class PromotionsController extends Notifier<PromotionsState> {
  @override
  PromotionsState build() => const PromotionsState(all: [], filter: 'All');

  Future<void> load(String restUid) async {
    final list = await ref.read(promotionsRepoProvider).fetchPromotions(restUid);
    state = PromotionsState(all: list, filter: state.filter);
  }

  void setFilter(String filter) {
    state = PromotionsState(all: state.all, filter: filter);
  }

  Future<void> toggle(PromotionModel promotion, String restUid) async {
    await ref
        .read(promotionsRepoProvider)
        .setActive(id: promotion.id, isActive: !promotion.isActive);
    await load(restUid);
  }

  Future<void> remove(int id, String restUid) async {
    await ref.read(promotionsRepoProvider).delete(id);
    await load(restUid);
  }

  Future<void> create({
    required String restUid,
    required String title,
    required String description,
    required String kind,
    required double value,
    required double minOrder,
    required double? maxDiscount,
    required String code,
    required int durationDays,
  }) async {
    await ref.read(promotionsRepoProvider).create(
          restUid: restUid,
          title: title,
          description: description,
          kind: kind,
          value: value,
          minOrder: minOrder,
          maxDiscount: maxDiscount,
          code: code,
          durationDays: durationDays,
        );
    await load(restUid);
  }
}

final promotionsControllerProvider =
    NotifierProvider<PromotionsController, PromotionsState>(
  PromotionsController.new,
);
