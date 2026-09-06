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

                    child: Image.asset("assets/images/robot6.png", width: 170),
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
                    color: Colors.white,
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
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Ask me anything...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
