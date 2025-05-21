import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Register/model/Restaurantmodel.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

var authStepsProvider = StateProvider<int?>((ref) => null);
var authRepoProvider = Provider((ref) => AuthRepository());

class AuthRepository {
//sign up
  Future<({String? userId, String? error})> signup(
      {required businessEmail, required password}) async {
    try {
      final authResponse = await supabaseClient.auth.signUp(
        email: businessEmail,
        password: password,
      );
      if (authResponse.user?.id != null) {
        return (userId: authResponse.user?.id, error: null);
      } else {
        return (userId: null, error: "Signup failed - no user ID returned");
      }
    } catch (e) {
      debugPrint("auth error $e");
      return (userId: null, error: e.toString());
    }
  }

//store user data to user table
  Future<void> storeNewUserData(
      {required User user, required BuildContext context}) async {
    try {
      final existinguser = await supabaseClient
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      if (existinguser == null && user != null) {
        await supabaseClient.from('users').insert({
          'id': user.id,
          'email': user.email,
          'Role': 'restaurant-admin',
          'status': 'pending',
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackbar(
            context: context, message: 'User stored and login successfully');
      });
    } catch (e) {
      // throw Exception(e);
      debugPrint('failed to signup and store user data 1 $e');
    }
    debugPrint('done sign up');
  }

  Future<void> signInWithGoogleUniversal(BuildContext context) async {
    try {
      if (kIsWeb) {
        await supabaseClient.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'http://localhost:51591',
        );
      } else {
        const webClientId =
            '1018000999497-f8j2q1fg4gu1i95d33apej6v42mq9km0.apps.googleusercontent.com';
        GoogleSignIn googleSignIn = GoogleSignIn(
          serverClientId: webClientId,
          // Optional clientId
          // clientId: 'your-client_id.apps.googleusercontent.com',
        );
        // Android/iOS implementation
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        final accessToken = googleAuth.accessToken;
        final idtoken = googleAuth.idToken;

        if (accessToken == null) {
          throw 'No access token found';
        }
        if (idtoken == null) {
          throw 'No access token found';
        }

        await Supabase.instance.client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: accessToken,
        );
      }
    } catch (e) {
      debugPrint('Auth Error $e');
    }
  }

//to change auth steps
  Future<void> checkAuthSteps(BuildContext context, WidgetRef ref) async {
    try {
      final userid = supabaseClient.auth.currentUser!.id;

      final response = await supabaseClient
          .from('users')
          .select('Auth_steps')
          .eq('id', userid)
          .maybeSingle();
      if (response != null || response!['Auth_steps'] != null) {
        ref.read(authStepsProvider.notifier).state = response['Auth_steps'];
      } else {
        throw Exception('Auth_steps not found');
      }
    } catch (e) {
      showCustomSnackbar(
          context: context,
          message: e.toString(),
          backgroundColor: Colors.black);
    }
  }

//register restaurant
  Future<void> registerRestaurant({
    required businessEmail,
    required password,
    required bussinessName,
    required firstmiddleName,
    required cnicNo,
    required mobileNo,
    required bankName,
    required bankownerTitle,
    required iban,
    required Uint8List cnicPhoto,
    required lat,
    required long,
    required address,
    required lastName,
  }) async {
    try {
      //sign up
      // final response =
      //     await signup(businessEmail: businessEmail, password: password);
      // if (response.userId == null) {
      //   throw Exception('failed to signup');
      // }
      // print('sucessfully sign up ${response.userId}');
      //uploading image and retrieving url
      // final cnicPhotoUrl = await uploadSupabseStorageGetRrl(
      //     foldername: 'bussinessdocuments',
      //     imagepath: 'CnicPhoto/${response.userId}',
      //     file: cnicPhoto);

      // if (cnicPhotoUrl == null) {
      //   throw Exception('Failed to upload CNIC photo');
      // }

      final restaurant = Restaurant(
        iban: iban,
        bankownerTitle: bankownerTitle,
        bankname: bankName,
        userId: supabaseClient.auth.currentUser!.id,
        restaurantName: bussinessName,
        address: address,
        phoneNumber: mobileNo,
        idNumber: cnicNo,
        long: long,
        lat: lat,
        businessEmail: businessEmail,
        idFirstMiddleName: firstmiddleName,
        idLastName: lastName,
        idPhotoUrl: '',
      );

      final res =
          await supabaseClient.from('restaurants').insert(restaurant.toMap());

      if (res.error != null) {
      } else {
        print('Restaurant inserted successfully');
      }
    } catch (e) {
      debugPrint('Error in Resgister Restaurant $e');
    }
  }
}
