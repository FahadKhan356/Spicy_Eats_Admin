import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/reviews/repo/ReviewsRepo.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  static const String routename = '/Reviews';

  const ReviewsScreen({super.key});

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  int _categoryIndex = 0; // 0: All, 1: Restaurant, 2: Dishes
  int? _starFilter; // null = all stars, 1-5 = specific star
  bool _unansweredOnly = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantProvider);
    final restUid = restaurant?.restuid;

    if (restUid == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    final reviewsAsync = ref.watch(allReviewsProvider(restUid));

    return Scaffold(
      backgroundColor: MyAppColor.primaryBg,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allReviewsProvider(restUid));
          ref.invalidate(reviewsProvider(restUid));
          ref.invalidate(dishReviewsProvider(restUid));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          children: [
            _Header(
              restaurantName: restaurant?.restaurantName ?? 'Restaurant',
            ),
            const SizedBox(height: 20),
            reviewsAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              ),
              error: (err, _) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Text(
                  'Error loading reviews: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              data: (allReviews) {
                // Filter reviews according to selections
                final filtered = allReviews.where((r) {
                  if (_categoryIndex == 1 && r.isDishReview) return false;
                  if (_categoryIndex == 2 && !r.isDishReview) return false;
                  if (_starFilter != null && r.rating != _starFilter) return false;
                  if (_unansweredOnly && (r.reply != null && r.reply!.isNotEmpty)) {
                    return false;
                  }
                  if (_searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    final matchBody = (r.body ?? '').toLowerCase().contains(query);
                    final matchReviewer = r.reviewer.toLowerCase().contains(query);
                    final matchDish = (r.dishName ?? '').toLowerCase().contains(query);
                    if (!matchBody && !matchReviewer && !matchDish) return false;
                  }
                  return true;
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AnalyticsSummary(reviews: allReviews),
                    const SizedBox(height: 20),
                    _FilterBar(
                      totalCount: allReviews.length,
                      restaurantCount:
                          allReviews.where((r) => !r.isDishReview).length,
                      dishCount:
                          allReviews.where((r) => r.isDishReview).length,
                      selectedIndex: _categoryIndex,
                      onCategoryChanged: (idx) =>
                          setState(() => _categoryIndex = idx),
                      starFilter: _starFilter,
                      onStarFilterChanged: (star) =>
                          setState(() => _starFilter = star),
                      unansweredOnly: _unansweredOnly,
                      onUnansweredChanged: (val) =>
                          setState(() => _unansweredOnly = val),
                      searchController: _searchController,
                      onSearchChanged: (query) =>
                          setState(() => _searchQuery = query),
                    ),
                    const SizedBox(height: 16),
                    if (filtered.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rate_review_outlined,
                                size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'No reviews found',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _searchQuery.isNotEmpty || _starFilter != null
                                  ? 'Try adjusting your search or filters'
                                  : 'Reviews from customers will appear here.',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          return _ReviewCard(
                            review: filtered[idx],
                            restUid: restUid,
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String restaurantName;

  const _Header({required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews & Ratings',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'All reviews and dish ratings for $restaurantName',
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
}

class _AnalyticsSummary extends StatelessWidget {
  final List<ReviewModel> reviews;

  const _AnalyticsSummary({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final total = reviews.length;
    final avg = total == 0
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / total;

    final starsCount = List.generate(5, (i) {
      final star = 5 - i;
      return reviews.where((r) => r.rating == star).length;
    });

    final pendingReplies =
        reviews.where((r) => r.reply == null || r.reply!.isEmpty).length;

    final isDesktop = Responsive.isDesktop(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: _AverageScoreCard(avg: avg, total: total)),
                const SizedBox(width: 24),
                Container(width: 1, height: 110, color: Colors.grey.shade200),
                const SizedBox(width: 24),
                Expanded(
                  flex: 5,
                  child: _StarDistributionBars(
                    starsCount: starsCount,
                    total: total,
                  ),
                ),
                const SizedBox(width: 24),
                Container(width: 1, height: 110, color: Colors.grey.shade200),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: _PendingRepliesCard(pending: pendingReplies, total: total),
                ),
              ],
            )
          : Column(
              children: [
                _AverageScoreCard(avg: avg, total: total),
                const Divider(height: 32),
                _StarDistributionBars(starsCount: starsCount, total: total),
                const Divider(height: 32),
                _PendingRepliesCard(pending: pendingReplies, total: total),
              ],
            ),
    );
  }
}

class _AverageScoreCard extends StatelessWidget {
  final double avg;
  final int total;

  const _AverageScoreCard({required this.avg, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overall Rating',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              avg.toStringAsFixed(1),
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 6),
            const Text(
              '/ 5.0',
              style: TextStyle(fontSize: 16, color: Colors.black45, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            ...List.generate(5, (i) {
              final val = i + 1;
              return Icon(
                Icons.star,
                size: 16,
                color: val <= avg.round() ? Colors.amber : Colors.grey.shade300,
              );
            }),
            const SizedBox(width: 8),
            Text(
              '($total ${total == 1 ? 'review' : 'reviews'})',
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}

class _StarDistributionBars extends StatelessWidget {
  final List<int> starsCount;
  final int total;

  const _StarDistributionBars({required this.starsCount, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (i) {
        final starNumber = 5 - i;
        final count = starsCount[i];
        final fraction = total == 0 ? 0.0 : count / total;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '$starNumber ★',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      starNumber >= 4
                          ? Colors.green
                          : starNumber == 3
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 24,
                child: Text(
                  '$count',
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _PendingRepliesCard extends StatelessWidget {
  final int pending;
  final int total;

  const _PendingRepliesCard({required this.pending, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Response Status',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pending > 0
                    ? Colors.orange.shade50
                    : Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                pending > 0 ? Icons.mark_email_unread_outlined : Icons.check_circle_outline,
                size: 20,
                color: pending > 0 ? Colors.orange.shade800 : Colors.green.shade800,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pending awaiting reply',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: pending > 0 ? Colors.orange.shade900 : Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${total - pending} answered',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  final int totalCount;
  final int restaurantCount;
  final int dishCount;
  final int selectedIndex;
  final ValueChanged<int> onCategoryChanged;
  final int? starFilter;
  final ValueChanged<int?> onStarFilterChanged;
  final bool unansweredOnly;
  final ValueChanged<bool> onUnansweredChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const _FilterBar({
    required this.totalCount,
    required this.restaurantCount,
    required this.dishCount,
    required this.selectedIndex,
    required this.onCategoryChanged,
    required this.starFilter,
    required this.onStarFilterChanged,
    required this.unansweredOnly,
    required this.onUnansweredChanged,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Category selector
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Pill(
                  label: 'All ($totalCount)',
                  isSelected: selectedIndex == 0,
                  onTap: () => onCategoryChanged(0),
                ),
                _Pill(
                  label: 'Restaurant ($restaurantCount)',
                  isSelected: selectedIndex == 1,
                  onTap: () => onCategoryChanged(1),
                ),
                _Pill(
                  label: 'Dishes ($dishCount)',
                  isSelected: selectedIndex == 2,
                  onTap: () => onCategoryChanged(2),
                ),
              ],
            ),
          ),

          // Star ratings filter
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Stars: ',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
              DropdownButton<int?>(
                value: starFilter,
                underline: const SizedBox(),
                isDense: true,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Stars')),
                  DropdownMenuItem(value: 5, child: Text('5 ★ only')),
                  DropdownMenuItem(value: 4, child: Text('4 ★ only')),
                  DropdownMenuItem(value: 3, child: Text('3 ★ only')),
                  DropdownMenuItem(value: 2, child: Text('2 ★ only')),
                  DropdownMenuItem(value: 1, child: Text('1 ★ only')),
                ],
                onChanged: onStarFilterChanged,
              ),
            ],
          ),

          // Unanswered filter chip
          FilterChip(
            label: const Text('Unanswered Only'),
            selected: unansweredOnly,
            onSelected: onUnansweredChanged,
            selectedColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: unansweredOnly ? Colors.white : Colors.black87,
            ),
            checkmarkColor: Colors.white,
            backgroundColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide.none,
          ),

          // Search field
          SizedBox(
            width: 220,
            height: 36,
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Search reviews or dishes...',
                hintStyle:
                    TextStyle(fontSize: 11, color: Colors.grey.shade400),
                prefixIcon:
                    const Icon(Icons.search, size: 16, color: Colors.black45),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 14),
                        onPressed: () {
                          searchController.clear();
                          onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends ConsumerStatefulWidget {
  final ReviewModel review;
  final String restUid;

  const _ReviewCard({required this.review, required this.restUid});

  @override
  ConsumerState<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends ConsumerState<_ReviewCard> {
  bool _isReplying = false;
  bool _isSubmitting = false;
  late final TextEditingController _replyController;

  @override
  void initState() {
    super.initState();
    _replyController =
        TextEditingController(text: widget.review.reply ?? '');
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
        ref.invalidate(allReviewsProvider(widget.restUid));
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

    final initial = review.reviewer.isNotEmpty
        ? review.reviewer[0].toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: tone.withValues(alpha: 0.12),
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: tone,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.reviewer,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (review.isDishReview)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: MyAppColor.primaryBg,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: const Text(
                              'Dish Review',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: MyAppColor.orangePrimary),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _relative(review.createdAt),
                      style:
                          const TextStyle(fontSize: 11, color: Colors.black38),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 13, color: tone),
                    const SizedBox(width: 3),
                    Text(
                      '${review.rating}.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: tone,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.dishName != null && review.dishName!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fastfood_outlined,
                      size: 13, color: MyAppColor.orangePrimary),
                  const SizedBox(width: 6),
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
          ],
          if ((review.body ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.body!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.45,
              ),
            ),
          ],
          if ((review.reply ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9FB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.reply, size: 14, color: Colors.black54),
                      const SizedBox(width: 6),
                      const Text(
                        'Your response to customer',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => setState(() => _isReplying = true),
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 11, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.reply!,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ] else if (!_isReplying) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() => _isReplying = true),
                icon: const Icon(Icons.reply, size: 14, color: Colors.black87),
                label: const Text(
                  'Reply to customer',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ],
          if (_isReplying) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _replyController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'Type your official response to this review...',
                      hintStyle:
                          TextStyle(fontSize: 12, color: Colors.black38),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => setState(() => _isReplying = false),
                        child: const Text('Cancel',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Post response',
                                style: TextStyle(
                                  fontSize: 12,
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
