import 'package:baymax/models/ResponseModels/get_chats_response_model.dart'
    as get_chats;
import 'package:baymax/network/apiHandling/chat.dart';
import 'package:baymax/providers/chat_history_provider.dart';
import 'package:baymax/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHistoryScreen extends ConsumerStatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  ConsumerState<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends ConsumerState<ChatHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatHistoryProvider.notifier).loadRecentChats();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();

    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    const threshold = 200.0;

    if (position.pixels >= position.maxScrollExtent - threshold) {
      ref.read(chatHistoryProvider.notifier).loadMoreChats();
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime.toLocal());

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Widget recentActivity(String title, String time, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        SizedBox(
          width: 30,
          child: Column(
            children: [
              // Circle
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 198, 75),
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),

              // Line
              if (!isLast)
                Container(
                  width: 2,
                  height: 46,
                  color: const Color.fromARGB(255, 99, 99, 99),
                ),
            ],
          ),
        ),

        SizedBox(width: 10),

        // Activity content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,

                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(width: 10),

                  Text(
                    time,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 7),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatHistoryProvider);
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 20.0,
              top: 20.0,
              bottom: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chats History",
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                const FaIcon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),

          Expanded(
            child: chatState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 255, 198, 75),
                    ),
                  )
                : chatState.chats.isEmpty
                ? Center(
                    child: Text(
                      "No recent activity",
                      style: GoogleFonts.urbanist(
                        color: Colors.white70,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount:
                        chatState.chats.length +
                        (chatState.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Bottom loading indicator
                      if (index == chatState.chats.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 255, 198, 75),
                            ),
                          ),
                        );
                      }

                      final chat = chatState.chats[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                chatId: chat.id,
                                chatTitle: chat.title,
                                isQuickAction: false,
                              ),
                            ),
                          );
                          ref
                              .read(chatHistoryProvider.notifier)
                              .loadMoreChats();
                        },
                        child: Column(
                          children: [
                            recentActivity(
                              chat.title ?? "Untitled Chat",
                              _formatTime(DateTime.parse(chat.updatedAt!)),
                              index == chatState.chats.length - 1,
                            ),

                            if (index != chatState.chats.length - 1)
                              const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
