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
  static const double width = 250;

  const SideDrawerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final restaurant = ref.watch(restaurantProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Brand(restaurantLogo: restaurant?.restaurantLogoImageUrl),
          const SizedBox(height: 6),
          _OwnerCard(
            name: restaurant?.restaurantName ?? 'No restaurant',
            address: restaurant?.address,
            isDesktop: isDesktop,
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: navItems.map((item) {
                  final isSelected = currentPath == item.route;
                  return _NavTile(
                    item: item,
                    isSelected: isSelected,
                    onTap: item.enabled ? () => _navigate(context, item.route) : null,
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          const SizedBox(height: 6),
          _SignOutTile(isDesktop: isDesktop),
          const SizedBox(height: 8),
        ],
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange.shade100),
            ),
            clipBehavior: Clip.antiAlias,
            child: logo == null || logo.isEmpty
                ? Image.asset('lib/assets/SpicyEats.png', fit: BoxFit.cover)
                : Image.network(
                    logo,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'lib/assets/SpicyEats.png',
                      fit: BoxFit.cover,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Partner Portal',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'R',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                if (address != null && address!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    address!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
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
        ? Colors.white
        : isEnabled
            ? Colors.black87
            : Colors.grey[400];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Material(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          hoverColor: isSelected ? Colors.black : const Color(0xFFF3F4F6),
          onTap: isEnabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10.5),
            child: Row(
              children: [
                Image.asset(
                  item.icon,
                  width: 20,
                  height: 20,
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
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isEnabled
                              ? Colors.black87
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          hoverColor: Colors.red.shade50,
          onTap: () => _signOut(context, ref),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10.5),
            child: Row(
              children: [
                Icon(Icons.logout_rounded, size: 20, color: Colors.black54),
                SizedBox(width: 12),
                Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
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
