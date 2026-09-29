import 'package:baymax/models/ResponseModels/get_chats_response_model.dart';
import 'package:baymax/network/apiHandling/chat.dart';
import 'package:baymax/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<GetChatsResponseModel> _recentChats = [];
  bool _isLoadingRecentChats = true;
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();

    _loadRecentChats();
  }

  Future<void> _loadRecentChats() async {
    try {
      final chats = await _chatService.getChats();

      if (!mounted) return;

      setState(() {
        _recentChats = chats.toList();
        _isLoadingRecentChats = false;
      });
    } catch (e) {
      debugPrint('Failed to load recent chats: $e');

      if (!mounted) return;

      setState(() {
        _isLoadingRecentChats = false;
      });
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 20.0,
                top: 20.0,
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

                  FaIcon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isLoadingRecentChats
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 255, 198, 75),
                          ),
                        )
                      : _recentChats.isEmpty
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
                      : Column(
                          children: [
                            for (int i = 0; i < _recentChats.length; i++) ...[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        chatId: _recentChats[i].id,
                                      ),
                                    ),
                                  ).then((_) {
                                    _loadRecentChats();
                                  });
                                },
                                child: recentActivity(
                                  _recentChats[i].title ?? "Untitled Chat",
                                  _formatTime(
                                    DateTime.parse(_recentChats[i].updatedAt!),
                                    
                                  ),
                                  i == _recentChats.length - 1,
                                ),
                              ),

                              if (i != _recentChats.length - 1)
                                const SizedBox(height: 10),
                            ],
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
