enum PromotionKind { percent, fixed, freeDelivery, bogo, combo }

enum PromotionState { live, scheduled, expired, inactive }

class PromotionModel {
  final int id;
  final String title;
  final String? description;
  final String kind;
  final double value;
  final double minOrder;
  final double? maxDiscount;
  final String? code;
  final DateTime startsAt;
  final DateTime? endsAt;
  final int? usageLimit;
  final int usedCount;
  final bool isActive;

  const PromotionModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.value,
    required this.minOrder,
    required this.startsAt,
    required this.usedCount,
    required this.isActive,
    this.description,
    this.maxDiscount,
    this.code,
    this.endsAt,
    this.usageLimit,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      kind: (json['kind'] ?? 'percent').toString(),
      value: (json['value'] as num?)?.toDouble() ?? 0,
      minOrder: (json['min_order'] as num?)?.toDouble() ?? 0,
      maxDiscount: (json['max_discount'] as num?)?.toDouble(),
      code: json['code']?.toString(),
      startsAt:
          DateTime.tryParse((json['starts_at'] ?? '').toString()) ?? DateTime.now(),
      endsAt: DateTime.tryParse((json['ends_at'] ?? '')?.toString() ?? ''),
      usageLimit: (json['usage_limit'] as num?)?.toInt(),
      usedCount: (json['used_count'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }

  PromotionState get state {
    if (!isActive) return PromotionState.inactive;
    final now = DateTime.now();
    if (now.isBefore(startsAt)) return PromotionState.scheduled;
    if (endsAt != null && now.isAfter(endsAt!)) return PromotionState.expired;
    return PromotionState.live;
  }

  bool get isLive => state == PromotionState.live;

  int? get daysRemaining {
    if (endsAt == null) return null;
    final diff = endsAt!.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  double get usagePercent {
    if (usageLimit == null || usageLimit == 0) return 0;
    return (usedCount / usageLimit!).clamp(0, 1);
  }

  String get kindLabel => switch (kind) {
        'percent' => 'Percent off',
        'fixed' => 'Flat off',
        'free_delivery' => 'Free delivery',
        'bogo' => 'Buy 2 get 1',
        _ => 'Combo',
      };

  String get offerLabel => switch (kind) {
        'percent' => '${value.toStringAsFixed(0)}% OFF',
        'fixed' => 'Rs ${value.toStringAsFixed(0)} OFF',
        'free_delivery' => 'FREE DELIVERY',
        'bogo' => 'BUY 2 GET 1',
        _ => 'COMBO DEAL',
      };

  String get stateLabel => switch (state) {
        PromotionState.live => 'Live',
        PromotionState.scheduled => 'Scheduled',
        PromotionState.expired => 'Expired',
        PromotionState.inactive => 'Paused',
      };
}
