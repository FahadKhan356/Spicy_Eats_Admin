import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/Approve.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String routename = '/SplashScreen';
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Run after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
      decideNavigation();
    });
  }

  Future<void> decideNavigation() async {
    final session = supabaseClient.auth.currentSession;
    final user = supabaseClient.auth.currentUser;

    if (session == null || user == null) {
      if (!mounted) return;
      context.go(LoginScreen.routename);
      return;
    }

    final data = await supabaseClient
        .from('users')
        .select('Auth_steps')
        .eq('id', user.id)
        .maybeSingle();

    if (!mounted) return;

    final step = data?['Auth_steps'] ?? 0;

    switch (step) {
      case 1:
        context.go(RestaurantRegister.routename);
        break;
      case 2:
        context.go(Dashboard.routename);
        break;
      case 3:
        context.go(Approve.routename);
        break;
      default:
        context.go(Dashboard.routename);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.black),
      ),
    );
  }
}

