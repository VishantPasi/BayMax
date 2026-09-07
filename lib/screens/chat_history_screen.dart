import 'package:animated_notch_bottom_bar/src/notch_bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key, required NotchBottomBarController controller});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  Widget recentActivity(String title, String subtitle, String time) {
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
              Container(
                width: 2,
                height: 65,
                color: Color.fromARGB(255, 99, 99, 99),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  Text(
                    time,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3),

              Text(
                subtitle,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                          "Chats History",
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
            SizedBox(height: 30),
           
        
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    recentActivity(
                      "Summarized a text",
                      "You created a summary",
                      "2 hours ago",
                    ),
                    SizedBox(height: 10),
                    recentActivity(
                      "Explained a concept",
                      "You provided an explanation",
                      "5 hours ago",
                    ),
                    SizedBox(height: 10),
                    recentActivity(
                      "Wrote an article",
                      "You published an article",
                      "1 day ago",
                    ),
                    SizedBox(height: 10),
                    recentActivity(
                      "Analyzed data",
                      "You analyzed data",
                      "2 days ago",
                    ),
                    recentActivity(
                      "Analyzed data",
                      "You analyzed data",
                      "2 days ago",
                    ),
                    recentActivity(
                      "Analyzed data",
                      "You analyzed data",
                      "2 days ago",
                    ),
                    recentActivity(
                      "Analyzed data",
                      "You analyzed data",
                      "2 days ago",
                    ),
                    recentActivity(
                      "Analyzed data",
                      "You analyzed data",
                      "2 days ago",
                    ),
                    recentActivity(
                      "Analyzed data",
                      "You analyzed data",
                      "2 days ago",
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