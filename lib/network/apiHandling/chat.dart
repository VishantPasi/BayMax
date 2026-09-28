import 'package:baymax/models/RequestModels/create_chat_request_model.dart';
import 'package:baymax/models/RequestModels/send_message_request_model.dart';
import 'package:baymax/models/ResponseModels/create_chat_response_model.dart';
import 'package:baymax/models/ResponseModels/get_chats_response_model.dart';
import 'package:baymax/models/ResponseModels/get_chats_with_id_response_model.dart';
import 'package:baymax/models/ResponseModels/send_message_response_model.dart';
import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/services/secure_storage_service.dart';

class ChatService {
  Future<CreateChatResponseModel> createChat(String title) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await RetrofitService.getClient(
      token: token,
    ).createChat(CreateChatRequestModel(title: title));

    return response;
  }

  Future<List<GetChatsResponseModel>> getChats() async {
    final token = await SecureStorageService.getAccessToken();

    final response = await RetrofitService.getClient(token: token).getChats();

    return response;
  }

  Future<GetChatsWithIdResponseModel> getChat(int chatId) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await RetrofitService.getClient(
      token: token,
    ).getChatsWithId(chatId);

    return response;
  }

  Future<SendMessageResponseModel> saveMessage(
    int chatId,
    String message,
  ) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await RetrofitService.getClient(
      token: token,
    ).sendMessage(chatId, SendMessageRequestModel(message: message));

    return response;
  }
}
