import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Authentication/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/RegisterScreen.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //login screen
    case LoginScreen.routename:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    //Register screen
    case RegisterScreen.routename:
      return MaterialPageRoute(builder: (_) => const RegisterScreen());

    //map location picker

    case MyMap.routename:
      return MaterialPageRoute(builder: (_) => MyMap());
    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text("there is no such page")));
  }
}
