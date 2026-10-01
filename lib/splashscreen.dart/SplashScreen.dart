import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/config/router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String routename = '/SplashScreen';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _failed = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decideNavigation());
  }

  Future<void> _decideNavigation() async {
    if (!isLoggedIn) {
      if (mounted) context.go(LoginScreen.routename);
      return;
    }

    try {
      final step = await readAuthStep();
      if (!mounted) return;

      if (step == null) {
        setState(() {
          _failed = true;
          _message =
              'We could not load your account. Check that the users table '
              'allows reads for signed-in accounts, then try again.';
        });
        return;
      }

      context.go(landingForStep(step));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _failed = true;
        _message = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('lib/assets/SpicyEats.png', width: 90),
                  const SizedBox(height: 20),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      setState(() => _failed = false);
                      _decideNavigation();
                    },
                    child: const Text('Try again'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go(LoginScreen.routename),
                    child: const Text('Sign in as someone else'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('lib/assets/SpicyEats.png', width: 110),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
