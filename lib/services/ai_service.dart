import 'dart:convert';

import 'package:dio/dio.dart';


class AIService {

  final Dio dio;


  AIService(this.dio);


  Stream<String> streamChat(
    String message, {
    CancelToken? cancelToken,
  }) async* {

    final response = await dio.post(
      '/ai/chat',

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


    final responseStream =
        response.data.stream;


    String buffer = '';


    await for (final chunk in responseStream) {

      buffer += utf8.decode(
        chunk,
        allowMalformed: true,
      );


      while (buffer.contains('\n\n')) {

        final separatorIndex =
            buffer.indexOf('\n\n');


        final event =
            buffer.substring(
          0,
          separatorIndex,
        );


        buffer =
            buffer.substring(
          separatorIndex + 2,
        );


        for (final line in event.split('\n')) {

          if (!line.startsWith('data:')) {
            continue;
          }


          final data =
              line.substring(5).trim();


          if (data == '[DONE]') {
            return;
          }


          try {

            final jsonData =
                jsonDecode(data);


            // Backend error
            if (jsonData['error'] != null) {

              throw Exception(
                jsonData['error'].toString(),
              );
            }


            final content =
                jsonData['content'];


            if (content is String &&
                content.isNotEmpty) {

              yield content;
            }

          } catch (e) {

            if (e is Exception) {
              rethrow;
            }

            continue;
          }
        }
      }
    }
  }
}

