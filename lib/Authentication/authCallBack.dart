import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

class AuthCallbackPage extends ConsumerStatefulWidget {
  const AuthCallbackPage({super.key});
  static const String routename = '/auth/callback';
  @override
  ConsumerState<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends ConsumerState<AuthCallbackPage> {
  late final StreamSubscription<AuthState> _authListener;
  Future<void> _handleOAuthCallback() async {
    try {
      final sessionUrl = await supabaseClient.auth
          .getSessionFromUrl(Uri.base, storeSession: true);
      final session = sessionUrl.session;

      if (session != null) {
        debugPrint('✅ OAuth login successful');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(authRepoProvider).storeNewUserData(
                user: session.user,
                context: context,
              );

          Navigator.pushNamedAndRemoveUntil(
            context,
            RestaurantRegister.routename,
            (_) => false,
          );
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          debugPrint('❌ Session is null after OAuth');
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routename,
            (_) => false,
          );
          // if (navigatorkey.currentState != null && mounted) {
          //   navigatorkey.currentState!.pushNamedAndRemoveUntil(
          //       LoginScreen.routename, (route) => false);
          // }
        });
      }
    } catch (e) {
      debugPrint('❌ Error during OAuth callback: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackbar(
            context: context,
            message: 'Login failed: $e',
            backgroundColor: Colors.black);
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.routename,
          (_) => false,
        );
      });
    }
  }

  // void _initialAuth() async {
  //   try {
  //     if (supabaseClient.auth.currentSession != null)
  //       // _authListener =
  //       supabaseClient.auth.onAuthStateChange.listen((event) {
  //         final session = event.session;

  //         if (event == AuthChangeEvent.signedIn && session != null) {
  //           final user = supabaseClient.auth.currentUser;
  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             ref
  //                 .read(authRepoProvider)
  //                 .storeNewUserData(user: user!, context: context);

  //             debugPrint('User just signed in');
  //             Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (_) => const RestaurantRegister()),
  //                 (route) => false);
  //           });
  //         } else {
  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             debugPrint('No user ');
  //             Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (_) => const LoginScreen()),
  //                 (route) => false);
  //           });
  //         }
  //       });
  //   } catch (e) {
  //     debugPrint('error in auth state $e');
  //   }
  //   // final session = supabaseClient.auth.currentSession;
  //   // if (session == null) {
  //   //   return;
  //   // }
  // }
  void _initialAuth() async {
    try {
      // STEP 1: Handle OAuth redirect first
      final hasOAuthParams = Uri.base.queryParameters.containsKey('code') ||
          Uri.base.queryParameters.containsKey('access_token');

      if (hasOAuthParams) {
        try {
          final response = await supabaseClient.auth.getSessionFromUrl(
            Uri.base,
            storeSession: true,
          );
          debugPrint(
              '✅ OAuth session restored: ${response.session?.user?.email}');
        } catch (e) {
          debugPrint('❌ Failed to restore session from URL: $e');
        }
      }

      // STEP 2: Listen to auth state changes
      _authListener = supabaseClient.auth.onAuthStateChange.listen((event) {
        final session = event.session;

        if (event.event == AuthChangeEvent.signedIn && session != null) {
          final user = supabaseClient.auth.currentUser;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(authRepoProvider)
                .storeNewUserData(user: user!, context: context);

            debugPrint('User just signed in: ${user.email}');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const RestaurantRegister()),
              (route) => false,
            );
          });
        } else if (event.event == AuthChangeEvent.signedOut ||
            session == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            debugPrint('🚫 No session or user signed out');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          });
        }
      });
    } catch (e) {
      debugPrint('❌ Error in _initialAuth: $e');
    }
  }

  @override
  void initState() {
    _initialAuth();
    // _handleOAuthCallback();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _authListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.black,
      )),
    );
  }
}
