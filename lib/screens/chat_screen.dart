import 'package:animated_notch_bottom_bar/src/notch_bottom_bar_controller.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/services/ai_service.dart';
import 'package:baymax/services/secure_storage_service.dart';

class ChatScreen extends StatefulWidget {
  final String? initialPrompt;
  const ChatScreen({
    super.key,
    required NotchBottomBarController controller,
    this.initialPrompt,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  int maxLines = 1;

  double containerHeight = 120;

  bool _isGenerating = false;

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

    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      _messageController.text = widget.initialPrompt!;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();

    _scrollController.dispose();

    super.dispose();
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

              child: SelectionArea(
                child: Text(
                  message,

                  textAlign: TextAlign.start,

                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
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

    _messageController.clear();

    setState(() {
      // Add user message
      _messages.add({'message': message, 'isUser': true});

      // Add empty AI message
      _messages.add({'message': '', 'isUser': false});

      _isGenerating = true;
    });

    _scrollToBottom();

    try {
      final accessToken = await SecureStorageService.getAccessToken();

      final dio = RetrofitService.getDio(token: accessToken);

      final aiService = AIService(dio);

      await for (final chunk in aiService.streamChat(message)) {
        if (!mounted) {
          return;
        }

        setState(() {
          // Last message is the AI message
          _messages.last['message'] += chunk;
        });

        _scrollToBottom();
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _messages.last['message'] =
            'Sorry, something went wrong while generating the response.';
      });

      debugPrint('AI request failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,

        duration: const Duration(milliseconds: 150),

        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  "New Chat",

                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
    );
  }
}
