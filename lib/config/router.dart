import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:spicy_eats_admin/Authentication/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:spicy_eats_admin/Authentication/ForgotPassword/ResetPasswordScreen.dart';
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
import 'package:spicy_eats_admin/reviews/screen/ReviewsScreen.dart';
import 'package:spicy_eats_admin/splashscreen.dart/SplashScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const publicRoutes = <String>{
  SplashScreen.routename,
  LoginScreen.routename,
  SignUpScreen.routename,
  AuthCallbackPage.routename,
  ForgotPasswordScreen.routename,
  ResetPasswordScreen.routename,
};

const onboardingRoutes = <String>{
  RestaurantRegister.routename,
  ChoosePlanScreen.routename,
  Approve.routename,
};

final authRefresh = ValueNotifier<int>(0);

StreamSubscription<dynamic>? _authSub;

void listenToAuth() {
  _authSub ??= supabaseClient.auth.onAuthStateChange.listen((data) {
    if (data.session == null) {
      // Signed out: forget the cached step and stop the realtime listener.
      _stopWatchingAuthStep();
      currentAuthStep.value = null;
    } else {
      readAuthStep();
    }
    authRefresh.value++;
  });
  if (isLoggedIn) {
    readAuthStep();
  }
  // Session may have been restored during Supabase.initialize() (before this
  // listener was attached). Fire once to make the router re-check redirect.
  authRefresh.value++;
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

/// Latest known onboarding step of the signed-in user (`users.Auth_steps`).
///
///   1 = account created      -> /Register   (fill restaurant details)
///   2 = restaurant saved     -> /Chooseplan (pick commission plan)
///   3 = plan chosen          -> /Approve    (waiting for approval)
///   4 = approved             -> /Dashboard
///
/// The router redirect reads this synchronously, and a realtime listener keeps
/// it in sync with the database, so editing `Auth_steps` in Supabase moves the
/// user to the matching screen right away.
final currentAuthStep = ValueNotifier<int?>(null);

RealtimeChannel? _stepChannel;
Timer? _stepPollTimer;
String? _stepChannelUid;

int parseAuthStep(dynamic raw) {
  int step;
  if (raw is int) {
    step = raw;
  } else if (raw is num) {
    step = raw.toInt();
  } else {
    step = int.tryParse('${raw ?? ''}') ?? 1;
  }
  if (step < 1) return 1;
  if (step > 4) return 4;
  return step;
}

/// Updates the cached step and makes the router re-evaluate the redirect.
void setAuthStep(int? step) {
  if (currentAuthStep.value == step) return;
  currentAuthStep.value = step;
  authRefresh.value++;
}

void _watchAuthStep(String uid) {
  if (_stepChannelUid == uid && _stepChannel != null) return;
  _stopWatchingAuthStep();
  _stepChannelUid = uid;
  _stepChannel = supabaseClient
      .channel('auth-step-$uid')
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'users',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: uid,
        ),
        callback: (payload) {
          final step = parseAuthStep(payload.newRecord['Auth_steps']);
          debugPrint('[authStep] realtime update -> $step');
          setAuthStep(step);
        },
      )
      .subscribe();

  _stepPollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
    if (!isLoggedIn || supabaseClient.auth.currentUser?.id != uid) return;
    try {
      final row = await supabaseClient
          .from('users')
          .select('Auth_steps')
          .eq('id', uid)
          .maybeSingle();
      if (row != null && row['Auth_steps'] != null) {
        final step = parseAuthStep(row['Auth_steps']);
        setAuthStep(step);
      }
    } catch (_) {}
  });
}

void _stopWatchingAuthStep() {
  _stepPollTimer?.cancel();
  _stepPollTimer = null;
  final channel = _stepChannel;
  _stepChannel = null;
  _stepChannelUid = null;
  if (channel != null) {
    supabaseClient.removeChannel(channel);
  }
}

Future<int?> readAuthStep() async {
  final user = supabaseClient.auth.currentUser;
  if (user == null) return null;

  final profile = await ensureUserProfile();
  final rawStep = profile?['Auth_steps'];

  // Missing / 0 step means the account was just created: start onboarding.
  if (rawStep == null || '$rawStep' == '0') {
    try {
      await supabaseClient
          .from('users')
          .update({'Auth_steps': 1, 'Role': 'restaurant-admin'})
          .eq('id', user.id);
    } catch (e) {
      debugPrint('readAuthStep init Auth_steps failed: $e');
    }
  }

  // The database value is the single source of truth for the screen.
  final step = parseAuthStep(rawStep);
  setAuthStep(step);
  _watchAuthStep(user.id);
  return step;
}

String landingForStep(int? step) {
  switch (step) {
    case 1:
      return RestaurantRegister.routename; // /Register
    case 2:
      return ChoosePlanScreen.routename;   // /Chooseplan
    case 3:
      return Approve.routename;            // /Approve
    case 4:
    default:
      return Dashboard.routename;          // /Dashboard
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
      if (location == ResetPasswordScreen.routename ||
          location == AuthCallbackPage.routename) {
        return null;
      }
      if (isPublic && location != SplashScreen.routename) {
        return SplashScreen.routename;
      }

      // Keep the user on the screen that matches `users.Auth_steps`.
      final step = currentAuthStep.value;
      if (step != null && !isPublic) {
        final target = landingForStep(step);
        final isOnboarding = onboardingRoutes.contains(location);
        if (step < 4 && location != target) {
          return target;
        }
        if (step >= 4 && isOnboarding) {
          return Dashboard.routename;
        }
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
        path: ForgotPasswordScreen.routename,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: ResetPasswordScreen.routename,
        builder: (context, state) => const ResetPasswordScreen(),
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
          GoRoute(
            path: ReviewsScreen.routename,
            builder: (context, state) => const ReviewsScreen(),
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
