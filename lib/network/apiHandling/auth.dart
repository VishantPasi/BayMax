import 'package:baymax/models/RequestModels/sign_in_request_model.dart';
import 'package:baymax/models/RequestModels/sign_up_request_model.dart';
import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/screens/home_screen.dart';
import 'package:baymax/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

class Auth {


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

  
      await SecureStorageService.saveAccessToken(response.accessToken!);

      
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      
      // Handle the response here
      print('Sign Up Successful: ${response.accessToken}');
    } catch (error) {
      // Handle the error here
      print('Sign Up Failed: $error');
    }
  }

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      final response = await RetrofitService.getClient().signIn(
        SignInRequestModel(email: email, password: password),
      );


      await SecureStorageService.saveAccessToken(response.accessToken!);
    
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      // Handle the response here
      print('Sign In Successful: ${response.accessToken}');
    } catch (error) {
      // Handle the error here
      print('Sign In Failed: $error');
    }
  }
}
