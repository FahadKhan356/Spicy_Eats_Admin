import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/Approve.dart';
import 'package:spicy_eats_admin/Authentication/authCallBack.dart';
import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';
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
  @override
  void initState() {
    debugPrint(supabaseClient.auth.currentUser?.email);
    debugPrint(supabaseClient.auth.currentUser?.id);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorkey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Dashboard(),
      // const SplashScreen(),
      onGenerateRoute: generateRoute,
    );
  }
}
