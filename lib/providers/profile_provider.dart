
import 'package:baymax/models/ResponseModels/auth_me_response_model.dart';
import 'package:baymax/network/apiHandling/userDetails.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, AuthMeResponseModel?>(
  ProfileNotifier.new,
);


class ProfileNotifier
    extends AsyncNotifier<AuthMeResponseModel?> {

  @override
  Future<AuthMeResponseModel?> build() async {
    return null;
  }

  Future<void> loadProfile({
    required String token,
  }) async {
    state = const AsyncLoading();

    try {
      final profile = await UserDetails().fetchUserDetails(
         token,
      );

      state = AsyncData(profile);
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }

  Future<void> refreshProfile({
    required String token,
  }) async {
    try {
      final profile =await UserDetails().fetchUserDetails(
         token,
      );

      state = AsyncData(profile);
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }
}

