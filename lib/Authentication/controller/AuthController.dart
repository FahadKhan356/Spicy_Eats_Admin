import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spicy_eats_admin/Authentication/model/user.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';

var restaurantLatProvider = StateProvider<double?>((ref) => null);
var restaurantLongProvider = StateProvider<double?>((ref) => null);
var restaurantAddProvider = StateProvider<String?>((ref) => null);
var restaurantLocationSelectedProvider = StateProvider<bool?>((ref) => null);

var authControllerProvider = Provider((ref) {
  final authrepo = ref.watch(authRepoProvider);

  return AuthController(authRepository: authrepo, ref: ref);
});

class AuthController {
  AuthController({required this.authRepository, required this.ref});
  AuthRepository authRepository;
  Ref ref;

  void singupAndStoreNewUserData({
    required businessEmail,
    required password,
    required firstmiddleName,
    required contackNo,
    String? lastName,
  }) {
    try {
      authRepository.storeNewUserData(
        businessEmail: businessEmail,
        password: password,
        firstmiddleName: firstmiddleName,
        lastName: lastName,
        contackNo: contackNo,
      );
    } catch (e) {
      // throw Exception(e);
      debugPrint('failed to signup and store user data $e');
    }
  }
}
