import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:baymax/screens/chat_history_screen.dart';
import 'package:baymax/screens/chat_screen.dart';
import 'package:baymax/screens/home_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );
  final _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  int maxCount = 3;

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(15, 15, 15, 1),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(15, 15, 15, 1),
        drawer: Drawer(
          backgroundColor: Color.fromRGBO(15, 15, 15, 1),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(40, 40, 40, 1),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 254, 191, 52),
                                          Color.fromARGB(255, 183, 114, 2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo/applogo_transparent.png",
                        width: 100,
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Bay",
                                style: GoogleFonts.urbanist(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              Text(
                                "Max",
                                style: GoogleFonts.urbanist(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 198, 75),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Your AI Companion \nBeyond Limits.",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.user, color: Colors.white),
                  title: Text(
                    "Profile",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Handle Profile tap
                  },
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.clockRotateLeft, color: Colors.white),
                  title: Text(
                    "Chat History",
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Handle Profile tap
                  },
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.gear, color: Colors.white),
                  title: Text(
                    "Settings",
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Handle Settings tap
                  },
                ),
                Spacer(),
                Image.asset(  
                  "assets/images/drawer_image.png",
                  width: double.infinity,  ),
                Text(
                  "Version 1.0.0",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
                Center(
                  child: ListTile(
                    title: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.rightFromBracket,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Logout",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Handle Logout tap
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: HomeScreenContent(),
      
      ),
    );
  }
}

