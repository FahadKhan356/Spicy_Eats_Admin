import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/orders/model/OrderModel.dart';
import 'package:spicy_eats_admin/orders/repo/OrdersRepo.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  static const String routename = '/orders';

  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantProvider);
    final restUid = restaurant?.restuid;

    if (restUid == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final ordersAsync = ref.watch(ordersProvider(restUid));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(message: '$error'),
        data: (orders) {
          final filtered = _applyFilter(orders);
          return RefreshIndicator(
            onRefresh: () => ref.refresh(ordersProvider(restUid).future),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  restaurantName: restaurant?.restaurantName ?? '',
                  orders: orders,
                  filter: _filter,
                  onFilterChanged: (value) => setState(() => _filter = value),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 120),
                            _EmptyView(),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) => _OrderCard(
                            order: filtered[index],
                            onStatusChange: (status) =>
                                _changeStatus(filtered[index], status),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<OrderModel> _applyFilter(List<OrderModel> orders) {
    switch (_filter) {
      case 'active':
        return orders
            .where((o) => o.status == 'pending' || o.status == 'preparing')
            .toList();
      case 'delivered':
        return orders.where((o) => o.status == 'delivered').toList();
      case 'cancelled':
        return orders.where((o) => o.status == 'cancelled').toList();
      default:
        return orders;
    }
  }

  Future<void> _changeStatus(OrderModel order, String status) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    try {
      await ref.read(ordersRepoProvider).updateStatus(
            orderId: order.id,
            status: status,
          );
      ref.invalidate(ordersProvider(restUid));
      ref.invalidate(dashboardStatsProvider(restUid));
      if (!mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Order #${order.id} marked $status',
        backgroundColor: Colors.black,
      );
    } catch (e) {
      if (!mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not update order. Run the orders RLS migration.',
        backgroundColor: Colors.red,
      );
    }
  }
}

class _Header extends StatelessWidget {
  final String restaurantName;
  final List<OrderModel> orders;
  final String filter;
  final ValueChanged<String> onFilterChanged;

  const _Header({
    required this.restaurantName,
    required this.orders,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final active =
        orders.where((o) => o.status == 'pending' || o.status == 'preparing').length;
    final revenue = orders
        .where((o) => o.status != 'cancelled' && o.status != 'rejected')
        .fold<double>(0, (sum, o) => sum + (o.totalPrice ?? 0));

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Orders',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            restaurantName,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Metric(label: 'Total orders', value: '${orders.length}'),
              _Metric(label: 'Active', value: '$active'),
              _Metric(label: 'Revenue', value: 'Rs ${revenue.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: [
              for (final entry in const [
                ('all', 'All'),
                ('active', 'Active'),
                ('delivered', 'Delivered'),
                ('cancelled', 'Cancelled'),
              ])
                ChoiceChip(
                  label: Text(entry.$2),
                  selected: filter == entry.$1,
                  showCheckmark: false,
                  selectedColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: filter == entry.$1 ? Colors.white : Colors.black,
                  ),
                  onSelected: (_) => onFilterChanged(entry.$1),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final ValueChanged<String> onStatusChange;

  const _OrderCard({required this.order, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        leading: _StatusDot(status: order.status),
        title: Text(
          'Order #${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${_formatDate(order.createdAt)}  •  ${order.itemCount} items  •  Rs ${(order.totalPrice ?? 0).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        trailing: _StatusChip(status: order.status),
        children: [
          if (order.deliveredTo.trim().isNotEmpty)
            _Row(
              icon: Icons.person_outline,
              text: 'Deliver to: ${order.deliveredTo.trim()}',
            ),
          if (order.payType.trim().isNotEmpty)
            _Row(icon: Icons.payments_outlined, text: order.payType.trim()),
          const SizedBox(height: 8),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: item.image == null || item.image!.isEmpty
                          ? Container(
                              width: 34,
                              height: 34,
                              color: Colors.grey[200],
                              child: const Icon(Icons.fastfood, size: 18),
                            )
                          : Image.network(
                              item.image!,
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 34,
                                height: 34,
                                color: Colors.grey[200],
                                child: const Icon(Icons.fastfood, size: 18),
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${item.quantity} x Rs ${item.unitPrice.toStringAsFixed(2)} = Rs ${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          const Divider(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Update status',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final status in orderStatusFlow)
                if (order.status != status)
                  OutlinedButton(
                    onPressed: () => onStatusChange(status),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(
                        color: status == 'cancelled' ? Colors.red : Colors.black,
                      ),
                    ),
                    child: Text(
                      orderStatusLabels[status] ?? status,
                      style: TextStyle(
                        fontSize: 12,
                        color: status == 'cancelled' ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Row({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black45),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        orderStatusLabels[status] ?? status,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final String status;

  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: _colorFor(status), shape: BoxShape.circle),
    );
  }
}

Color _colorFor(String status) {
  switch (status) {
    case 'delivered':
    case 'completed':
      return Colors.green;
    case 'cancelled':
    case 'rejected':
      return Colors.red;
    case 'preparing':
      return Colors.orange;
    default:
      return Colors.blueGrey;
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.receipt_long_outlined, size: 48, color: Colors.black26),
        SizedBox(height: 12),
        Text(
          'No orders yet',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          'Orders placed for your restaurant will appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Could not load orders',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
