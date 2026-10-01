import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/router.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/splashscreen.dart/SplashScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCallbackPage extends ConsumerStatefulWidget {
  static const String routename = '/auth/callback';

  const AuthCallbackPage({super.key});

  @override
  ConsumerState<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends ConsumerState<AuthCallbackPage> {
  StreamSubscription<AuthState>? _authListener;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final uri = Uri.base;
      final hasParams = uri.queryParameters.containsKey('code') ||
          uri.queryParameters.containsKey('access_token');

      if (hasParams) {
        await supabaseClient.auth.getSessionFromUrl(uri, storeSession: true);
      }

      _authListener = supabaseClient.auth.onAuthStateChange.listen((event) {
        if (event.event == AuthChangeEvent.signedIn &&
            event.session != null &&
            mounted) {
          _persistUser();
          context.go(SplashScreen.routename);
        }
      });

      if (isLoggedIn && mounted) {
        await _persistUser();
        if (mounted) context.go(SplashScreen.routename);
      }
    } catch (e) {
      if (!mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Login failed. Please try again.',
        backgroundColor: Colors.red,
      );
      context.go(LoginScreen.routename);
    }
  }

  Future<void> _persistUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return;
    try {
      await ref.read(authRepoProvider).storeNewUserData(
            user: user,
            context: context,
          );
    } catch (_) {}
  }

  @override
  void dispose() {
    _authListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.black)),
    );
  }
}
