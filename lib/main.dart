import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/Approve.dart';
import 'package:spicy_eats_admin/Authentication/authCallBack.dart';
import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';
import 'package:spicy_eats_admin/Dashboard/dummy.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/side_drawer_menu.dart';
import 'package:spicy_eats_admin/Routes.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/Menu.dart' hide MenuScreen;
import 'package:spicy_eats_admin/menu/adddishform.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
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
    
    final router = GoRouter(
      initialLocation: SplashScreen.routename,
      routes: [
       
         GoRoute(
              path: SplashScreen.routename,
              builder: (context, state) =>
                  // const Center(child: Text("Dashboard Page", style: TextStyle(fontSize: 30))),
                  const SplashScreen(),
            ),
        GoRoute(
            path: LoginScreen.routename,
            builder: (context, state) =>
                // const Center(child: Text("Dashboard Page", style: TextStyle(fontSize: 30))),
                const LoginScreen()),
                 GoRoute(
              path: AddDishForm.routename,
              builder: (context, state) {
                 final categories = state.extra as List<CategoryModel>; 
               return AddDishForm(categories: categories);}
            ),
        ShellRoute(
          builder: (context, state, child) {
            // return const SplashScreen();
            return Row(
              children: [
                Responsive.isDesktop(context)
                    ? const SideDrawerMenu()
                    : SizedBox(), // always stays
                Expanded(
                    child: RepaintBoundary(child: child)), // only this swaps
              ],
            );
          },
          routes: [
             GoRoute(
              path: MenuScreen.routename,
              builder: (context, state) =>
                  // const Center(child: Text("Dashboard Page", style: TextStyle(fontSize: 30))),
                MenuScreen(),
            ),
            GoRoute(
              path: Dashboard.routename,
              builder: (context, state) =>
                  // const Center(child: Text("Dashboard Page", style: TextStyle(fontSize: 30))),
                  Dashboard(),
            ),
           
            GoRoute(
              path: MenuManagerScreen.routename,
              builder: (context, state) =>
                  // const Center(child: Text("Menu Page", style: TextStyle(fontSize: 30))),
                  const MenuManagerScreen(),
            ),
            GoRoute(
              path: '/promo',
              builder: (context, state) => const Center(
                  child: Text("Promo Page", style: TextStyle(fontSize: 30))),
            ),
          ],
        ),
      ],
    );
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // navigatorKey: navigatorkey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
       
      // home:
      //  Dashboard(),
      // // const SplashScreen(),
      // onGenerateRoute: generateRoute,
     useMaterial3: true,
      ),
    );
  }
}
