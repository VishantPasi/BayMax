import 'package:baymax/network/api_client_factory.dart';
import 'package:baymax/retrofit/rest_client.dart';
import 'package:dio/dio.dart';


class RetrofitService {

  RetrofitService._();


  static RestClient getClient({
    String? token,
  }) {

    return RestClient(
      ApiClientFactory.create(
        token: token,
      ),
    );
  }


  static Dio getDio({
    String? token,
  }) {

    return ApiClientFactory.create(
      token: token,
    );
  }
}
