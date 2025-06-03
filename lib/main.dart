import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/chooseplanscreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/authCallBack.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/Routes.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/splashscreen.dart/SplashScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabseURL,
    anonKey: supabaseKEY,
  );
  // Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

  final uri = Uri.base;
  final hasOAuthParams = uri.queryParameters.containsKey('code') ||
      uri.queryParameters.containsKey('access_token');

  if (hasOAuthParams) {
    try {
      final response = await Supabase.instance.client.auth
          .getSessionFromUrl(uri, storeSession: true);
      debugPrint('✅ OAuth session restored: ${response.session.user.email}');
    } catch (e) {
      debugPrint('❌ Failed to restore OAuth session: $e');
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  // late final StreamSubscription<AuthState> _authstateSubscription;

  // _initialAuth() {
  //   _authstateSubscription =
  //       supabaseClient.auth.onAuthStateChange.listen((event) {
  //     final session = event.session;

  //     if (session != null && navigatorkey.currentState != null) {
  //       final user = supabaseClient.auth.currentUser;
  //       ref
  //           .read(authRepoProvider)
  //           .storeNewUserData(user: user!, context: context);

  //       debugPrint('User just signed in');
  //       navigatorkey.currentState!.pushNamedAndRemoveUntil(
  //         RestaurantRegister.routename,
  //         (route) => false,
  //       );
  //     } else {
  //       debugPrint('No user ');
  //       navigatorkey.currentState!.pushNamedAndRemoveUntil(
  //         LoginScreen.routename,
  //         (route) => false,
  //       );
  //     }
  //   });
  // }

  @override
  void initState() {
    debugPrint(supabaseClient.auth.currentUser?.email);
    debugPrint(supabaseClient.auth.currentUser?.id);

    // TODO: implement initState
    super.initState();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _authstateSubscription.cancel();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      //  ChoosePlanScreen(),

      // supabaseClient.auth.currentSession != null &&
      //         supabaseClient.auth.currentUser != null
      //     ? const RestaurantRegister()
      //     : const LoginScreen(),
      onGenerateRoute: generateRoute,
    );
  }
}
