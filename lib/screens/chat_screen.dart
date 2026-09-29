import 'package:baymax/network/apiHandling/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final String? initialPrompt;
  final bool? isQuickAction;
  final int? chatId;
  final String? chatTitle;
  const ChatScreen({
    super.key,
    this.initialPrompt,
    this.isQuickAction,
    required this.chatId,
    this.chatTitle,
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

  int _currentPage = 1;
  static const int _pageSize = 5;

  bool _isLoadingChat = false;
  bool _isLoadingOlder = false;
  bool _hasMoreMessages = true;
  final ChatService _chatService = ChatService();

  bool _shouldAutoScroll = true;

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
    _chatTitle = widget.chatTitle;

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

  Future<void> _loadOlderMessages() async {
    if (_isLoadingOlder || !_hasMoreMessages) {
      return;
    }

    final chatId = _currentChatId;

    if (chatId == null) {
      return;
    }

    _isLoadingOlder = true;

    try {
      final nextPage = _currentPage + 1;

      debugPrint('Loading older messages: page=$nextPage');

      final response = await _chatService.getChat(chatId, nextPage, _pageSize);

      if (!mounted) return;

      final messages = response.messages ?? [];

      if (messages.isEmpty) {
        setState(() {
          _hasMoreMessages = false;
        });

        return;
      }

      setState(() {
        // API:
        //
        // 11
        // 12
        // 13
        // 14
        // 15
        //
        // Reverse because our ListView is reversed:
        //
        // 15
        // 14
        // 13
        // 12
        // 11

        for (final message in messages.reversed) {
          _messages.add({
            'message': message.content ?? '',
            'isUser': message.role == 'user',
          });
        }

        _currentPage = nextPage;

        _hasMoreMessages = messages.length == _pageSize;
      });
    } catch (e, stackTrace) {
      debugPrint('Failed to load older messages: $e');
      debugPrint('$stackTrace');
    } finally {
      _isLoadingOlder = false;
    }
  }

  Future<void> _loadChat() async {
    final chatId = _currentChatId;

    if (chatId == null || _isLoadingChat) {
      return;
    }

    setState(() {
      _isLoadingChat = true;
    });

    try {
      final response = await _chatService.getChat(chatId, 1, _pageSize);

      if (!mounted) return;

      final messages = response.messages ?? [];

      setState(() {
        _messages.clear();

        // API gives oldest -> newest.
        // Flutter stores newest -> oldest because ListView is reversed.
        for (final message in messages.reversed) {
          _messages.add({
            'message': message.content ?? '',
            'isUser': message.role == 'user',
          });
        }

        _currentPage = 1;

        _hasMoreMessages = messages.length == _pageSize;
      });
    } catch (e, stackTrace) {
      debugPrint('Failed to load chat: $e');
      debugPrint('$stackTrace');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingChat = false;
        });
      }
    }
  }

  void _handleScroll() {
  if (!_scrollController.hasClients) {
    return;
  }

  final position = _scrollController.position;

  const threshold = 100.0;

  // reverse:true
  //
  // pixels == 0
  // -> newest messages / bottom
  //
  // maxScrollExtent
  // -> oldest messages / top

  final isAtBottom = position.pixels <= threshold;

  if (_isUserAtBottom != isAtBottom) {
    setState(() {
      _isUserAtBottom = isAtBottom;
    });

    // If user manually scrolls away from bottom,
    // STOP automatic streaming scroll.
    if (!isAtBottom) {
      _shouldAutoScroll = false;
    }
  }

  // Load older messages when user reaches the TOP.
  if (position.pixels >=
          position.maxScrollExtent - threshold &&
      !_isLoadingOlder &&
      _hasMoreMessages) {
    _loadOlderMessages();
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

  // Remember whether the user was at the bottom
  // BEFORE adding the new message.
  _shouldAutoScroll = _isUserAtBottom;

  setState(() {
    _messages.insert(0, {
      'message': message,
      'isUser': true,
    });

    _messages.insert(0, {
      'message': '',
      'isUser': false,
    });

    _isGenerating = true;
  });

  _scrollToBottom();

  try {
    final chatService = ChatService();

    if (_currentChatId == null) {
      final response = await chatService.createChat(
        message.length > 50
            ? '${message.substring(0, 50)}...'
            : message,
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
          _messages[0]['message'] =
              '${_messages[0]['message']}$content';
        });

        if (_shouldAutoScroll) {
          _scrollToBottom();
        }
      },
    );
  } catch (e) {
    if (!mounted) {
      return;
    }

    debugPrint('AI request failed: $e');

    setState(() {
      _messages[0]['message'] =
          'Sorry, something went wrong while generating the response.';
    });
  } finally {
    if (!mounted) {
      return;
    }

    setState(() {
      _isGenerating = false;
    });

    if (_shouldAutoScroll) {
      _scrollToBottom();
    }
  }
}

  void _scrollToBottom() {
  if (!_shouldAutoScroll) {
    return;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) {
      return;
    }

    if (!_scrollController.hasClients) {
      return;
    }

    if (!_shouldAutoScroll) {
      return;
    }

    _scrollController.jumpTo(0);
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
                reverse: true,
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];

                  return buildChatBubble(
                    message['message'] as String,
                    message['isUser'] as bool,
                  );
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
