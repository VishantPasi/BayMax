import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:baymax/models/ResponseModels/auth_me_response_model.dart';
import 'package:baymax/network/apiHandling/userDetails.dart';
import 'package:baymax/providers/user_provider.dart';
import 'package:baymax/retrofit/retrofit_service.dart';
import 'package:baymax/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenContent extends ConsumerStatefulWidget {
  final NotchBottomBarController? controller;

  const HomeScreenContent({super.key, this.controller});

  @override
  ConsumerState<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends ConsumerState<HomeScreenContent> {
  int maxLines = 1;
  double containerHeight = 120;

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
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  Text(
                    time,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3),

              Text(
                subtitle,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.white70,
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
      child: SingleChildScrollView(
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
                  CircleAvatar(
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
                  Column(
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
                  Column(
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
                  Column(
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

                  Column(
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

                  Text(
                    "View All",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 198, 75),
                      fontWeight: FontWeight.w500,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
