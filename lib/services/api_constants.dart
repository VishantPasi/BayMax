import 'package:baymax/env_config.dart';

class ApiConstants {
  static String baseUrl = AppEnvironment.baseUrl;

  static const String authRegister = "/auth/signup";
  static const String authLogin = "/auth/login";
  static const String fetchDetails = "/auth/me";
  static const String createChat = "/chats";
  static const String getChats = "/chats";
  static const String getChatsWithId = "/chats/{chatId}";
  static const String sendMessage = "/chats/{chatId}/message";
  
  
  


}