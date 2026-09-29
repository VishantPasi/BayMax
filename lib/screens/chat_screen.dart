import 'package:baymax/network/apiHandling/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/services/ai_service.dart';
import 'package:baymax/services/secure_storage_service.dart';

class ChatScreen extends StatefulWidget {
  final String? initialPrompt;
  final bool? isQuickAction;
  final int? chatId;
  const ChatScreen({
    super.key,
    this.initialPrompt,
    this.isQuickAction,
    this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  int maxLines = 1;
  double containerHeight = 120;
  bool _isGenerating = false;
  int? _currentChatId;
  String? _chatTitle;
  bool _isUserAtBottom = true;

  final List<Map<String, dynamic>> _messages = [];

  int maxHeight() {
    if (maxLines == 1) {
      return 50;
    } else if (maxLines == 2) {
      return 150;
    } else if (maxLines == 3) {
      return 180;
    } else {
      return 210;
    }
  }

  @override
  void initState() {
    super.initState();

    

    _currentChatId = widget.chatId;

    _scrollController.addListener(_handleScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.chatId != null) {
        _loadChat();
      } else if (widget.initialPrompt != null &&
          widget.initialPrompt!.trim().isNotEmpty) {
        _messageController.text = widget.initialPrompt!;

        if (widget.isQuickAction != true) {
          _messageFocusNode.unfocus();
          sendMessage();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  Future<void> _loadChat() async {
    try {
      final accessToken = await SecureStorageService.getAccessToken();

      final dio = RetrofitService.getDio(token: accessToken);

      final response = await dio.get('/chats/${widget.chatId}');

      final data = response.data;

      _chatTitle = data['title'];

      final List<dynamic> messages = data['messages'] ?? [];

      if (!mounted) return;

      setState(() {
        _messages.clear();

        for (final message in messages) {
          _messages.add({
            'message': message['content'],
            'isUser': message['role'] == 'user',
          });
        }
      });

      _scrollToBottom();
    } catch (e) {
      debugPrint('Failed to load chat: $e');
    }
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    const double threshold = 30.0;

    final position = _scrollController.position;

    final isAtBottom = position.maxScrollExtent - position.pixels <= threshold;

    if (_isUserAtBottom != isAtBottom) {
      setState(() {
        _isUserAtBottom = isAtBottom;
      });
    }
  }

  Widget buildChatBubble(String message, bool isUser) {
    return SizedBox(
      width: double.infinity,

      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 15.0, top: 15.0),

            child: Container(
              constraints: BoxConstraints(
                maxWidth: isUser ? 250 : double.infinity,
              ),

              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                gradient: isUser
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,

                        colors: [
                          Colors.white.withValues(alpha: 0.18),
                          Colors.white.withValues(alpha: 0.10),
                        ],
                      )
                    : null,
              ),

              child: MarkdownBody(
                data: message,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),

                  strong: GoogleFonts.urbanist(
                    color: const Color.fromARGB(255, 255, 198, 75),
                    
                    fontSize: 14,
                  ),

                  listBullet: GoogleFonts.urbanist(
                    color: const Color.fromARGB(255, 255, 198, 75),
                    
                    fontSize: 14,
                  ),

                  listIndent: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage() async {
    if (_isGenerating) {
      return;
    }

    final message = _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    _messageFocusNode.unfocus();
    _messageController.clear();

    setState(() {
      _messages.add({'message': message, 'isUser': true});

      _messages.add({'message': '', 'isUser': false});

      _isGenerating = true;
    });

    _scrollToBottom();

    try {
      final chatService = ChatService();

      // Create a new chat if necessary.
      if (_currentChatId == null) {
        final response = await chatService.createChat(
          message.length > 50 ? '${message.substring(0, 50)}...' : message,
        );

        _currentChatId = response.id;
      }

      await chatService.sendMessageStream(
        chatId: _currentChatId!,
        message: message,
        onChunk: (content) {
          if (!mounted) {
            return;
          }

          setState(() {
            _messages.last['message'] = '${_messages.last['message']}$content';
          });

          _scrollToBottom();
        },
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      debugPrint('AI request failed: $e');

      setState(() {
        _messages.last['message'] =
            'Sorry, something went wrong while generating the response.';
      });
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isGenerating = false;
      });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (!_isUserAtBottom) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients || !_isUserAtBottom) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 15, 15, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20, top: 20.0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    _chatTitle ?? "New Chat",

                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              child: ListView.builder(
                controller: _scrollController,

                padding: const EdgeInsets.only(bottom: 20),

                itemCount: _messages.length,

                itemBuilder: (context, index) {
                  final message = _messages[index];

                  return buildChatBubble(message['message'], message['isUser']);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 15.0,
              ),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,

                    end: Alignment.bottomRight,

                    colors: [
                      const Color.fromARGB(255, 73, 73, 73),

                      const Color.fromARGB(115, 255, 198, 75),
                    ],
                  ),
                ),

                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5,
                      ),

                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,

                        minLines: 1,

                        maxLines: 10,

                        keyboardType: TextInputType.multiline,

                        cursorColor: Colors.white,

                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),

                        onChanged: (value) {
                          setState(() {
                            maxLines = value.split('\n').length;

                            containerHeight = maxHeight().toDouble();
                          });
                        },

                        onSubmitted: (_) {
                          if (!_isGenerating) {
                            sendMessage();
                          }
                        },

                        decoration: const InputDecoration(
                          hintText: "Ask me anything...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),

                                  color: const Color.fromARGB(31, 0, 0, 0),
                                ),

                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.microphone,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              GestureDetector(
                                onTap: _isGenerating ? null : sendMessage,

                                child: Container(
                                  height: 40,
                                  width: 40,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),

                                    color: const Color.fromARGB(31, 0, 0, 0),
                                  ),

                                  child: Center(
                                    child: _isGenerating
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,

                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.paperPlane,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
