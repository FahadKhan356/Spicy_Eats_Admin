import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/chooseplanscreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/model/Restaurantmodel.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/splashscreen.dart/SplashScreen.dart';
import 'package:spicy_eats_admin/utils/UploadImageToSupabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

var authStepsProvider = StateProvider<int?>((ref) => null);
var authRepoProvider = Provider((ref) => AuthRepository());

class AuthRepository {
//sign up
  Future<void> signup(
      {required businessEmail,
      required password,
      required BuildContext context}) async {
    try {
      final authResponse = await supabaseClient.auth.signUp(
        email: businessEmail,
        password: password,
      );

      if (authResponse.user?.id != null) {
        await signout(context);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (_) => const LoginScreen()),
        //     (route) => false);
        showCustomSnackbar(
            showFromTop: true,
            backgroundColor: Colors.black,
            context: context,
            message:
                " Account Created Successfully Sign in With Same Credentials");
      }
    } catch (e) {
      debugPrint("auth error $e");
    }
  }

  //sign in
  Future<void> signIn({
    required email,
    required password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      // final res =
      final res = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      if (res.user != null) {
        await supabaseClient
            .from('users')
            .update({
              'id': res.user!.id,
              'email': res.user!.email,
              'password': password,
              'Role': 'restaurant-admin',
              'status': 'pending',
              'Auth_steps': 1,
            })
            .eq('id', res.user!.id)
            .isFilter('Auth_steps', null);

        debugPrint('user auth steps updated ...${res.user!.email}');
      }
      showCustomSnackbar(
          context: context,
          message: 'Sign In Successfully',
          backgroundColor: Colors.black);
      Navigator.pushReplacementNamed(context, SplashScreen.routename);
    } catch (e) {
      showCustomSnackbar(
          context: context,
          message: 'Sign in failed $e',
          backgroundColor: Colors.black);
    }
  }

//store user data to user table
  Future<void> storeNewUserData(
      {required User user,
      required BuildContext context,
      required String password}) async {
    try {
      // final existinguser = await supabaseClient
      //     .from('users')
      //     .select('id')
      //     .eq('id', user.id)
      //     .maybeSingle();

      // if (existinguser == null) {
      await supabaseClient.from('users').insert({
        'id': user.id,
        'email': user.email,
        'password': password,
        'Role': 'restaurant-admin',
        'status': 'pending',
        'Auth_steps': 1,
      }).eq('id', user.id);
      // }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackbar(
            context: context, message: 'User stored and login successfully');
      });
    } catch (e) {
      throw Exception(e);
      // debugPrint('failed to signup and store user data 1 $e');
    }
    debugPrint('done sign up');
  }

  Future<void> signInWithGoogleUniversal(BuildContext context) async {
    try {
      if (kIsWeb) {
        await supabaseClient.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'http://localhost:49872',
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
      final userid = supabaseClient.auth.currentUser?.id;

      if (userid == null) {
        showCustomSnackbar(context: context, message: 'Errro: user id in null');
        return;
      }

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
    required bussinessName,
    required firstmiddleName,
    // required cnicNo,
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
  }) async {
    final user = supabaseClient.auth;

    try {
      String? imageurl = await uploadImageToSupabase(
          context,
          image,
          "Restaurant_Registeration",
          '${supabaseClient.auth.currentUser!.email}/Owner_id/id.png');

      final restaurant = Restaurant(
        iban: iban,
        bankownerTitle: bankownerTitle,
        bankname: bankName,
        userId: user.currentUser!.id,
        restaurantName: bussinessName,
        address: address,
        phoneNumber: mobileNo,
        long: long,
        lat: lat,
        businessEmail: businessEmail,
        idFirstMiddleName: firstmiddleName,
        idLastName: lastName,
        idPhotoUrl: imageurl!,
      );

      await supabaseClient.from('restaurants').insert(restaurant.toMap());

      await supabaseClient
          .from('users')
          .update({'Auth_steps': 2}).eq('email', user.currentUser!.email!);

      await Navigator.pushReplacementNamed(
        context,
        ChoosePlanScreen.routename,
      );
      showCustomSnackbar(
          context: context,
          message: 'Restaurant Details Stored Successfully',
          backgroundColor: Colors.black);
      print('Restaurant inserted successfully');
    } catch (e) {
      throw Exception(e);
      // showCustomSnackbar(
      //     context: context,
      //     message: 'Error in Resgister Restaurant $e',
      //     backgroundColor: Colors.black);
      // debugPrint('Error in Resgister Restaurant $e');
    }
  }

//sign out
  Future<void> signout(BuildContext context) async {
    try {
      await supabaseClient.auth.signOut();

      showCustomSnackbar(
        context: context,
        message: 'Log out Successfully',
        backgroundColor: Colors.black,
      );
      await Navigator.pushNamed(context, LoginScreen.routename);
    } catch (e) {
      debugPrint('Error in signout $e');
    }
  }
}
