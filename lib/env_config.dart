enum Environment { dev, prod }

abstract class AppEnvironment {
  static late String baseUrl;
  static late String webSdkURL;
  static late String environmentName;

  static late Environment _environment;
  static Environment get environment => _environment;

  static void setUpEnv(Environment environment) {
    _environment = environment;

    switch (_environment) {
      case Environment.dev:
        // baseUrl = "http://192.168.7.14:8000";
        baseUrl = "http://10.227.62.199:8000";
        webSdkURL = "85903431634-5qot5ou85dn5ofu5bb74cci5b5mee95e.apps.googleusercontent.com";
        environmentName = "DEV";
        break;

      case Environment.prod:
        baseUrl = "http://192.168.7.15:8000";
        webSdkURL = "85903431634-5qot5ou85dn5ofu5bb74cci5b5mee95e.apps.googleusercontent.com";
        environmentName = "PROD";
        break;
    }
  }
}
