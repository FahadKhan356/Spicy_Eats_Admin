import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/promotions/model/PromotionModel.dart';
import 'package:spicy_eats_admin/promotions/repo/PromotionsRepo.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class PromotionsScreen extends ConsumerStatefulWidget {
  static const String routename = '/promotions';

  const PromotionsScreen({super.key});

  @override
  ConsumerState<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends ConsumerState<PromotionsScreen> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(promotionsControllerProvider.notifier).load(restUid);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(promotionsControllerProvider);
    final restaurant = ref.watch(restaurantProvider);

    return Scaffold(
      backgroundColor: MyAppColor.primaryBg,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  _Header(
                    restaurantName: restaurant?.restaurantName ?? '',
                    liveCount: state.liveCount,
                    redemptions: state.totalRedemptions,
                  ),
                  const SizedBox(height: 16),
                  _FilterRow(
                    active: state.filter,
                    counts: {
                      'All': state.all.length,
                      'Live': state.all
                          .where((p) => p.state == PromotionState.live)
                          .length,
                      'Scheduled': state.all
                          .where((p) => p.state == PromotionState.scheduled)
                          .length,
                      'Paused': state.all
                          .where((p) => p.state == PromotionState.inactive)
                          .length,
                      'Expired': state.all
                          .where((p) => p.state == PromotionState.expired)
                          .length,
                    },
                    onChanged: (v) =>
                        ref.read(promotionsControllerProvider.notifier).setFilter(v),
                  ),
                  const SizedBox(height: 16),
                  if (_error != null)
                    _ErrorCard(message: _error!)
                  else if (state.visible.isEmpty)
                    const _EmptyView()
                  else
                    ...state.visible.map((promotion) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _PromotionCard(
                            promotion: promotion,
                            onToggle: () => _toggle(promotion),
                            onDelete: () => _confirmDelete(promotion),
                          ),
                        )),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => _openCreateSheet(),
                    icon: const Icon(Icons.add),
                    label: const Text('Create promotion'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _toggle(PromotionModel promotion) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    try {
      await ref
          .read(promotionsControllerProvider.notifier)
          .toggle(promotion, restUid);
      if (!mounted) return;
      showCustomSnackbar(
        context: context,
        message: promotion.isActive
            ? '${promotion.title} paused'
            : '${promotion.title} is now live',
        backgroundColor: Colors.black,
      );
    } catch (e) {
      if (!mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not update. Check the promotions RLS policy.',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _confirmDelete(PromotionModel promotion) async {
    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete ${promotion.title}?'),
        content: const Text('This removes the promotion for all customers.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref
          .read(promotionsControllerProvider.notifier)
          .remove(promotion.id, restUid);
    } catch (e) {
      if (!mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not delete promotion',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _openCreateSheet() async {
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

    if (result == null || !mounted) return;

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
      if (!mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Promotion created',
        backgroundColor: Colors.black,
      );
    } catch (e) {
      if (!mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Could not create promotion',
        backgroundColor: Colors.red,
      );
    }
  }
}

class _Header extends StatelessWidget {
  final String restaurantName;
  final int liveCount;
  final int redemptions;

  const _Header({
    required this.restaurantName,
    required this.liveCount,
    required this.redemptions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Promotions',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                restaurantName,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
        _Pill(label: '$liveCount live'),
        const SizedBox(width: 8),
        _Pill(label: '$redemptions used'),
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
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

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
        border: Border.all(color: Colors.grey[200]!),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              promotion.offerLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              promotion.stateLabel,
                              style: TextStyle(
                                color: accent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        promotion.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
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
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${promotion.usedCount}/${promotion.usageLimit} used',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black54),
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
                'New promotion',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
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
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'percent', child: Text('Percent off')),
                  DropdownMenuItem(value: 'fixed', child: Text('Flat off')),
                  DropdownMenuItem(
                      value: 'free_delivery', child: Text('Free delivery')),
                  DropdownMenuItem(value: 'bogo', child: Text('Buy 2 get 1')),
                ],
                onChanged: (v) => setState(() => _kind = v ?? 'percent'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _value,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        labelText: needsValue ? 'Discount' : 'Unused',
                        suffixText: _kind == 'percent' ? '%' : 'Rs',
                      ),
                      validator: (v) => !needsValue
                          ? null
                          : (double.tryParse(v ?? '') == null
                              ? 'Enter a number'
                              : null),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _minOrder,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Min order', prefixText: 'Rs '),
                      validator: (v) => double.tryParse(v ?? '') == null
                          ? 'Enter a number'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _maxDiscount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(labelText: 'Max discount (optional)'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Code (optional)'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                initialValue: _duration,
                decoration: const InputDecoration(labelText: 'Runs for'),
                items: const [
                  DropdownMenuItem(value: 7, child: Text('7 days')),
                  DropdownMenuItem(value: 14, child: Text('14 days')),
                  DropdownMenuItem(value: 30, child: Text('30 days')),
                  DropdownMenuItem(value: 0, child: Text('No end date')),
                ],
                onChanged: (v) => setState(() => _duration = v ?? 14),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Create promotion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.campaign_outlined, size: 44, color: Colors.black26),
          SizedBox(height: 12),
          Text(
            'No promotions here',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Create one to start attracting more orders.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
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
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Run the promotions migration first',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '20260930_02_promotions_reviews_ledger.sql must be run in the '
            'Supabase SQL editor before promotions can load.\n\n$message',
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
