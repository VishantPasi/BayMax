import 'package:baymax/models/RequestModels/sign_in_request_model.dart';
import 'package:baymax/models/RequestModels/sign_up_request_model.dart';
import 'package:baymax/models/ResponseModels/sign_in_response_model.dart';
import 'package:baymax/models/ResponseModels/sign_up_response_model.dart';
import 'package:dio/dio.dart';

import 'package:baymax/services/api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';


@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

   @POST(ApiConstants.authRegister)
   Future<SignUpResponseModel> signUp(
    @Body() SignUpRequestModel request
  );

   @POST(ApiConstants.authLogin)
   Future<SignInResponseModel> signIn(
    @Body() SignInRequestModel request
  );

  // @POST(ApiConstants.uploadFile)
  // @MultiPart()
  // Future<void> uploadFile(
  //   @Part(name: "uid") String uid,
  //   @Part(name: "folderId") String folderId,
  //   @Part(name: "file") MultipartFile file,
  // );
  
  // @DELETE(ApiConstants.deleteFolder)
  // Future<DeleteFolderResponseModel> deleteFolder(
  //   @Body() DeleteFolderRequestModel request
  // );

  // @DELETE(ApiConstants.delete)
  // Future<DeleteFileResponseModel> delete(
  //   @Body() DeleteFileRequestModel request
  // );

}

