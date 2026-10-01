import 'dart:convert';

class OrderLine {
  final int? dishId;
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? image;
  final String? description;

  const OrderLine({
    this.dishId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.image,
    this.description,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      dishId: json['dish_id'] as int?,
      name: (json['name'] ?? 'Item').toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['itemprice'] as num?)?.toDouble() ??
          (json['tprice'] as num?)?.toDouble() ??
          0,
      totalPrice: (json['tprice'] as num?)?.toDouble() ?? 0,
      image: json['image']?.toString(),
      description: json['description']?.toString(),
    );
  }
}

class OrderModel {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String status;
  final String? cancelledReason;
  final double? totalPrice;
  final String payType;
  final String deliveredTo;
  final List<OrderLine> items;

  const OrderModel({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.payType,
    required this.deliveredTo,
    required this.items,
    this.totalPrice,
    this.updatedAt,
    this.cancelledReason,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: (json['id'] as num).toInt(),
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
              DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      status: (json['status'] ?? 'unknown').toString(),
      cancelledReason: (json['cancelled_reason'] ?? json['cancel_reason'])
          ?.toString(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      payType: (json['payType'] ?? '').toString(),
      deliveredTo: (json['deliveredTo'] ?? '').toString(),
      items: _parseItems(json['orderedItems']),
    );
  }

  static List<OrderLine> _parseItems(dynamic raw) {
    dynamic decoded = raw;
    if (decoded is String) {
      if (decoded.trim().isEmpty) return const [];
      try {
        decoded = jsonDecode(decoded);
      } catch (_) {
        return const [];
      }
    }
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((item) => OrderLine.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

const orderStatusFlow = <String>[
  'pending',
  'accepted',
  'preparing',
  'ready',
  'out_for_delivery',
  'delivered',
  'cancelled',
  'completed',
  'rejected',
];

const orderStatusLabels = <String, String>{
  'pending': 'Pending',
  'accepted': 'Accepted',
  'preparing': 'Preparing',
  'ready': 'Ready',
  'out_for_delivery': 'Out for delivery',
  'delivered': 'Delivered',
  'cancelled': 'Cancelled',
  'completed': 'Completed',
  'rejected': 'Rejected',
};
