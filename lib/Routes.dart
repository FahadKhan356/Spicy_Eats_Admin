import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Authentication/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/RegisterScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //login screen
    case LoginScreen.routename:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    //Register screen
    case RegisterScreen.routename:
      return MaterialPageRoute(builder: (_) => const RegisterScreen());
    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text("there is no such page")));
  }
}
