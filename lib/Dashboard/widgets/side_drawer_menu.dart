import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/utils/colors.dart';
import 'package:spicy_eats_admin/utils/list.dart';

import '../../Authentication/Login/LoginScreen.dart' show LoginScreen;

class SideDrawerMenu extends ConsumerWidget {
  static const double width = 240;

  const SideDrawerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final restaurant = ref.watch(restaurantProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Brand(restaurantLogo: restaurant?.restaurantLogoImageUrl),
            _OwnerCard(
              name: restaurant?.restaurantName ?? 'No restaurant',
              address: restaurant?.address,
              isDesktop: isDesktop,
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...navItems.map((item) {
              final isSelected = currentPath == item.route;
              return _NavTile(
                item: item,
                isSelected: isSelected,
                onTap: item.enabled ? () => _navigate(context, item.route) : null,
              );
            }),
            const SizedBox(height: 8),
            const Divider(height: 1),
            _SignOutTile(isDesktop: isDesktop),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    if (Responsive.isMobile(context)) Navigator.of(context).pop();
    context.go(route);
  }
}

class _Brand extends StatelessWidget {
  final String? restaurantLogo;

  const _Brand({this.restaurantLogo});

  @override
  Widget build(BuildContext context) {
    final logo = restaurantLogo;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: logo == null || logo.isEmpty
                ? Image.asset('lib/assets/SpicyEats.png', width: 40, height: 40)
                : Image.network(
                    logo,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'lib/assets/SpicyEats.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Spicy Eats',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyAppColor.mainPrimary,
                  ),
                ),
                Text(
                  'Partner Portal',
                  style: TextStyle(fontSize: 11, color: MyAppColor.iconGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  final String name;
  final String? address;
  final bool isDesktop;

  const _OwnerCard({
    required this.name,
    required this.address,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          if (address != null && address!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              address!,
              maxLines: isDesktop ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: MyAppColor.iconGray),
            ),
          ],
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = item.enabled;
    final iconColor = isSelected
        ? Colors.black
        : isEnabled
            ? MyAppColor.iconGray
            : Colors.grey[300];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          hoverColor: Colors.grey[200],
          onTap: isEnabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Image.asset(
                  item.icon,
                  width: 24,
                  height: 24,
                  color: isSelected ? Colors.white : iconColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isEnabled
                              ? Colors.black
                              : Colors.grey[400],
                    ),
                  ),
                ),
                if (!isEnabled)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Soon',
                      style: TextStyle(fontSize: 9, color: MyAppColor.iconGray),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignOutTile extends ConsumerWidget {
  final bool isDesktop;

  const _SignOutTile({required this.isDesktop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          hoverColor: Colors.grey[200],
          onTap: () => _signOut(context, ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.logout, size: 20, color: MyAppColor.iconGray),
                const SizedBox(width: 12),
                Text(
                  isDesktop ? 'Sign out' : '',
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    if (Responsive.isMobile(context)) Navigator.of(context).pop();
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to sign in again to manage orders.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await supabaseClient.auth.signOut();
    ref.read(restaurantProvider.notifier).state = null;
    if (context.mounted) context.go(LoginScreen.routename);
  }
}
