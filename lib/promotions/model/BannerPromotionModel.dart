import 'package:spicy_eats_admin/utils/json_coercion.dart';

class BannerPositionModel {
  final String id;
  final String name;
  final int maxBanners;
  final double basePrice;

  const BannerPositionModel({
    required this.id,
    required this.name,
    required this.maxBanners,
    required this.basePrice,
  });

  factory BannerPositionModel.fromJson(Map<String, dynamic> json) {
    return BannerPositionModel(
      id: asString(json['id']),
      name: asString(json['name']),
      maxBanners: asIntOrNull(json['max_banners']) ?? 5,
      basePrice: asDoubleOrNull(json['base_price']) ?? 0.0,
    );
  }
}

class BannerSlotModel {
  final String id;
  final String positionId;
  final String? positionName;
  final String restaurantId;
  final String bannerTitle;
  final String bannerImageUrl;
  final String? redirectUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final double price;
  final String status;
  final String paymentStatus;
  final String approvalStatus;
  final DateTime createdAt;

  const BannerSlotModel({
    required this.id,
    required this.positionId,
    this.positionName,
    required this.restaurantId,
    required this.bannerTitle,
    required this.bannerImageUrl,
    this.redirectUrl,
    this.startDate,
    this.endDate,
    required this.price,
    required this.status,
    this.paymentStatus = 'pending',
    this.approvalStatus = 'pending',
    required this.createdAt,
  });

  factory BannerSlotModel.fromJson(Map<String, dynamic> json) {
    String? posName;
    if (json['banner_positions'] is Map) {
      posName = asStringOrNull(json['banner_positions']['name']);
    } else {
      posName = asStringOrNull(json['position_name']);
    }

    String payStatus = 'pending';
    String appStatus = 'pending';
    if (json['banner_requests'] is List && (json['banner_requests'] as List).isNotEmpty) {
      final req = (json['banner_requests'] as List).first;
      if (req is Map) {
        payStatus = asString(req['payment_status'], 'pending');
        appStatus = asString(req['approval_status'], 'pending');
      }
    } else if (json['banner_requests'] is Map) {
      final req = json['banner_requests'] as Map;
      payStatus = asString(req['payment_status'], 'pending');
      appStatus = asString(req['approval_status'], 'pending');
    }

    return BannerSlotModel(
      id: asString(json['id']),
      positionId: asString(json['position_id']),
      positionName: posName,
      restaurantId: asString(json['restaurant_id']),
      bannerTitle: asString(json['banner_title'], 'Sponsored Banner'),
      bannerImageUrl: asString(json['banner_image_url']),
      redirectUrl: asStringOrNull(json['redirect_url']),
      startDate: asDateTimeOrNull(json['start_date']),
      endDate: asDateTimeOrNull(json['end_date']),
      price: asDoubleOrNull(json['price']) ?? 0.0,
      status: asString(json['status'], 'pending'),
      paymentStatus: payStatus,
      approvalStatus: appStatus,
      createdAt: asDateTime(json['created_at']),
    );
  }

  bool get isPending =>
      status.toLowerCase() == 'pending' || approvalStatus.toLowerCase() == 'pending';

  bool get isActive {
    if (status.toLowerCase() == 'rejected' || approvalStatus.toLowerCase() == 'rejected') {
      return false;
    }
    if (isPending) return false;
    final now = DateTime.now();
    if (endDate != null && now.isAfter(endDate!.add(const Duration(days: 1)))) {
      return false;
    }
    return status.toLowerCase() == 'approved' || status.toLowerCase() == 'active';
  }

  bool get isExpired {
    if (endDate == null) return false;
    final now = DateTime.now();
    return now.isAfter(endDate!.add(const Duration(days: 1)));
  }

  bool get isRejected =>
      status.toLowerCase() == 'rejected' || approvalStatus.toLowerCase() == 'rejected';

  String get statusLabel {
    if (isRejected) return 'Rejected';
    if (isExpired) return 'Expired';
    if (isActive) return 'Live & Approved';
    if (isPending) return 'Pending Approval';
    return status;
  }

  int? get daysRemaining {
    if (endDate == null) return null;
    final diff = endDate!.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }
}
