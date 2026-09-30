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
  required CancelToken cancelToken,
  required Function(String content) onChunk,
}) async {
  final token = await SecureStorageService.getAccessToken();

  final dio = RetrofitService.getDio(token: token);

  print('========== STREAM START ==========');
  print('Chat ID: $chatId');
  print('Message: $message');
  print('Base URL: ${dio.options.baseUrl}');
  print(
    'Authorization exists: '
    '${dio.options.headers['Authorization'] != null}',
  );

  try {
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
      cancelToken: cancelToken,
    );

    print('========== STREAM CONNECTED ==========');
    print('Status: ${response.statusCode}');
    print('Content-Type: ${response.headers.value('content-type')}');

    final responseBody = response.data as ResponseBody;

    String buffer = '';

    await for (final chunk in responseBody.stream) {
      final decodedChunk = utf8.decode(
        chunk,
        allowMalformed: true,
      );

      print('========== RAW CHUNK ==========');
      print(decodedChunk);

      buffer += decodedChunk;

      print('CURRENT BUFFER:');
      print(buffer);

      while (buffer.contains('\n\n')) {
        final eventEnd = buffer.indexOf('\n\n');

        final event = buffer.substring(0, eventEnd);

        buffer = buffer.substring(eventEnd + 2);

        print('========== SSE EVENT ==========');
        print(event);

        for (final line in event.split('\n')) {
          final trimmedLine = line.trim();

          print('SSE LINE: $trimmedLine');

          if (!trimmedLine.startsWith('data:')) {
            continue;
          }

          final data = trimmedLine.substring(5).trim();

          print('SSE DATA: $data');

          if (data == '[DONE]') {
            print('========== SSE DONE ==========');
            return;
          }

          try {
            final decoded = jsonDecode(data);

            print('DECODED: $decoded');

            if (decoded is Map<String, dynamic>) {
              final content = decoded['content'];

              if (content is String) {
                print('========== CONTENT ==========');
                print(content);

                onChunk(content);
              }
            }
          } catch (e) {
            print('JSON DECODE ERROR: $e');
            print('DATA WAS: $data');
          }
        }
      }
    }

    print('========== STREAM CLOSED ==========');
  } on DioException catch (e) {
    print('========== STREAM ERROR ==========');
    print('Type: ${e.type}');
    print('Message: ${e.message}');
    print('Status: ${e.response?.statusCode}');
    print('Data: ${e.response?.data}');
    print('===================================');

    rethrow;
  }
}
}