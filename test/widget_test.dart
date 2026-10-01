import 'package:flutter_test/flutter_test.dart';
import 'package:spicy_eats_admin/orders/model/OrderModel.dart';
import 'package:spicy_eats_admin/utils/list.dart';

void main() {
  group('OrderModel', () {
    test('parses numeric total_price from a double column', () {
      final order = OrderModel.fromJson({
        'id': 29,
        'created_at': '2026-04-02T13:56:10.818465+00:00',
        'status': 'pending',
        'total_price': 16.55,
        'payType': 'Cash on Delivery',
        'deliveredTo': 'Fahad  ali khan',
        'orderedItems': [
          {
            'dish_id': 25,
            'name': 'Smoky BBQ Bacon Burger',
            'quantity': 2,
            'itemprice': 5.65,
            'tprice': 11.3,
          }
        ],
      });

      expect(order.id, 29);
      expect(order.status, 'pending');
      expect(order.totalPrice, 16.55);
      expect(order.items, hasLength(1));
      expect(order.items.first.name, 'Smoky BBQ Bacon Burger');
      expect(order.itemCount, 2);
    });

    test('parses orderedItems stored as a JSON string', () {
      final order = OrderModel.fromJson({
        'id': 1,
        'created_at': '2025-08-29T22:01:30.090568+00:00',
        'status': 'completed',
        'orderedItems':
            '[{"name":"Double Baik","quantity":3,"itemprice":6.0,"tprice":18.0}]',
      });

      expect(order.items, hasLength(1));
      expect(order.itemCount, 3);
      expect(order.totalPrice, isNull);
    });

    test('tolerates a null status and empty items', () {
      final order = OrderModel.fromJson({
        'id': 26,
        'created_at': '2026-03-31T00:00:00+00:00',
      });

      expect(order.status, 'unknown');
      expect(order.items, isEmpty);
      expect(order.itemCount, 0);
    });
  });

  group('navigation config', () {
    test('every route is unique', () {
      final routes = navItems.map((item) => item.route).toList();
      expect(routes.toSet().length, routes.length);
    });

    test('all four primary destinations are declared', () {
      expect(navItems.length, 4);
      expect(navItems.first.route, '/Dashboard');
    });
  });
}
