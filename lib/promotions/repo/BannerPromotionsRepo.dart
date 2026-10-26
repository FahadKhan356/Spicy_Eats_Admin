import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/promotions/model/BannerPromotionModel.dart';
import 'package:spicy_eats_admin/utils/UploadImageToSupabase.dart';

class BannerPromotionsRepo {
  static final List<BannerPositionModel> fallbackPositions = [
    const BannerPositionModel(
      id: 'default-home-top',
      name: 'Home Top Carousel',
      maxBanners: 5,
      basePrice: 2500,
    ),
    const BannerPositionModel(
      id: 'default-deals-day',
      name: 'Deals of the Day',
      maxBanners: 3,
      basePrice: 1800,
    ),
    const BannerPositionModel(
      id: 'default-cat-spotlight',
      name: 'Category Header Spotlight',
      maxBanners: 4,
      basePrice: 1200,
    ),
  ];

  Future<List<BannerPositionModel>> fetchPositions() async {
    try {
      final res = await supabaseClient
          .from('banner_positions')
          .select('*')
          .order('name');
      final list = (res as List).map((e) => BannerPositionModel.fromJson(e as Map<String, dynamic>)).toList();
      if (list.isNotEmpty) return list;
    } catch (e) {
      debugPrint('fetchPositions fallback: $e');
    }
    return fallbackPositions;
  }

  Future<List<BannerSlotModel>> fetchRestaurantBanners(String restUid) async {
    try {
      final res = await supabaseClient
          .from('banner_slots')
          .select('*, banner_positions(name), banner_requests(payment_status, approval_status)')
          .eq('restaurant_id', restUid)
          .order('created_at', ascending: false);

      return (res as List)
          .map((e) => BannerSlotModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('fetchRestaurantBanners error: $e');
      rethrow;
    }
  }

  Future<void> requestBanner({
    required String restUid,
    required String positionId,
    required String bannerTitle,
    required String? redirectUrl,
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required Uint8List imageBytes,
  }) async {
    // 1. Upload banner image to Supabase storage
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = 'banners/${restUid}_$timestamp.jpg';

    final imageUrl = await uploadImageToSupabase(
      imageBytes,
      dishImagesBucket,
      path,
    );

    // 2. Insert into banner_slots
    final slotRow = await supabaseClient.from('banner_slots').insert({
      'restaurant_id': restUid,
      'position_id': positionId.startsWith('default-') ? null : positionId,
      'banner_title': bannerTitle.trim(),
      'redirect_url': (redirectUrl?.trim().isNotEmpty ?? false) ? redirectUrl!.trim() : null,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'price': price,
      'status': 'pending',
      'banner_image_url': imageUrl,
    }).select().single();

    final slotId = slotRow['id'];

    // 3. Insert into banner_requests
    await supabaseClient.from('banner_requests').insert({
      'restaurant_id': restUid,
      'slot_id': slotId,
      'payment_status': 'pending',
      'approval_status': 'pending',
      'requested_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateStatus({
    required String slotId,
    required String status,
  }) async {
    await supabaseClient
        .from('banner_slots')
        .update({'status': status})
        .eq('id', slotId);

    try {
      await supabaseClient
          .from('banner_requests')
          .update({
            'approval_status': status,
            'payment_status': status == 'approved' ? 'paid' : 'pending',
            if (status == 'approved') 'approved_at': DateTime.now().toIso8601String(),
          })
          .eq('slot_id', slotId);
    } catch (_) {}
  }

  Future<void> deleteBanner(String slotId) async {
    try {
      await supabaseClient
          .from('banner_requests')
          .delete()
          .eq('slot_id', slotId);
    } catch (_) {}

    await supabaseClient
        .from('banner_slots')
        .delete()
        .eq('id', slotId);
  }
}

final bannerPromotionsRepoProvider =
    Provider<BannerPromotionsRepo>((ref) => BannerPromotionsRepo());

class BannerPromotionsState {
  final List<BannerPositionModel> positions;
  final List<BannerSlotModel> all;
  final String filter;
  final bool loading;
  final String? error;

  const BannerPromotionsState({
    this.positions = const [],
    this.all = const [],
    this.filter = 'All',
    this.loading = false,
    this.error,
  });

  List<BannerSlotModel> get visible => switch (filter) {
        'Pending' => all.where((b) => b.isPending).toList(),
        'Live' => all.where((b) => b.isActive).toList(),
        'Rejected' => all.where((b) => b.isRejected).toList(),
        'Expired' => all.where((b) => b.isExpired).toList(),
        _ => all,
      };

  int get liveCount => all.where((b) => b.isActive).length;
  int get pendingCount => all.where((b) => b.isPending).length;
}

class BannerPromotionsController extends Notifier<BannerPromotionsState> {
  @override
  BannerPromotionsState build() => const BannerPromotionsState();

  Future<void> load(String restUid) async {
    state = BannerPromotionsState(
      positions: state.positions,
      all: state.all,
      filter: state.filter,
      loading: true,
      error: null,
    );

    try {
      final repo = ref.read(bannerPromotionsRepoProvider);
      final positions = await repo.fetchPositions();
      final slots = await repo.fetchRestaurantBanners(restUid);

      state = BannerPromotionsState(
        positions: positions,
        all: slots,
        filter: state.filter,
        loading: false,
        error: null,
      );
    } catch (e) {
      state = BannerPromotionsState(
        positions: state.positions.isNotEmpty
            ? state.positions
            : BannerPromotionsRepo.fallbackPositions,
        all: state.all,
        filter: state.filter,
        loading: false,
        error: '$e',
      );
    }
  }

  void setFilter(String filter) {
    state = BannerPromotionsState(
      positions: state.positions,
      all: state.all,
      filter: filter,
      loading: state.loading,
      error: state.error,
    );
  }

  Future<void> requestBanner({
    required String restUid,
    required String positionId,
    required String bannerTitle,
    required String? redirectUrl,
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required Uint8List imageBytes,
  }) async {
    await ref.read(bannerPromotionsRepoProvider).requestBanner(
          restUid: restUid,
          positionId: positionId,
          bannerTitle: bannerTitle,
          redirectUrl: redirectUrl,
          startDate: startDate,
          endDate: endDate,
          price: price,
          imageBytes: imageBytes,
        );
    await load(restUid);
  }

  Future<void> setStatus(String slotId, String newStatus, String restUid) async {
    await ref.read(bannerPromotionsRepoProvider).updateStatus(
          slotId: slotId,
          status: newStatus,
        );
    await load(restUid);
  }

  Future<void> remove(String slotId, String restUid) async {
    await ref.read(bannerPromotionsRepoProvider).deleteBanner(slotId);
    await load(restUid);
  }
}

final bannerPromotionsControllerProvider =
    NotifierProvider<BannerPromotionsController, BannerPromotionsState>(
  BannerPromotionsController.new,
);
