import 'package:baymax/network/apiHandling/chat.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:dio/dio.dart';

class ChatState {
  final List<Map<String, dynamic>> messages;
  final bool isGenerating;
  final bool isLoadingChat;
  final bool isLoadingOlder;
  final bool hasMoreMessages;
  final int currentPage;
  final int? chatId;
  final String? chatTitle;

  const ChatState({
    this.messages = const [],
    this.isGenerating = false,
    this.isLoadingChat = false,
    this.isLoadingOlder = false,
    this.hasMoreMessages = true,
    this.currentPage = 1,
    this.chatId,
    this.chatTitle,
  });

  ChatState copyWith({
    List<Map<String, dynamic>>? messages,
    bool? isGenerating,
    bool? isLoadingChat,
    bool? isLoadingOlder,
    bool? hasMoreMessages,
    int? currentPage,
    int? chatId,
    String? chatTitle,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      isLoadingChat: isLoadingChat ?? this.isLoadingChat,
      isLoadingOlder: isLoadingOlder ?? this.isLoadingOlder,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      currentPage: currentPage ?? this.currentPage,
      chatId: chatId ?? this.chatId,
      chatTitle: chatTitle ?? this.chatTitle,
    );
  }
}

final chatProvider =
    StateNotifierProvider.family<ChatNotifier, ChatState, int?>((ref, chatId) {
      return ChatNotifier(chatId: chatId);
    });

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier({int? chatId}) : super(ChatState(chatId: chatId));

  final ChatService _chatService = ChatService();

  static const int pageSize = 5;

  CancelToken? _cancelToken;


  @override
void dispose() {
  _cancelToken?.cancel(
    'Chat screen disposed',
  );

  super.dispose();
}

  // ==========================================================
  // LOAD CHAT
  // ==========================================================

  Future<void> loadChat() async {
    final chatId = state.chatId;

    if (chatId == null || state.isLoadingChat) {
      return;
    }

    state = state.copyWith(isLoadingChat: true);

    try {
      final response = await _chatService.getChat(chatId, 1, pageSize);

      final messages = response.messages ?? [];

      final updatedMessages = <Map<String, dynamic>>[];

      // API: oldest -> newest
      // ListView is reversed
      for (final message in messages.reversed) {
        updatedMessages.add({
          'message': message.content ?? '',
          'isUser': message.role == 'user',
        });
      }

      state = state.copyWith(
        messages: updatedMessages,
        currentPage: 1,
        hasMoreMessages: messages.length == pageSize,
        isLoadingChat: false,
      );
    } catch (e, stackTrace) {
      print('Failed to load chat: $e');

      print(stackTrace);

      state = state.copyWith(isLoadingChat: false);
    }
  }


  void stopGeneration() {
  if (!state.isGenerating) {
    return;
  }

  _cancelToken?.cancel(
    'Generation stopped by user',
  );
}

  // ==========================================================
  // LOAD OLDER MESSAGES
  // ==========================================================

  Future<void> loadOlderMessages() async {
    if (state.isLoadingOlder || !state.hasMoreMessages) {
      return;
    }

    final chatId = state.chatId;

    if (chatId == null) {
      return;
    }

    state = state.copyWith(isLoadingOlder: true);

    try {
      final nextPage = state.currentPage + 1;

      final response = await _chatService.getChat(chatId, nextPage, pageSize);

      final messages = response.messages ?? [];

      if (messages.isEmpty) {
        state = state.copyWith(hasMoreMessages: false, isLoadingOlder: false);

        return;
      }

      final updatedMessages = List<Map<String, dynamic>>.from(state.messages);

      for (final message in messages.reversed) {
        updatedMessages.add({
          'message': message.content ?? '',
          'isUser': message.role == 'user',
        });
      }

      state = state.copyWith(
        messages: updatedMessages,
        currentPage: nextPage,
        hasMoreMessages: messages.length == pageSize,
        isLoadingOlder: false,
      );
    } catch (e, stackTrace) {
      print('Failed to load older messages: $e');

      print(stackTrace);

      state = state.copyWith(isLoadingOlder: false);
    }
  }

  // ==========================================================
  // SEND MESSAGE
  // ==========================================================

  Future<void> sendMessage({
  required String message,
  required Function() onChatCreated,
  required Function(String content) onChunk,
}) async {
  print('========== SEND MESSAGE START ==========');
  print('Message: $message');
  print('Current chat ID: ${state.chatId}');
  print('Is generating: ${state.isGenerating}');

  if (state.isGenerating) {
    print('BLOCKED: Already generating');
    return;
  }

  final trimmedMessage = message.trim();

  if (trimmedMessage.isEmpty) {
    print('BLOCKED: Empty message');
    return;
  }

  final updatedMessages =
      List<Map<String, dynamic>>.from(state.messages);

  updatedMessages.insert(0, {
    'message': trimmedMessage,
    'isUser': true,
  });

  updatedMessages.insert(0, {
    'message': '',
    'isUser': false,
  });

  state = state.copyWith(
    messages: updatedMessages,
    isGenerating: true,
  );

  _cancelToken = CancelToken();

  try {
    int? currentChatId = state.chatId;

    print('Current chat ID before create: $currentChatId');

    if (currentChatId == null) {
      print('Creating new chat...');

      final response = await _chatService.createChat(
        trimmedMessage.length > 50
            ? '${trimmedMessage.substring(0, 50)}...'
            : trimmedMessage,
      );

      currentChatId = response.id;

      print('NEW CHAT CREATED: $currentChatId');

      state = state.copyWith(
        chatId: currentChatId,
      );

      onChatCreated();
    }

    print('Starting stream...');
    print('Chat ID: $currentChatId');
    print('Message: $trimmedMessage');

    await _chatService.sendMessageStream(
      chatId: currentChatId!,
      message: trimmedMessage,
      cancelToken: _cancelToken!,
      onChunk: (content) {
        print('CHUNK RECEIVED: $content');

        final messages =
            List<Map<String, dynamic>>.from(state.messages);

        if (messages.isEmpty) return;

        messages[0]['message'] =
            '${messages[0]['message']}$content';

        state = state.copyWith(
          messages: messages,
        );

        onChunk(content);
      },
    );

    print('STREAM FINISHED');

  } on DioException catch (e) {
    print('DIO ERROR');
    print('Type: ${e.type}');
    print('Message: ${e.message}');
    print('Response: ${e.response?.data}');

    if (e.type == DioExceptionType.cancel) {
      print('Generation stopped by user.');
      return;
    }

    final messages =
        List<Map<String, dynamic>>.from(state.messages);

    if (messages.isNotEmpty) {
      messages[0]['message'] =
          'Sorry, something went wrong while generating the response.';
    }

    state = state.copyWith(
      messages: messages,
    );

  } catch (e, stackTrace) {
    print('GENERAL ERROR: $e');
    print(stackTrace);

    final messages =
        List<Map<String, dynamic>>.from(state.messages);

    if (messages.isNotEmpty) {
      messages[0]['message'] =
          'Sorry, something went wrong while generating the response.';
    }

    state = state.copyWith(
      messages: messages,
    );

  } finally {
    print('========== SEND MESSAGE END ==========');

    _cancelToken = null;

    state = state.copyWith(
      isGenerating: false,
    );
  }
}
}
