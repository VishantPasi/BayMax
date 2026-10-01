import 'package:baymax/models/ResponseModels/auth_me_response_model.dart';
import 'package:baymax/models/ResponseModels/get_chats_response_model.dart' as get_chats;
import 'package:baymax/network/apiHandling/chat.dart';
import 'package:baymax/providers/chat_provider.dart';
import 'package:baymax/providers/user_provider.dart';
import 'package:baymax/screens/chat_history_screen.dart';
import 'package:baymax/screens/chat_screen.dart';
import 'package:baymax/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenContent extends ConsumerStatefulWidget {
  final String? accessToken;

  const HomeScreenContent({super.key, this.accessToken});

  @override
  ConsumerState<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends ConsumerState<HomeScreenContent> {
  int maxLines = 1;
  double containerHeight = 120;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  final ChatService _chatService = ChatService();

  List<get_chats.Items>? _recentChats = [];
  bool _isLoadingRecentChats = true;

  int maxHeight() {
    if (maxLines == 1) {
      return 120;
    } else if (maxLines == 2) {
      return 150;
    } else if (maxLines == 3) {
      return 180;
    } else {
      return 210;
    }
  }

  void openChat({
  String? prompt,
  bool? isQuickAction,
}) {
  _messageFocusNode.unfocus();

  // IMPORTANT:
  // Reset the provider used for new chats.
  ref.invalidate(chatProvider(null));

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        chatId: null,
        initialPrompt: prompt,
        isQuickAction: isQuickAction,
      ),
    ),
  );

  if (mounted) {
    _messageFocusNode.unfocus();
    _messageController.clear();
  }
}

  @override
  void initState() {
    super.initState();

    _loadRecentChats();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecentChats() async {
    try {
      final chats = await _chatService.getChats(1,20);

      if (!mounted) return;

      setState(() {
        _recentChats = chats.items!.take(3).toList();
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
    final userState = ref.watch(userProvider);

    return userState.when(
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            "Unable to load user",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
      data: (user) {
        if (user == null) {
          return const Center(
            child: Text(
              "User not found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return _buildHomeScreenContent(context, user);
      },
    );
  }

  Widget _buildHomeScreenContent(
    BuildContext context,
    AuthMeResponseModel user,
  ) {
    return SafeArea(
  child: RefreshIndicator(
    color: const Color.fromARGB(255, 255, 198, 75),
    backgroundColor: const Color.fromARGB(255, 40, 40, 40),
    onRefresh: _loadRecentChats,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: FaIcon(
                      FontAwesomeIcons.barsStaggered,
                      color: Color.fromARGB(255, 255, 198, 75),
                      size: 22,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo/applogo_transparent.png",
                        width: 40,
                      ),
                      SizedBox(width: 5),
                      Row(
                        children: [
                          Text(
                            "Bay",
                            style: GoogleFonts.urbanist(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Max",
                            style: GoogleFonts.urbanist(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 198, 75),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: ((context) => ProfileScreen(accessToken: widget.accessToken!)))),
                    child: CircleAvatar(
                      
                      backgroundColor: Color.fromARGB(255, 255, 198, 75),
                      child: Center(
                        child: Text(
                          user.name != null && user.name!.isNotEmpty
                              ? user.name![0].toUpperCase()
                              : "?",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                SizedBox(height: 220, width: double.infinity),
                Positioned(
                  right: 0,

                  child: Image.asset(
                    "assets/images/home_screen_robot.png",
                    width: 170,
                  ),
                ),

                Positioned(
                  left: 20,
                  child: Text(
                    "Hello, ${user.name ?? "User"}",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,

                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Positioned(
                  top: 30,
                  left: 20,
                  child: Text(
                    "How can I help \nyou today?",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Positioned(
                  top: 110,
                  left: 20,
                  child: Text(
                    "Your AI assistant for \nanswers, ideas and more.",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,

                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: double.infinity,

                decoration: BoxDecoration(
                  // color: Color.fromARGB(40, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 73, 73, 73),

                      Color.fromARGB(115, 255, 198, 75),
                    ],
                  ),

                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color.fromARGB(255, 108, 101, 64),
                  //     blurRadius: 20,
                  //     spreadRadius: 10,
                  //   ),
                  // ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 5,
                      ),
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.white,
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (value) => setState(() {
                          maxLines = value.split('\n').length;
                          containerHeight = maxHeight().toDouble();
                        }),

                        decoration: InputDecoration(
                          hintText: "Ask me anything...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white),
                          hoverColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Row(
                          //   children: [
                          //     SizedBox(width: 20),
                          //     Container(
                          //           height: 40,
                          //           width: 40,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(15),
                          //             color: Color.fromARGB(31, 0, 0, 0),
                          //           ),
                          //           child: Center(
                          //             child: FaIcon(
                          //               FontAwesomeIcons.paperclip,
                          //               color: Colors.white,
                          //               size: 16,
                          //             ),
                          //           ),
                          //         ),
                          //   ],
                          // ),
                          Row(
                            children: [
                              // Container(
                              //   height: 40,
                              //   width: 40,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(15),
                              //     color: Color.fromARGB(31, 0, 0, 0),
                              //   ),
                              //   child: Center(
                              //     child: FaIcon(
                              //       FontAwesomeIcons.microphone,
                              //       color: Colors.white,
                              //       size: 18,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(width: 10),

                              GestureDetector(
                                onTap: () {
                                  final message = _messageController.text
                                      .trim();

                                  if (message.isEmpty) {
                                    return;
                                  }

                                  if (message.length < 2){
                                    return;
                                  }

                                  openChat(
                                    prompt: message,
                                    isQuickAction: false,
                                  );
                                },

                                child: Container(
                                  height: 40,
                                  width: 40,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(31, 0, 0, 0),
                                  ),

                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.paperPlane,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Quick Actions",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      openChat(
                        prompt: "Summarize the following text:\n\n",
                        isQuickAction: true,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(40, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.squarePollHorizontal,
                              color: Colors.white,
                              size: 23,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Summarize \nText",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      openChat(
                        prompt:
                            "Explain the following concept in simple terms:\n\n",
                        isQuickAction: true,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(40, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidLightbulb,
                              color: Colors.white,
                              size: 23,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Explain \nConcepts",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      openChat(
                        prompt: "Help me write the following content:\n\n",
                        isQuickAction: true,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(40, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.pen,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Write \nContent",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      openChat(
                        prompt:
                            "Analyze the following data and explain the key insights:\n\n",
                        isQuickAction: true,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(40, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.chartSimple,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Analyze \nData",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Activity",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatHistoryScreen(),
                      ),
                    ),
                    child: Text(
                      "View All",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 198, 75),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                      : _recentChats!.isEmpty
                      ? Center(
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Text(
                                "No recent activity",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      )
                      : Column(
                          children: [
                            for (int i = 0; i < _recentChats!.length; i++) ...[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        chatId: _recentChats![i].id,
                                        chatTitle: _recentChats![i].title,
                                        isQuickAction: false,
                                      ),
                                    ),
                                  ).then((_) {
                                    _loadRecentChats();
                                  });
                                },
                                child: recentActivity(
                                  _recentChats![i].title ?? "Untitled Chat",
                                  _formatTime(
                                    DateTime.parse(_recentChats![i].updatedAt!),
                                  ),
                                  i == _recentChats!.length - 1,
                                ),
                              ),

                              if (i != _recentChats!.length - 1)
                                const SizedBox(height: 10),
                            ],
                          ],
                        ),
                        SizedBox(height: 20,)
                ],
              ),
            ),
          ],
        ),
      ),
  )
    );
  }
}
