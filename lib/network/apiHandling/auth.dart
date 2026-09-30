import 'package:baymax/models/RequestModels/google_sign_in_request_model.dart';
import 'package:baymax/models/RequestModels/sign_in_request_model.dart';
import 'package:baymax/models/RequestModels/sign_up_request_model.dart';
import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/screens/home_screen.dart';
import 'package:baymax/services/api_constants.dart';
import 'package:baymax/services/secure_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final String _webSdkClientId = ApiConstants.webSdkURL;
      

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // 1. Initialize Google Sign In
      await _googleSignIn.initialize(
        serverClientId: _webSdkClientId,
      );

      // 2. Select Google account
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      // 3. Get Google authentication
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // 4. Create Firebase credential
      final AuthCredential credential =
          GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 5. Authenticate with Firebase
      final UserCredential firebaseCredential =
          await _firebaseAuth.signInWithCredential(
        credential,
      );

      final User? firebaseUser = firebaseCredential.user;

      if (firebaseUser == null) {
        throw Exception("Firebase Google authentication failed");
      }

      // 6. Get Firebase ID token
      final String? firebaseIdToken =
          await firebaseUser.getIdToken();

      if (firebaseIdToken == null) {
        throw Exception("Unable to get Firebase ID token");
      }

      print("Firebase UID: ${firebaseUser.uid}");
      print("Email: ${firebaseUser.email}");

      // 7. Send Firebase token to YOUR FastAPI backend
      final response =
          await RetrofitService.getClient().googleSignIn(
            GoogleSignInRequestModel(idToken: firebaseIdToken)
        ,
      );

      // 8. Save YOUR BayMax access token
      await SecureStorageService.saveAccessToken(
        response.accessToken!,
      );

      // 9. Navigate to BayMax
      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            accessToken: response.accessToken!,
          ),
        ),
        (route) => false,
      );

      print(
        "Google Sign In Successful: ${response.accessToken}",
      );
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code}");
      print(e.message);
    } on GoogleSignInException catch (e) {
      print("Google Sign In Error: ${e.code}");
      print(e.description);
    } catch (error) {
      print("Google Sign In Failed: $error");
    }
  }



  Future<void> signUp(
    BuildContext context,
    String email,
    String password,
    String phone,
    String name,
  ) async {
    try {
      final response = await RetrofitService.getClient().signUp(
        SignUpRequestModel(
          email: email,
          password: password,
          phone: phone,
          name: name,
        ),
      );

      await SecureStorageService.saveAccessToken(
        response.accessToken!,
      );

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(accessToken: response.accessToken!),
        ),
        (route) => false,
      );

      // Handle the response here
      print('Sign Up Successful: ${response.accessToken}');
    } catch (error) {
      // Handle the error here
      print('Sign Up Failed: $error');
    }
  }

  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await RetrofitService.getClient().signIn(
        SignInRequestModel(email: email, password: password),
      );

      await SecureStorageService.saveAccessToken(response.accessToken!);

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(accessToken: response.accessToken!),
        ),
        (route) => false,
      );

      // Handle the response here
      print('Sign In Successful: ${response.accessToken}');
    } catch (error) {
      // Handle the error here
      print('Sign In Failed: $error');
    }
  }
}
