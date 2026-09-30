import 'package:baymax/models/RequestModels/auth_me_request_model.dart';
import 'package:baymax/models/ResponseModels/auth_me_response_model.dart';
import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/services/secure_storage_service.dart';

class UserDetails {
  Future<AuthMeResponseModel> fetchUserDetails(String accessToken) async {
    try {
      final response = await RetrofitService.getClient(
        token: accessToken,
      ).fetchUserDetails(AuthMeRequestModel(accessToken: accessToken));

      await SecureStorageService.setFullName(response.name!);
      await SecureStorageService.setEmail(response.email!);

      // Handle the response here
      print('User Details Fetched Successful');

      return response;
    } catch (error) {
      // Handle the error here
      print('Fetching Failed: $error');

      rethrow;
    }
  }

}
