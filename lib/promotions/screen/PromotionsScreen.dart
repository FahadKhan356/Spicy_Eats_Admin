import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/Authentication/utils/comon_image_picker.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/promotions/model/BannerPromotionModel.dart';
import 'package:spicy_eats_admin/promotions/model/PromotionModel.dart';
import 'package:spicy_eats_admin/promotions/repo/BannerPromotionsRepo.dart';
import 'package:spicy_eats_admin/promotions/repo/PromotionsRepo.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class PromotionsScreen extends ConsumerStatefulWidget {
  static const String routename = '/promotions';

  const PromotionsScreen({super.key});

  @override
  ConsumerState<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends ConsumerState<PromotionsScreen> {
  int _activeTabIndex = 0; // 0: Discounts, 1: Banners
  bool _loading = true;
  String? _discountsError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  Future<void> _loadAll() async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    setState(() {
      _loading = true;
      _discountsError = null;
    });

    try {
      await Future.wait([
        ref.read(promotionsControllerProvider.notifier).load(restUid).catchError((e) {
          if (mounted) setState(() => _discountsError = '$e');
        }),
        ref.read(bannerPromotionsControllerProvider.notifier).load(restUid).catchError((_) {}),
      ]);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantProvider);

    return Scaffold(
      backgroundColor: MyAppColor.primaryBg,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  _Header(
                    restaurantName: restaurant?.restaurantName ?? '',
                  ),
                  const SizedBox(height: 16),
                  _TabSelector(
                    selectedIndex: _activeTabIndex,
                    onSelected: (index) => setState(() => _activeTabIndex = index),
                  ),
                  const SizedBox(height: 20),
                  if (_activeTabIndex == 0)
                    _DiscountsTabView(
                      error: _discountsError,
                      onRefresh: _loadAll,
                    )
                  else
                    const _BannersTabView(),
                ],
              ),
            ),
    );
  }
}

// =============================================================================
// HEADER & TAB SELECTOR
// =============================================================================

class _Header extends StatelessWidget {
  final String restaurantName;

  const _Header({required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promotions & Marketing',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          restaurantName.isNotEmpty ? restaurantName : 'Manage coupons, offers and sponsored banners',
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
}

class _TabSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TabSelector({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: '🏷️ Discounts & Coupons',
              isSelected: selectedIndex == 0,
              onTap: () => onSelected(0),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _TabButton(
              title: '🖼️ Banner Ads',
              isSelected: selectedIndex == 1,
              onTap: () => onSelected(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// TAB 1: DISCOUNTS & COUPONS
// =============================================================================

class _DiscountsTabView extends ConsumerWidget {
  final String? error;
  final Future<void> Function() onRefresh;

  const _DiscountsTabView({required this.error, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(promotionsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            _FilterRow(
              active: state.filter,
              counts: {
                'All': state.all.length,
                'Live': state.all.where((p) => p.state == PromotionState.live).length,
                'Scheduled': state.all.where((p) => p.state == PromotionState.scheduled).length,
                'Paused': state.all.where((p) => p.state == PromotionState.inactive).length,
                'Expired': state.all.where((p) => p.state == PromotionState.expired).length,
              },
              onChanged: (v) => ref.read(promotionsControllerProvider.notifier).setFilter(v),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Pill(label: '${state.liveCount} live'),
                const SizedBox(width: 8),
                _Pill(label: '${state.totalRedemptions} used'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (error != null)
          _MigrationNoticeCard(message: error!)
        else if (state.visible.isEmpty)
          const _EmptyDiscountsView()
        else
          ...state.visible.map((promotion) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PromotionCard(
                  promotion: promotion,
                  onToggle: () => _toggle(context, ref, promotion),
                  onDelete: () => _confirmDelete(context, ref, promotion),
                ),
              )),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _openCreateSheet(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Create Discount Promotion'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, PromotionModel promotion) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    try {
      await ref.read(promotionsControllerProvider.notifier).toggle(promotion, restUid);
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: promotion.isActive ? '${promotion.title} paused' : '${promotion.title} is now live',
        backgroundColor: Colors.black,
      );
    } catch (e) {
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not update promotion: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, PromotionModel promotion) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete ${promotion.title}?'),
        content: const Text('This removes the promotion for all customers immediately.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(promotionsControllerProvider.notifier).remove(promotion.id, restUid);
    } catch (e) {
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not delete promotion: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _openCreateSheet(BuildContext context, WidgetRef ref) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    final result = await showModalBottomSheet<_PromotionDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _CreatePromotionSheet(),
    );

    if (result == null || !context.mounted) return;

    try {
      await ref.read(promotionsControllerProvider.notifier).create(
            restUid: restUid,
            title: result.title,
            description: result.description,
            kind: result.kind,
            value: result.value,
            minOrder: result.minOrder,
            maxDiscount: result.maxDiscount,
            code: result.code,
            durationDays: result.durationDays,
          );
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Promotion created successfully',
        backgroundColor: Colors.black,
      );
    } catch (e) {
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not create promotion: $e',
        backgroundColor: Colors.red,
      );
    }
  }
}

// =============================================================================
// TAB 2: BANNER ADS
// =============================================================================

class _BannersTabView extends ConsumerWidget {
  const _BannersTabView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bannerPromotionsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            _FilterRow(
              active: state.filter,
              counts: {
                'All': state.all.length,
                'Pending': state.all.where((b) => b.isPending).length,
                'Live': state.all.where((b) => b.isActive).length,
                'Rejected': state.all.where((b) => b.isRejected).length,
                'Expired': state.all.where((b) => b.isExpired).length,
              },
              onChanged: (v) => ref.read(bannerPromotionsControllerProvider.notifier).setFilter(v),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Pill(label: '${state.liveCount} live'),
                const SizedBox(width: 8),
                _Pill(label: '${state.pendingCount} pending'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (state.error != null)
          _BannerErrorCard(message: state.error!)
        else if (state.visible.isEmpty)
          const _EmptyBannersView()
        else
          ...state.visible.map((slot) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _BannerSlotCard(
                  slot: slot,
                  onApprove: () => _updateBannerStatus(context, ref, slot, 'approved'),
                  onPause: () => _updateBannerStatus(context, ref, slot, 'pending'),
                  onDelete: () => _confirmDeleteBanner(context, ref, slot),
                ),
              )),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _openRequestBannerSheet(context, ref, state.positions),
          icon: const Icon(Icons.campaign_outlined, size: 18),
          label: const Text('Request New Banner Slot'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Future<void> _updateBannerStatus(
    BuildContext context,
    WidgetRef ref,
    BannerSlotModel slot,
    String newStatus,
  ) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    try {
      await ref.read(bannerPromotionsControllerProvider.notifier).setStatus(
            slot.id,
            newStatus,
            restUid,
          );
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: newStatus == 'approved'
            ? '${slot.bannerTitle} is now LIVE on customer app!'
            : '${slot.bannerTitle} is now paused (Pending)',
        backgroundColor: Colors.black,
      );
    } catch (e) {
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not update status: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _confirmDeleteBanner(BuildContext context, WidgetRef ref, BannerSlotModel slot) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Cancel ${slot.bannerTitle}?'),
        content: const Text('This will cancel your banner slot request.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Back'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Request'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(bannerPromotionsControllerProvider.notifier).remove(slot.id, restUid);
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Banner slot request cancelled',
        backgroundColor: Colors.black,
      );
    } catch (e) {
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not cancel banner: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _openRequestBannerSheet(
    BuildContext context,
    WidgetRef ref,
    List<BannerPositionModel> positions,
  ) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    final result = await showModalBottomSheet<_BannerDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _RequestBannerSheet(positions: positions),
    );

    if (result == null || !context.mounted) return;

    try {
      await ref.read(bannerPromotionsControllerProvider.notifier).requestBanner(
            restUid: restUid,
            positionId: result.positionId,
            bannerTitle: result.title,
            redirectUrl: result.redirectUrl,
            startDate: result.startDate,
            endDate: result.endDate,
            price: result.price,
            imageBytes: result.imageBytes,
          );
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Banner requested successfully! Pending admin approval.',
        backgroundColor: Colors.black,
      );
    } catch (e) {
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Failed to request banner: $e',
        backgroundColor: Colors.red,
      );
    }
  }
}

// =============================================================================
// BANNER SLOT CARD
// =============================================================================

class _BannerSlotCard extends StatelessWidget {
  final BannerSlotModel slot;
  final VoidCallback onApprove;
  final VoidCallback onPause;
  final VoidCallback onDelete;

  const _BannerSlotCard({
    required this.slot,
    required this.onApprove,
    required this.onPause,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = slot.isActive
        ? Colors.green
        : slot.isPending
            ? Colors.orange
            : slot.isRejected
                ? Colors.red
                : Colors.grey;

    final dateRangeStr = (slot.startDate != null && slot.endDate != null)
        ? '${slot.startDate!.day}/${slot.startDate!.month} - ${slot.endDate!.day}/${slot.endDate!.month}'
        : 'Open schedule';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (slot.bannerImageUrl.isNotEmpty)
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 6,
                  child: Image.network(
                    slot.bannerImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined, size: 36, color: Colors.black38),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      slot.statusLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slot.bannerTitle,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            slot.positionName ?? 'Featured Ad Placement',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'approve') onApprove();
                        if (v == 'pause') onPause();
                        if (v == 'delete') onDelete();
                      },
                      itemBuilder: (_) => [
                        if (slot.isPending)
                          const PopupMenuItem(
                            value: 'approve',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                                SizedBox(width: 8),
                                Text('Make Live (Approve)', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        if (slot.isActive)
                          const PopupMenuItem(
                            value: 'pause',
                            child: Row(
                              children: [
                                Icon(Icons.pause_circle_outline, color: Colors.orange, size: 16),
                                SizedBox(width: 8),
                                Text('Pause / Set Pending'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(value: 'delete', child: Text('Cancel/Remove')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag(text: 'Dates: $dateRangeStr'),
                    _Tag(text: 'Rs ${slot.price.toStringAsFixed(0)}', highlight: true),
                    if (slot.redirectUrl != null && slot.redirectUrl!.isNotEmpty)
                      _Tag(text: 'Link: ${slot.redirectUrl}'),
                    if (slot.daysRemaining != null && slot.isActive)
                      _Tag(text: '${slot.daysRemaining} days left'),
                  ],
                ),
                if (slot.isPending) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.rocket_launch_outlined, size: 16, color: Colors.green),
                    label: const Text(
                      'Make Banner Live (Approve)',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// REQUEST BANNER SHEET
// =============================================================================

class _BannerDraft {
  final String positionId;
  final String title;
  final String? redirectUrl;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final Uint8List imageBytes;

  const _BannerDraft({
    required this.positionId,
    required this.title,
    this.redirectUrl,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.imageBytes,
  });
}

class _RequestBannerSheet extends StatefulWidget {
  final List<BannerPositionModel> positions;

  const _RequestBannerSheet({required this.positions});

  @override
  State<_RequestBannerSheet> createState() => _RequestBannerSheetState();
}

class _RequestBannerSheetState extends State<_RequestBannerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _redirectCtrl = TextEditingController();

  late String _selectedPositionId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  Uint8List? _selectedImage;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedPositionId = widget.positions.isNotEmpty
        ? widget.positions.first.id
        : 'default-home-top';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _redirectCtrl.dispose();
    super.dispose();
  }

  BannerPositionModel get _currentPosition {
    return widget.positions.firstWhere(
      (p) => p.id == _selectedPositionId,
      orElse: () => widget.positions.isNotEmpty
          ? widget.positions.first
          : const BannerPositionModel(
              id: 'default',
              name: 'Home Top Carousel',
              maxBanners: 5,
              basePrice: 2500,
            ),
    );
  }

  double get _calculatedPrice {
    final days = _endDate.difference(_startDate).inDays;
    final normalizedDays = days <= 0 ? 1 : days;
    final base = _currentPosition.basePrice;
    return (base * (normalizedDays / 7)).roundToDouble();
  }

  Future<void> _pickBannerImage() async {
    final bytes = await pickImage();
    if (bytes != null) {
      setState(() => _selectedImage = bytes);
    }
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.black),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedImage == null) {
      showCustomSnackbar(
        context: context,
        message: 'Please upload a banner image',
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => _submitting = true);

    Navigator.pop(
      context,
      _BannerDraft(
        positionId: _selectedPositionId,
        title: _titleCtrl.text.trim(),
        redirectUrl: _redirectCtrl.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        price: _calculatedPrice,
        imageBytes: _selectedImage!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Request Sponsored Banner',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedPositionId,
                decoration: const InputDecoration(labelText: 'Banner Placement / Position'),
                items: widget.positions.map((p) {
                  return DropdownMenuItem(
                    value: p.id,
                    child: Text('${p.name} (Base: Rs ${p.basePrice.toStringAsFixed(0)}/wk)'),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedPositionId = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Banner Headline / Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _redirectCtrl,
                decoration: const InputDecoration(
                  labelText: 'Target URL / Dish Name (Optional)',
                  hintText: 'e.g. /dish/zinger-burger or https://...',
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: _pickDateRange,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Campaign Dates', style: TextStyle(fontSize: 13, color: Colors.black54)),
                      Text(
                        '${_startDate.day}/${_startDate.month} - ${_endDate.day}/${_endDate.month} (${_endDate.difference(_startDate).inDays} days)',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Banner Image Picker Box
              InkWell(
                onTap: _pickBannerImage,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.memory(_selectedImage!, fit: BoxFit.cover),
                              Container(color: Colors.black26),
                              const Center(
                                child: Text(
                                  'Tap to Change Banner',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 36, color: Colors.black45),
                            SizedBox(height: 6),
                            Text('Upload Banner Image (Recommended 16:6)', style: TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Estimated Price:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      'Rs ${_calculatedPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Submit Banner Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PROMOTION CARD (DISCOUNT)
// =============================================================================

class _PromotionCard extends StatelessWidget {
  final PromotionModel promotion;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _PromotionCard({
    required this.promotion,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final state = promotion.state;
    final accent = switch (state) {
      PromotionState.live => Colors.green,
      PromotionState.scheduled => Colors.blueGrey,
      PromotionState.expired => Colors.red,
      PromotionState.inactive => Colors.orange,
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 8, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              promotion.offerLabel,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              promotion.stateLabel,
                              style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        promotion.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: promotion.isActive,
                  onChanged: (_) => onToggle(),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((promotion.description ?? '').isNotEmpty) ...[
                  Text(
                    promotion.description!,
                    style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                ],
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag(text: promotion.kindLabel),
                    _Tag(text: 'Min Rs ${promotion.minOrder.toStringAsFixed(0)}'),
                    if (promotion.code != null && promotion.code!.isNotEmpty)
                      _Tag(text: promotion.code!, highlight: true),
                    if (promotion.daysRemaining != null)
                      _Tag(
                        text: state == PromotionState.expired
                            ? 'Ended'
                            : '${promotion.daysRemaining} days left',
                      ),
                  ],
                ),
                if (promotion.usageLimit != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: promotion.usagePercent,
                            minHeight: 6,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation(Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${promotion.usedCount}/${promotion.usageLimit} used',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CREATE PROMOTION SHEET (DISCOUNT DRAFT)
// =============================================================================

class _PromotionDraft {
  final String title;
  final String description;
  final String kind;
  final double value;
  final double minOrder;
  final double? maxDiscount;
  final String code;
  final int durationDays;

  const _PromotionDraft({
    required this.title,
    required this.description,
    required this.kind,
    required this.value,
    required this.minOrder,
    required this.maxDiscount,
    required this.code,
    required this.durationDays,
  });
}

class _CreatePromotionSheet extends StatefulWidget {
  const _CreatePromotionSheet();

  @override
  State<_CreatePromotionSheet> createState() => _CreatePromotionSheetState();
}

class _CreatePromotionSheetState extends State<_CreatePromotionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _value = TextEditingController();
  final _minOrder = TextEditingController(text: '500');
  final _maxDiscount = TextEditingController();
  final _code = TextEditingController();

  String _kind = 'percent';
  int _duration = 14;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _value.dispose();
    _minOrder.dispose();
    _maxDiscount.dispose();
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      _PromotionDraft(
        title: _title.text.trim(),
        description: _description.text.trim(),
        kind: _kind,
        value: double.tryParse(_value.text.trim()) ?? 0,
        minOrder: double.tryParse(_minOrder.text.trim()) ?? 0,
        maxDiscount: double.tryParse(_maxDiscount.text.trim()),
        code: _code.text.trim(),
        durationDays: _duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final needsValue = _kind == 'percent' || _kind == 'fixed';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'New Discount Promotion',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title (e.g. Weekend Special)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _description,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _kind,
                decoration: const InputDecoration(labelText: 'Offer Type'),
                items: const [
                  DropdownMenuItem(value: 'percent', child: Text('Percent off (%)')),
                  DropdownMenuItem(value: 'fixed', child: Text('Flat off (Rs)')),
                  DropdownMenuItem(value: 'free_delivery', child: Text('Free delivery')),
                  DropdownMenuItem(value: 'bogo', child: Text('Buy 2 get 1 (BOGO)')),
                ],
                onChanged: (v) => setState(() => _kind = v ?? 'percent'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _value,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: needsValue ? 'Discount Value' : 'Value (N/A)',
                        suffixText: _kind == 'percent' ? '%' : 'Rs',
                      ),
                      validator: (v) => !needsValue || (double.tryParse(v ?? '') ?? 0) > 0 ? null : 'Required',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _minOrder,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Min Order (Rs)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _code,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Promo Code (Optional)',
                        hintText: 'e.g. SPICY20',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _duration,
                      decoration: const InputDecoration(labelText: 'Duration'),
                      items: const [
                        DropdownMenuItem(value: 7, child: Text('7 days')),
                        DropdownMenuItem(value: 14, child: Text('14 days')),
                        DropdownMenuItem(value: 30, child: Text('30 days')),
                        DropdownMenuItem(value: 0, child: Text('Ongoing')),
                      ],
                      onChanged: (v) => setState(() => _duration = v ?? 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Create Promotion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SUPPORTING WIDGETS
// =============================================================================

class _FilterRow extends StatelessWidget {
  final String active;
  final Map<String, int> counts;
  final ValueChanged<String> onChanged;

  const _FilterRow({
    required this.active,
    required this.counts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in counts.entries)
          ChoiceChip(
            label: Text('${entry.key} (${entry.value})'),
            selected: active == entry.key,
            showCheckmark: false,
            selectedColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 12,
              color: active == entry.key ? Colors.white : Colors.black,
            ),
            onSelected: (_) => onChanged(entry.key),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final bool highlight;

  const _Tag({required this.text, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? Colors.black : Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: highlight ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

class _MigrationNoticeCard extends StatelessWidget {
  final String message;

  const _MigrationNoticeCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                'Supabase Table Migration Required',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'The "public.promotions" table is not found in Supabase.\n'
            'Please run the script in "supabase/migrations/20261026_promotions_and_banners.sql" in your Supabase SQL editor.',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _BannerErrorCard extends StatelessWidget {
  final String message;

  const _BannerErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        'Could not load banner slots: $message',
        style: const TextStyle(fontSize: 12, color: Colors.red),
      ),
    );
  }
}

class _EmptyDiscountsView extends StatelessWidget {
  const _EmptyDiscountsView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        children: [
          Icon(Icons.local_offer_outlined, size: 48, color: Colors.black26),
          SizedBox(height: 12),
          Text('No discount promotions yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 4),
          Text('Create special discounts, percentage off or promo codes to boost orders.', style: TextStyle(color: Colors.black54, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _EmptyBannersView extends StatelessWidget {
  const _EmptyBannersView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        children: [
          Icon(Icons.campaign_outlined, size: 48, color: Colors.black26),
          SizedBox(height: 12),
          Text('No banner ads requested yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 4),
          Text('Get featured on the app home carousel and category pages by booking a banner slot.', style: TextStyle(color: Colors.black54, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
