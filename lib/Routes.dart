import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Authentication/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/RestaurantRegister.dart';
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
      return MaterialPageRoute(builder: (_) => MyMap());
    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text("there is no such page")));
  }
}
