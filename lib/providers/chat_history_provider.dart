import 'package:baymax/models/ResponseModels/get_chats_response_model.dart';
import 'package:baymax/network/apiHandling/chat.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChatHistoryState {
  final List<Items> chats;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;

  const ChatHistoryState({
    this.chats = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
  });

  ChatHistoryState copyWith({
    List<Items>? chats,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
  }) {
    return ChatHistoryState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, ChatHistoryState>(
  (ref) {
    return ChatHistoryNotifier();
  },
);

class ChatHistoryNotifier extends StateNotifier<ChatHistoryState> {
  ChatHistoryNotifier() : super(const ChatHistoryState());

  final ChatService _chatService = ChatService();

  static const int pageSize = 20;

  Future<void> loadRecentChats({bool forceRefresh = false}) async {
  // Don't reload if already loading,
  // unless this is an explicit refresh.
  if (state.isLoading && !forceRefresh) {
    return;
  }

  state = state.copyWith(
    isLoading: true,
  );

  try {
    final response = await _chatService.getChats(
      1,
      pageSize,
    );

    final chats = response.items ?? [];

    state = state.copyWith(
      chats: chats,
      currentPage: 1,
      hasMore: response.hasNext ?? false,
      isLoading: false,
      isLoadingMore: false,
    );
  } catch (e, stackTrace) {
    print('Failed to load recent chats: $e');
    print(stackTrace);

    state = state.copyWith(
      isLoading: false,
    );
  }
}

  Future<void> loadMoreChats() async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(
      isLoadingMore: true,
    );

    try {
      final nextPage = state.currentPage + 1;

      final response = await _chatService.getChats(
        nextPage,
        pageSize,
      );

      final newChats = response.items ?? [];

      state = state.copyWith(
        chats: [
          ...state.chats,
          ...newChats,
        ],
        currentPage: nextPage,
        hasMore: response.hasNext ?? false,
        isLoadingMore: false,
      );
    } catch (e, stackTrace) {
      print('Failed to load more chats: $e');
      print(stackTrace);

      state = state.copyWith(
        isLoadingMore: false,
      );
    }
  }
}