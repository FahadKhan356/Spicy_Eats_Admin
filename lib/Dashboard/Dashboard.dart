import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/orders/model/OrderModel.dart';
import 'package:spicy_eats_admin/orders/repo/OrdersRepo.dart';
import 'package:spicy_eats_admin/reviews/repo/ReviewsRepo.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class Dashboard extends ConsumerWidget {
  static const String routename = '/Dashboard';

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurant = ref.watch(restaurantProvider);
    final restUid = restaurant?.restuid;

    if (restUid == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final statsAsync = ref.watch(dashboardStatsProvider(restUid));

    return Scaffold(
      backgroundColor: MyAppColor.primaryBg,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(dashboardStatsProvider(restUid).future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            _Greeting(name: restaurant?.restaurantName ?? 'there'),
            const SizedBox(height: 20),
            statsAsync.when(
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => _ErrorCard(message: '$error'),
              data: (stats) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StatGrid(stats: stats),
                  const SizedBox(height: 16),
                  _OrdersChart(orders: ref.watch(ordersProvider(restUid)).value ?? const []),
                  const SizedBox(height: 16),
                  _RecentOrders(orders: ref.watch(ordersProvider(restUid)).value ?? const []),
                  const SizedBox(height: 16),
                  _ReviewsPanel(restUid: restUid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final String name;

  const _Greeting({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
}

class _StatGrid extends StatelessWidget {
  final DashboardStats stats;

  const _StatGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatCard(
        label: 'Total revenue',
        value: 'Rs ${stats.totalRevenue.toStringAsFixed(0)}',
        icon: Icons.payments_outlined,
      ),
      _StatCard(
        label: 'Total orders',
        value: '${stats.totalOrders}',
        icon: Icons.receipt_long_outlined,
      ),
      _StatCard(
        label: 'Active orders',
        value: '${stats.activeOrders}',
        icon: Icons.pending_actions_outlined,
      ),
      _StatCard(
        label: 'Delivered',
        value: '${stats.deliveredOrders}',
        icon: Icons.check_circle_outline,
      ),
      _StatCard(
        label: 'Cancelled',
        value: '${stats.cancelledOrders}',
        icon: Icons.cancel_outlined,
      ),
      _StatCard(
        label: 'Rating',
        value: stats.totalRatings == 0
            ? 'No reviews'
            : '${stats.averageRating.toStringAsFixed(1)} (${stats.totalRatings})',
        icon: Icons.star_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.isDesktop(context)
            ? 3
            : Responsive.isTablet(context)
                ? 2
                : 1;
        final spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final card in cards) SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersChart extends StatelessWidget {
  final List<OrderModel> orders;

  const _OrdersChart({required this.orders});

  @override
  Widget build(BuildContext context) {
    final days = _lastSevenDays(orders);

    return _Panel(
      title: 'Orders, last 7 days',
      child: orders.isEmpty
          ? const _EmptyNote(text: 'No orders in the last 7 days.')
          : SizedBox(
              height: 190,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (days.map((d) => d.$2).reduce((a, b) => a > b ? a : b) + 2)
                      .toDouble(),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                        '${rod.toY.toInt()} orders',
                        const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= days.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[index].$1,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < days.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: days[i].$2.toDouble(),
                            color: Colors.black,
                            width: 22,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  List<(String, int)> _lastSevenDays(List<OrderModel> orders) {
    final now = DateTime.now();
    final result = <(String, int)>[];
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (var offset = 6; offset >= 0; offset--) {
      final day = DateTime(now.year, now.month, now.day).subtract(
        Duration(days: offset),
      );
      final count = orders.where((order) {
        final created = order.createdAt.toLocal();
        return created.year == day.year &&
            created.month == day.month &&
            created.day == day.day;
      }).length;
      result.add((labels[day.weekday - 1], count));
    }
    return result;
  }
}

class _RecentOrders extends StatelessWidget {
  final List<OrderModel> orders;

  const _RecentOrders({required this.orders});

  @override
  Widget build(BuildContext context) {
    final recent = orders.take(5).toList();

    return _Panel(
      title: 'Recent orders',
      child: recent.isEmpty
          ? const _EmptyNote(text: 'No orders yet.')
          : Column(
              children: [
                for (final order in recent)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order #${order.id}',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '${order.itemCount} items',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Rs ${(order.totalPrice ?? 0).toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ReviewsPanel extends ConsumerStatefulWidget {
  final String restUid;

  const _ReviewsPanel({required this.restUid});

  @override
  ConsumerState<_ReviewsPanel> createState() => _ReviewsPanelState();
}

class _ReviewsPanelState extends ConsumerState<_ReviewsPanel> {
  int _selectedTab = 0; // 0: Restaurant Reviews, 1: Dish Reviews

  @override
  Widget build(BuildContext context) {
    final isDishTab = _selectedTab == 1;
    final reviewsAsync = ref.watch(
        isDishTab ? dishReviewsProvider(widget.restUid) : reviewsProvider(widget.restUid));

    return _Panel(
      title: 'Customer reviews & ratings',
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TabButton(
              label: 'Restaurant',
              icon: Icons.storefront_outlined,
              isSelected: _selectedTab == 0,
              onTap: () => setState(() => _selectedTab = 0),
            ),
            _TabButton(
              label: 'Dishes',
              icon: Icons.fastfood_outlined,
              isSelected: _selectedTab == 1,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ],
        ),
      ),
      child: reviewsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (err, _) => _EmptyNote(
          text: 'Error loading reviews: $err',
        ),
        data: (reviews) => reviews.isEmpty
            ? _EmptyNote(
                text: isDishTab
                    ? 'No dish ratings or reviews yet.'
                    : 'No restaurant reviews yet.',
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final review in reviews)
                    _ReviewRow(
                      review: review,
                      restUid: widget.restUid,
                    ),
                ],
              ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.black : Colors.black45,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.black : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends ConsumerStatefulWidget {
  final ReviewModel review;
  final String restUid;

  const _ReviewRow({required this.review, required this.restUid});

  @override
  ConsumerState<_ReviewRow> createState() => _ReviewRowState();
}

class _ReviewRowState extends ConsumerState<_ReviewRow> {
  bool _isReplying = false;
  bool _isSubmitting = false;
  late final TextEditingController _replyController;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _submitReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);
    final success = await ref.read(reviewsRepoProvider).replyToReview(
          reviewId: widget.review.id,
          reply: text,
          isDishReview: widget.review.isDishReview,
        );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        if (success) {
          _isReplying = false;
        }
      });
      if (success) {
        ref.invalidate(reviewsProvider(widget.restUid));
        ref.invalidate(dishReviewsProvider(widget.restUid));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final tone = review.rating >= 4
        ? Colors.green
        : review.rating == 3
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (review.dishName != null && review.dishName!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: MyAppColor.primaryBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.fastfood_outlined,
                    size: 11,
                    color: MyAppColor.orangePrimary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    review.dishName!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Text(
                review.reviewer,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 10, color: tone),
                    const SizedBox(width: 2),
                    Text(
                      '${review.rating}/5',
                      style: TextStyle(
                        fontSize: 10,
                        color: tone,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                _relative(review.createdAt),
                style: const TextStyle(fontSize: 10, color: Colors.black38),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if ((review.body ?? '').isNotEmpty)
            Text(
              review.body!,
              style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
            ),
          if ((review.reply ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9FB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.reply, size: 13, color: Colors.black45),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your response:',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          review.reply!,
                          style: const TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else if (!_isReplying) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() => _isReplying = true),
                icon: const Icon(Icons.reply, size: 12, color: Colors.black54),
                label: const Text(
                  'Reply',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
          if (_isReplying) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _replyController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'Type your response to the customer...',
                      hintStyle: TextStyle(fontSize: 11, color: Colors.black38),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => setState(() => _isReplying = false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Post reply',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _relative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Panel({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  final String text;

  const _EmptyNote({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black45)),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Could not load dashboard data',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(message, style: const TextStyle(fontSize: 11, color: Colors.black87)),
        ],
      ),
    );
  }
}
