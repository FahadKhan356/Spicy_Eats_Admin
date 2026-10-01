import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/Approve.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/chooseplanscreen.dart';
import 'package:spicy_eats_admin/Authentication/Signup/screen/SignupScreen.dart';
import 'package:spicy_eats_admin/Authentication/authCallBack.dart';
import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/admin_shell.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
import 'package:spicy_eats_admin/orders/screen/OrdersScreen.dart';
import 'package:spicy_eats_admin/promotions/screen/PromotionsScreen.dart';
import 'package:spicy_eats_admin/splashscreen.dart/SplashScreen.dart';

const publicRoutes = <String>{
  SplashScreen.routename,
  LoginScreen.routename,
  SignUpScreen.routename,
  AuthCallbackPage.routename,
};

final authRefresh = ValueNotifier<int>(0);

StreamSubscription<dynamic>? _authSub;

void listenToAuth() {
  _authSub ??= supabaseClient.auth.onAuthStateChange.listen((_) {
    authRefresh.value++;
  });
}

bool get isLoggedIn => supabaseClient.auth.currentSession != null;

Future<Map<String, dynamic>?> fetchUserProfile() async {
  final uid = supabaseClient.auth.currentUser?.id;
  if (uid == null) return null;
  try {
    return await supabaseClient
        .from('users')
        .select('*')
        .eq('id', uid)
        .maybeSingle();
  } catch (_) {
    return null;
  }
}

/// Creates the `users` row when it is missing.
///
/// `AuthRepository.signIn` used to run a conditional UPDATE, so a user who
/// only ever signed in with Google never got a row. `readAuthStep` then
/// returned null and the app hung on the splash screen forever.
Future<Map<String, dynamic>?> ensureUserProfile() async {
  final user = supabaseClient.auth.currentUser;
  if (user == null) return null;

  final existing = await fetchUserProfile();
  if (existing != null) return existing;

  try {
    await supabaseClient.from('users').upsert({
      'id': user.id,
      'email': user.email,
      'Role': 'restaurant-admin',
      'status': 'pending',
      'Auth_steps': 1,
    });
  } catch (e) {
    debugPrint('ensureUserProfile insert failed: $e');
  }

  return fetchUserProfile();
}

Future<int?> readAuthStep() async {
  final profile = await ensureUserProfile();
  final step = profile?['Auth_steps'];
  return step is int ? step : null;
}

String landingForStep(int? step) {
  switch (step) {
    case 1:
      return RestaurantRegister.routename;
    case 3:
      return Approve.routename;
    case 2:
    default:
      return Dashboard.routename;
  }
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: SplashScreen.routename,
    refreshListenable: authRefresh,
    errorBuilder: (context, state) => const _RouteNotFound(),
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublic = publicRoutes.contains(location);

      if (!isLoggedIn) {
        return isPublic ? null : LoginScreen.routename;
      }
      if (isPublic && location != SplashScreen.routename) {
        return SplashScreen.routename;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: SplashScreen.routename,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routename,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: SignUpScreen.routename,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AuthCallbackPage.routename,
        builder: (context, state) => const AuthCallbackPage(),
      ),
      GoRoute(
        path: RestaurantRegister.routename,
        builder: (context, state) => const RestaurantRegister(),
      ),
      GoRoute(
        path: ChoosePlanScreen.routename,
        builder: (context, state) => const ChoosePlanScreen(),
      ),
      GoRoute(
        path: Approve.routename,
        builder: (context, state) => const Approve(),
      ),
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: Dashboard.routename,
            builder: (context, state) => const Dashboard(),
          ),
          GoRoute(
            path: MenuManagerScreen.routename,
            builder: (context, state) => const MenuManagerScreen(),
          ),
          GoRoute(
            path: OrdersScreen.routename,
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: PromotionsScreen.routename,
            builder: (context, state) => const PromotionsScreen(),
          ),
        ],
      ),
    ],
  );
}

class _RouteNotFound extends StatelessWidget {
  const _RouteNotFound();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spicy Eats')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore_off_outlined, size: 48),
            const SizedBox(height: 12),
            const Text('Page not found'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(Dashboard.routename),
              child: const Text('Go to dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
