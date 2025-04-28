import 'dart:io';

import 'package:riverpod/riverpod.dart';

var businessNameProvider = StateProvider<String?>((ref) => null);
var firstAndMiddleNameProvider = StateProvider<String?>((ref) => null);
var lastNameProvider = StateProvider<String?>((ref) => null);
var businessEmailProvider = StateProvider<String?>((ref) => null);
var mobileNumberProvider = StateProvider<int?>((ref) => null);
var restaurantLatProvider = StateProvider<double?>((ref) => null);
var restaurantLongProvider = StateProvider<double?>((ref) => null);
var restaurantAddProvider = StateProvider<String?>((ref) => null);
var restaurantLocationSelectedProvider = StateProvider<bool?>((ref) => null);

class AuthController {}
