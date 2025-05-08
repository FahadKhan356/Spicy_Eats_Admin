import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/Signup/screen/SignupScreen.dart';
import 'package:spicy_eats_admin/Authentication/authCallBack.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //login screen
    case LoginScreen.routename:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    //Register screen
    case RestaurantRegister.routename:
      return MaterialPageRoute(builder: (_) => const RestaurantRegister());

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
