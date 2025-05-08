import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});
  static const String routename = '/auth/callback';
  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  Future<void> _handleRedirect() async {
    final supabase = Supabase.instance.client;

    // Get session from URL fragment (if not already persisted)
    await supabase.auth.getSessionFromUrl(Uri.base);

    if (supabase.auth.currentSession != null) {
      // Navigate to your desired page
      Navigator.of(context).pushReplacementNamed(RestaurantRegister.routename);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routename);
    }
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
