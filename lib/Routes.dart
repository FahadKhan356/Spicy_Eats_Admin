import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/Approve.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/chooseplanscreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/Signup/screen/SignupScreen.dart';
import 'package:spicy_eats_admin/Authentication/authCallBack.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';
import 'package:spicy_eats_admin/splashscreen.dart/SplashScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //login screen
    case LoginScreen.routename:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    //Register screen
    case RestaurantRegister.routename:
      return MaterialPageRoute(builder: (_) => const RestaurantRegister());

    //choose plan
    case ChoosePlanScreen.routename:
      return MaterialPageRoute(builder: (_) => const ChoosePlanScreen());

    //Approve screen
    case Approve.routename:
      return MaterialPageRoute(builder: (_) => const Approve());
    //splashscreen
    case SplashScreen.routename:
      return MaterialPageRoute(builder: (_) => const SplashScreen());

    //map location picker

    case MyMap.routename:
      return MaterialPageRoute(builder: (_) => const MyMap());

    case SignUpScreen.routename:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());

    case AuthCallbackPage.routename:
      return MaterialPageRoute(builder: (_) => const AuthCallbackPage());
    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text("there is no such page")));
  }
}
