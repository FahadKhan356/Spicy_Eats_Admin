import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/orders/model/OrderModel.dart';

class OrdersRepo {
  bool _restaurantIdColumnExists = true;

  Future<List<OrderModel>> fetchOrders({
    required String restUid,
    required String restName,
  }) async {
    List<Map<String, dynamic>> rows;

    if (_restaurantIdColumnExists) {
      try {
        rows = await supabaseClient
            .from('orders')
            .select('*')
            .eq('restaurant_id', restUid)
            .order('created_at', ascending: false);
      } catch (_) {
        _restaurantIdColumnExists = false;
        rows = const [];
      }
    } else {
      rows = const [];
    }

    if (rows.isEmpty) {
      rows = await _fetchAndFilterByItems(restUid, restName);
    }

    return rows.map(OrderModel.fromJson).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchAndFilterByItems(
    String restUid,
    String restName,
  ) async {
    final byName = await supabaseClient
        .from('orders')
        .select('*')
        .eq('orderedFrom', restName)
        .order('created_at', ascending: false);

    final all = <Map<String, dynamic>>[...byName];

    if (all.isEmpty) {
      final everyOrder = await supabaseClient
          .from('orders')
          .select('*')
          .order('created_at', ascending: false);
      all.addAll(everyOrder);
    }

    return all.where((row) {
      if (row['orderedFrom'] == restName) return true;
      final items = row['orderedItems'];
      if (items is! List) return false;
      return items.any((item) =>
          item is Map && item['restaurant_id']?.toString() == restUid);
    }).toList();
  }

  Future<void> updateStatus({
    required int orderId,
    required String status,
    String? cancelledReason,
  }) async {
    final payload = <String, dynamic>{
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (cancelledReason != null) {
      payload['cancelled_reason'] = cancelledReason;
    }
    await supabaseClient
        .from('orders')
        .update(payload)
        .eq('id', orderId);
  }

  Future<void> cancelOrder({
    required int orderId,
    required String reason,
  }) async {
    await updateStatus(
      orderId: orderId,
      status: 'cancelled',
      cancelledReason: reason,
    );
  }
}

final ordersRepoProvider = Provider<OrdersRepo>((ref) => OrdersRepo());

final ordersProvider =
    FutureProvider.autoDispose.family<List<OrderModel>, String>((ref, restUid) async {
  final restaurant = ref.watch(restaurantProvider);
  if (restaurant == null || restaurant.restuid == null) return const [];
  return ref.read(ordersRepoProvider).fetchOrders(
        restUid: restaurant.restuid!,
        restName: restaurant.restaurantName ?? '',
      );
});

final dashboardStatsProvider = FutureProvider.autoDispose
    .family<DashboardStats, String>((ref, restUid) async {
  final restaurant = ref.watch(restaurantProvider);
  final orders = await ref.watch(ordersProvider(restUid).future);

  final revenue = orders
      .where((o) => o.status != 'cancelled' && o.status != 'rejected')
      .fold<double>(0, (sum, o) => sum + (o.totalPrice ?? 0));

  final active = orders
      .where((o) => o.status == 'pending' || o.status == 'preparing')
      .length;

  final delivered = orders.where((o) => o.status == 'delivered').length;
  final cancelled = orders.where((o) => o.status == 'cancelled').length;

  return DashboardStats(
    restaurantName: restaurant?.restaurantName ?? '',
    totalRevenue: revenue,
    totalOrders: orders.length,
    activeOrders: active,
    deliveredOrders: delivered,
    cancelledOrders: cancelled,
    averageRating: restaurant?.averageRatings ?? 0,
    totalRatings: restaurant?.totalRatings ?? 0,
  );
});

class DashboardStats {
  final String restaurantName;
  final double totalRevenue;
  final int totalOrders;
  final int activeOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final double averageRating;
  final int totalRatings;

  const DashboardStats({
    required this.restaurantName,
    required this.totalRevenue,
    required this.totalOrders,
    required this.activeOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.averageRating,
    required this.totalRatings,
  });
}
