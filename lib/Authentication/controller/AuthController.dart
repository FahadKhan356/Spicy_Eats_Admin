import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var restaurantLatProvider = StateProvider<double?>((ref) => null);
var restaurantLongProvider = StateProvider<double?>((ref) => null);
var restaurantAddProvider = StateProvider<String?>((ref) => null);
var restaurantLocationSelectedProvider = StateProvider<bool?>((ref) => null);
final isloadingprovider = StateProvider<bool>((ref) => false);

var authControllerProvider = Provider((ref) {
  final authrepo = ref.watch(authRepoProvider);

  return AuthController(authRepository: authrepo, ref: ref);
});

class AuthController {
  AuthController({required this.authRepository, required this.ref});
  AuthRepository authRepository;
  Ref ref;

// sign up
  Future<void> signUp(
      {required businessEmail, required password, required context}) async {
    await authRepository.signup(
        businessEmail: businessEmail, password: password, context: context);
  }

//sign in

  Future<void> signIn(
      {required email,
      required password,
      required context,
      required WidgetRef ref}) async {
    await authRepository.signIn(
        email: email, password: password, context: context, ref: ref);
  }

//Google sign in
  Future<void> signupWithGoogleUniversal(
      {required BuildContext context}) async {
    authRepository.signInWithGoogleUniversal(context);
  }

//register restaurant
  Future<void> registerRestaurant({
    required businessEmail,
    required bussinessName,
    required firstmiddleName,
    required mobileNo,
    required bankName,
    required bankownerTitle,
    required iban,
    required lat,
    required long,
    required address,
    required lastName,
    required BuildContext context,
    required Uint8List image,
    required WidgetRef ref,
  }) async {
    await authRepository.registerRestaurant(
        businessEmail: businessEmail,
        bussinessName: bussinessName,
        firstmiddleName: firstmiddleName,
        mobileNo: mobileNo,
        bankName: bankName,
        bankownerTitle: bankownerTitle,
        iban: iban,
        lat: lat,
        long: long,
        address: address,
        lastName: lastName,
        context: context,
        image: image);
  }
}
