import 'dart:convert';

import 'package:baymax/models/RequestModels/create_chat_request_model.dart';
import 'package:baymax/models/ResponseModels/create_chat_response_model.dart';
import 'package:baymax/models/ResponseModels/get_chats_response_model.dart';
import 'package:baymax/models/ResponseModels/get_chats_with_id_response_model.dart';
import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/services/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

  debugPrint('========== STREAM START ==========');
  debugPrint('Chat ID: $chatId');
  debugPrint('Message: $message');
  debugPrint('Base URL: ${dio.options.baseUrl}');
  debugPrint(
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

    debugPrint('========== STREAM CONNECTED ==========');
    debugPrint('Status: ${response.statusCode}');
    debugPrint('Content-Type: ${response.headers.value('content-type')}');

    final responseBody = response.data as ResponseBody;

    String buffer = '';

    await for (final chunk in responseBody.stream) {
      final decodedChunk = utf8.decode(
        chunk,
        allowMalformed: true,
      );

      debugPrint('========== RAW CHUNK ==========');
      debugPrint(decodedChunk);

      buffer += decodedChunk;

      debugPrint('CURRENT BUFFER:');
      debugPrint(buffer);

      while (buffer.contains('\n\n')) {
        final eventEnd = buffer.indexOf('\n\n');

        final event = buffer.substring(0, eventEnd);

        buffer = buffer.substring(eventEnd + 2);

        debugPrint('========== SSE EVENT ==========');
        debugPrint(event);

        for (final line in event.split('\n')) {
          final trimmedLine = line.trim();

          debugPrint('SSE LINE: $trimmedLine');

          if (!trimmedLine.startsWith('data:')) {
            continue;
          }

          final data = trimmedLine.substring(5).trim();

          debugPrint('SSE DATA: $data');

          if (data == '[DONE]') {
            debugPrint('========== SSE DONE ==========');
            return;
          }

          try {
            final decoded = jsonDecode(data);

            debugPrint('DECODED: $decoded');

            if (decoded is Map<String, dynamic>) {
              final content = decoded['content'];

              if (content is String) {
                debugPrint('========== CONTENT ==========');
                debugPrint(content);

                onChunk(content);
              }
            }
          } catch (e) {
            debugPrint('JSON DECODE ERROR: $e');
            debugPrint('DATA WAS: $data');
          }
        }
      }
    }

    debugPrint('========== STREAM CLOSED ==========');
  } on DioException catch (e) {
    debugPrint('========== STREAM ERROR ==========');
    debugPrint('Type: ${e.type}');
    debugPrint('Message: ${e.message}');
    debugPrint('Status: ${e.response?.statusCode}');
    debugPrint('Data: ${e.response?.data}');
    debugPrint('===================================');

    rethrow;
  }
}
}