import 'package:baymax/models/ResponseModels/auth_me_response_model.dart';
import 'package:baymax/network/apiHandling/userDetails.dart';
import 'package:baymax/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userProvider = AsyncNotifierProvider<UserNotifier, AuthMeResponseModel?>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<AuthMeResponseModel?>{

  @override
  Future<AuthMeResponseModel?> build() async {
    final accessToken = await SecureStorageService.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    return await Userdetails().fetchUserDetails(accessToken);
  }

  void setUser(AuthMeResponseModel user){
    state = AsyncData(user);
  }

  Future<void> fetchUser() async {
    state = await AsyncValue.guard(() async {
      final accessToken = await SecureStorageService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty){
        return null;
      }

      return await Userdetails().fetchUserDetails(accessToken);
    });
  }



  Future<void> refreshUser() async {
    await fetchUser();
  }

  void clearUser(){
    state = const AsyncData(null);
  }
}