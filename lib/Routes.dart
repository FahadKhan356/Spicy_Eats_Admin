import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/Approve.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/chooseplanscreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/Signup/screen/SignupScreen.dart';
import 'package:spicy_eats_admin/Authentication/authCallBack.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';
import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';
import 'package:spicy_eats_admin/Dashboard/dummy.dart';
import 'package:spicy_eats_admin/splashscreen.dart/SplashScreen.dart';
import 'package:go_router/go_router.dart';

// final router = GoRouter(
//       initialLocation: Dashboard.routename,
//       routes: [
//         ShellRoute(
//           builder: (context, state, child) {
//             return Dashboard();
//           },
//           routes: [
//             GoRoute(path: LoginScreen.routename,builder:(context,state)=>const LoginScreen()),
//             GoRoute(path: RestaurantRegister.routename,builder:(context,state)=>const RestaurantRegister()),

//             GoRoute(path: ChoosePlanScreen.routename,builder:(context,state)=>const ChoosePlanScreen()),

//             GoRoute(path: Approve.routename,builder:(context,state)=>const Approve()),

//             GoRoute(path: SignUpScreen.routename,builder:(context,state)=>const SignUpScreen()),
//             GoRoute(path: MyMap.routename,builder:(context,state)=>const MyMap()),

//             GoRoute(path: AuthCallbackPage.routename,builder:(context,state)=>const AuthCallbackPage()),

//             GoRoute(path: SplashScreen.routename,builder:(context,state)=>const SplashScreen()),


//             GoRoute(
//               path: Dashboard.routename,
//               builder: (context, state) =>
//                   Center(child: Dashboard())),
            
//             GoRoute(
//               path: '/menu',
//               builder: (context, state) =>
//                   const Center(child: Text("Menu Page", style: TextStyle(fontSize: 30))),
//             ),
//             GoRoute(
//               path: '/promo',
//               builder: (context, state) =>
//                   const Center(child: Text("Promo Page", style: TextStyle(fontSize: 30))),
//             ),
//           ],
//         ),
//       ],
//     );



// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     //login screen
//     case LoginScreen.routename:
//       return MaterialPageRoute(builder: (_) => const LoginScreen());

//     //Register screen
//     case RestaurantRegister.routename:
//       return MaterialPageRoute(builder: (_) => const RestaurantRegister());

//     //choose plan
//     case ChoosePlanScreen.routename:
//       return MaterialPageRoute(builder: (_) => const ChoosePlanScreen());

//     //Approve screen
//     case Approve.routename:
//       return MaterialPageRoute(builder: (_) => const Approve());
//     //splashscreen
//     case SplashScreen.routename:
//       return MaterialPageRoute(builder: (_) => const SplashScreen());

//     //map location picker

//     case MyMap.routename:
//       return MaterialPageRoute(builder: (_) => const MyMap());

//     case SignUpScreen.routename:
//       return MaterialPageRoute(builder: (_) => const SignUpScreen());

//     case AuthCallbackPage.routename:
//       return MaterialPageRoute(builder: (_) => const AuthCallbackPage());
//     default:
//       return MaterialPageRoute(
//           builder: (_) => const Scaffold(body: Text("there is no such page")));
//   }
// }
