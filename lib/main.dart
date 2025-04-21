import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Authentication/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/RegisterScreen.dart';
import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RegisterScreen(),
      //const LoginScreen(),
      // Dashboard()
    );
  }
}
