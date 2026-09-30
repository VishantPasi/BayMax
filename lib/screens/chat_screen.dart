import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:baymax/providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
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
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  int maxLines = 1;
  double containerHeight = 120;
  bool _isUserAtBottom = true;

  static const int _pageSize = 5;
  bool _shouldAutoScroll = true;

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

  _scrollController.addListener(_handleScroll);

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (!mounted) return;

    // Existing chat
    if (widget.chatId != null) {
      await ref.read(chatProvider(widget.chatId).notifier).loadChat();
    }

    // Prompt coming from HomeScreen
    if (widget.initialPrompt != null &&
        widget.initialPrompt!.trim().isNotEmpty) {
      
      final prompt = widget.initialPrompt!.trim();

      _messageController.text = prompt;

      // Automatically send HomeScreen prompt
      if (widget.isQuickAction != true) {
        _messageFocusNode.unfocus();

        await sendMessage();
      } else {
        // Quick action should allow user to edit/add text
        _messageFocusNode.requestFocus();
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

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    const threshold = 100.0;

    final isAtBottom = position.pixels <= threshold;

    if (_isUserAtBottom != isAtBottom) {
      setState(() {
        _isUserAtBottom = isAtBottom;
      });

      if (!isAtBottom) {
        _shouldAutoScroll = false;
      }
    }

    if (position.pixels >= position.maxScrollExtent - threshold) {
      ref.read(chatProvider(widget.chatId).notifier).loadOlderMessages();
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
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    _messageFocusNode.unfocus();
    _messageController.clear();

    _shouldAutoScroll = _isUserAtBottom;

    await ref
        .read(chatProvider(widget.chatId).notifier)
        .sendMessage(
          message: message,

          onChatCreated: () {
            // Handle newly created chat here.
            //
            // For example:
            // refresh recent chats
          },

          onChunk: (_) {
            if (_shouldAutoScroll) {
              _scrollToBottom();
            }
          },
        );

    if (_shouldAutoScroll) {
      _scrollToBottom();
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
    final chatState = ref.watch(chatProvider(widget.chatId));

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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        chatState.chatTitle ?? "New Chat",

                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const FaIcon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final message = chatState.messages[index];

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
                          if (!chatState.isGenerating) {
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
                                onTap: () {
                                  if (chatState.isGenerating) {
                                    ref
                                        .read(
                                          chatProvider(widget.chatId).notifier,
                                        )
                                        .stopGeneration();
                                  } else {
                                    sendMessage();
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(31, 0, 0, 0),
                                  ),
                                  child: Center(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },
                                      child: chatState.isGenerating
                                          ? Container(
                                              key: const ValueKey('stop'),
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            )
                                          : const FaIcon(
                                              key: ValueKey('send'),
                                              FontAwesomeIcons.paperPlane,
                                              color: Colors.white,
                                              size: 16,
                                            ),
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
