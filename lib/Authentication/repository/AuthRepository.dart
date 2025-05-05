import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  Future<void> storeNewUserData({
    required businessEmail,
    required password,
    required firstmiddleName,
    required contackNo,
    String? lastName,
  }) async {
    try {
      final user =
          await signup(businessEmail: businessEmail, password: password);
      if (user.userId == null) {
        debugPrint('sign up failed');
        return;
      }
      // Check if user already exists in the 'users' table
      // final existingUser = await supabaseClient
      //     .from('users')
      //     .select('id')
      //     .eq('id', user.userId!)
      //     .maybeSingle();

      // if (existingUser != null) {
      //   debugPrint('User already exists in users table.');
      //   return;
      // }
      // final userdata = User(
      //   id: user.userId,
      //   contactno: contackNo,
      //   email: businessEmail,
      //   firstname: firstmiddleName,
      //   role: 'restaurant-admin',
      //   password: password,
      //   lastname: lastName,
      // );

      // await supabaseClient.from('users').insert(userdata.toMap());
    } catch (e) {
      // throw Exception(e);
      debugPrint('failed to signup and store user data 1 $e');
    }
    debugPrint('done sign up');
  }

  Future<void> signInWithGoogleUniversal() async {
    if (kIsWeb) {
      await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'http://localhost:3000/auth/callback',
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
  }
}

// //register restaurant
//   Future<void> registerRestaurant({
//     required businessEmail,
//     required password,
//     required bussinessName,
//     required firstmiddleName,
//     required cnicNo,
//     required mobileNo,
//     required bankName,
//     required bankownerTitle,
//     required iban,
//     required Uint8List cnicPhoto,
//     required lat,
//     required long,
//     required address,
//     required lastName,
//   }) async {
//     try {
//       //sign up
//       final response =
//           await signup(businessEmail: businessEmail, password: password);
//       if (response.userId == null) {
//         throw Exception('failed to signup');
//       }
//       print('sucessfully sign up ${response.userId}');
//       //uploading image and retrieving url
//       final cnicPhotoUrl = await uploadSupabseStorageGetRrl(
//           foldername: 'bussinessdocuments',
//           imagepath: 'CnicPhoto/${response.userId}',
//           file: cnicPhoto);

//       if (cnicPhotoUrl == null) {
//         throw Exception('Failed to upload CNIC photo');
//       }
//       print('cnic photourl ${cnicPhotoUrl}');
//       final restaurant = Restaurant(
//           iban: iban,
//           bankownerTitle: bankownerTitle,
//           bankname: bankName,
//           userId: supabaseClient.auth.currentUser!.id,
//           restaurantName: bussinessName,
//           address: address,
//           phoneNumber: mobileNo,
//           idNumber: cnicNo,
//           long: long,
//           lat: lat,
//           businessEmail: businessEmail,
//           idFirstMiddleName: firstmiddleName,
//           idLastName: lastName,
//           idPhotoUrl: cnicPhotoUrl);

//       final res =
//           await supabaseClient.from('restaurants').insert(restaurant.toMap());

//       if (res.error != null) {
//         print('Error inserting restaurant: ${response.error!}');
//       } else {
//         print('Restaurant inserted successfully');
//       }
//     } catch (e) {
//       debugPrint('Error in Resgister Restaurant $e');
//     }
//   }
// }
