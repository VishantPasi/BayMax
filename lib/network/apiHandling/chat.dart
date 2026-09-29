import 'dart:convert';

import 'package:baymax/models/RequestModels/create_chat_request_model.dart';
import 'package:baymax/models/ResponseModels/create_chat_response_model.dart';
import 'package:baymax/models/ResponseModels/get_chats_response_model.dart';
import 'package:baymax/models/ResponseModels/get_chats_with_id_response_model.dart';
import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/services/secure_storage_service.dart';
import 'package:dio/dio.dart';

class ChatService {
  Future<CreateChatResponseModel> createChat(String title) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await RetrofitService.getClient(
      token: token,
    ).createChat(
      CreateChatRequestModel(title: title),
    );

    return response;
  }

  Future<GetChatsResponseModel> getChats(int page, int pageSize) async {
    final token = await SecureStorageService.getAccessToken();

    final response =
        await RetrofitService.getClient(token: token).getChats(page, pageSize);

    return response;
  }

  Future<GetChatsWithIdResponseModel> getChat(int chatId, int page, int pageSize) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await RetrofitService.getClient(
      token: token,
    ).getChatsWithId(chatId, page, pageSize);

    return response;
  }

  Future<void> sendMessageStream({
    required int chatId,
    required String message,
    required void Function(String content) onChunk,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    final dio = RetrofitService.getDio(token: token);

    final response = await dio.post(
      '/chats/$chatId/messages',
      data: {
        'message': message,
      },
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          'Accept': 'text/event-stream',
        },
      ),
    );

    final stream = response.data.stream;

    String buffer = '';

    await for (final chunk in stream) {
      buffer += utf8.decode(chunk, allowMalformed: true);

      while (buffer.contains('\n')) {
        final newlineIndex = buffer.indexOf('\n');

        String line = buffer.substring(0, newlineIndex);

        buffer = buffer.substring(newlineIndex + 1);

        line = line.trim();

        if (line.isEmpty) {
          continue;
        }

        if (!line.startsWith('data:')) {
          continue;
        }

        final data = line.substring(5).trim();

        if (data == '[DONE]') {
          return;
        }

        try {
          final decoded = jsonDecode(data);

          if (decoded is Map<String, dynamic>) {
            final content = decoded['content'];

            if (content is String) {
              onChunk(content);
            }
          }
        } catch (e) {
          // Ignore malformed/incomplete SSE lines.
        }
      }
    }
  }
}