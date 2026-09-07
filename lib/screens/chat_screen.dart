import 'package:animated_notch_bottom_bar/src/notch_bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required NotchBottomBarController controller});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int maxLines = 1;
  double containerHeight = 120;

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
              // width: isUser ? 250 : double.infinity,
              constraints: BoxConstraints(
                maxWidth: isUser ? 250 : double.infinity,
              ),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isUser
                    ?  LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.white.withOpacity(0.18),
    Colors.white.withOpacity(0.10),
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
                FaIcon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                 
                  buildChatBubble(
                    "I'm doing well, thank you for asking!",
                    true,
                  ),
                  buildChatBubble(
                    "That's great to hear! How can I help you today?",
                    false,
                  ),
                  buildChatBubble("I need help with my homework.", true),
                  buildChatBubble(
                    "Sure, I can help you with that. What subject is it?",
                    false,
                  ),
                  buildChatBubble("It's math.", true),
                  buildChatBubble(
                    "Great! What specific topic in math do you need help with?",
                    false,
                  ),
                  buildChatBubble("sfd", true),
                  SizedBox(height: 20), // Add some spacing at the bottom
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 15.0,
            ),
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
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 5,
                    ),
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
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
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(31, 0, 0, 0),
                              ),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.microphone,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),

                            Container(
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
        ],
      ),
    );
  }
}
