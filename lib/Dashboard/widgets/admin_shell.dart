import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/side_drawer_menu.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';

class AdminShell extends ConsumerStatefulWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOwner());
  }

  Future<void> _loadOwner() async {
    await ref.read(menuManagerRepoProvider).fetchRestaurantData();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantProvider);
    final error = ref.watch(restaurantErrorProvider);
    final isDesktop = Responsive.isDesktop(context);

    if (restaurant == null) {
      return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Center(
            child: error != null
                ? _OwnerError(
                    message: error,
                    onRetry: () => ref
                        .read(menuManagerRepoProvider)
                        .fetchRestaurantData(),
                  )
                : const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.black),
                      SizedBox(height: 16),
                      Text(
                        'Loading your restaurant...',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      drawer: isDesktop
          ? null
          : Drawer(
              child: SafeArea(child: ref.watch(sideDrawerProvider)),
            ),
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                restaurant.restaurantName ?? 'Menu',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Sign out',
                  icon: const Icon(Icons.logout, color: Colors.black),
                  onPressed: _confirmSignOut,
                ),
              ],
            ),
      body: Row(
        children: [
          if (isDesktop)
            ColoredBox(
              color: Colors.white,
              child: SafeArea(
                right: false,
                child: SizedBox(
                  width: SideDrawerMenu.width,
                  child: ref.watch(sideDrawerProvider),
                ),
              ),
            ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
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

    if (shouldSignOut != true || !mounted) return;

    await supabaseClient.auth.signOut();
    ref.read(restaurantProvider.notifier).state = null;
    if (mounted) context.go(LoginScreen.routename);
  }
}

final sideDrawerProvider = Provider<Widget>((ref) => const SideDrawerMenu());

class _OwnerError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _OwnerError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storefront_outlined, size: 44, color: Colors.red),
            const SizedBox(height: 14),
            const Text(
              'Could not load your restaurant',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
