import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/chooseplanscreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authRepoProvider).checkAuthSteps(context, ref);
      decideNavigation();
    });
  }

  Future<void> decideNavigation() async {
    final session = supabaseClient.auth.currentSession;
    final user = supabaseClient.auth.currentUser;

    if (session == null || user == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.routename);
      return;
    }

    final data = await supabaseClient
        .from('users')
        .select('Auth_steps')
        .eq('id', user.id)
        .single();

    final step = data['Auth_steps'] ?? 0;

    if (step == 1) {
      Navigator.pushReplacementNamed(context, RestaurantRegister.routename);
    } else if (step == 2) {
      Navigator.pushReplacementNamed(context, ChoosePlanScreen.routename);
    } else {
      // fallback, or show error
      Navigator.pushReplacementNamed(context, LoginScreen.routename);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
