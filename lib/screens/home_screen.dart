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
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(15, 15, 15, 1),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(15, 15, 15, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.barsStaggered,
                        color: Color.fromARGB(255, 255, 198, 75),
                        size: 22,
                      ),
                      Row(
                        children: [
                          Image.asset("assets/logo/baymaxlogo.png", width: 40),
                          SizedBox(width: 5),
                          Text(
                            "BayMax",
                            style: GoogleFonts.urbanist(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 255, 198, 75),
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
                        "assets/images/robot6.png",
                        width: 170,
                      ),
                    ),

                    Positioned(
                      left: 20,
                      child: Text(
                        "Hello, Vishant",
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
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 250, 239).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 108, 101, 64),
                          blurRadius: 20,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10,
                              ),
                              child: TextField(
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: "Ask me anything...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
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
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 198, 75),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
