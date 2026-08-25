import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialLoginPage extends StatefulWidget {
  const InitialLoginPage({super.key});

  @override
  State<InitialLoginPage> createState() => _InitialLoginPageState();
}

class _InitialLoginPageState extends State<InitialLoginPage> {
  Widget optionsButton(
    String text,
    Color textColor,
    FaIconData icon,
    Color iconColor,
    Color buttonColor,
    bool isMain,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
          color: buttonColor,
          gradient: LinearGradient(
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomCenter,
            colors: isMain
                ? [
                    const Color.fromARGB(255, 227, 178, 69),
                    const Color.fromARGB(255, 180, 124, 6),
                  ]
                : [
                    const Color.fromARGB(255, 46, 46, 46),
                    const Color.fromARGB(255, 32, 32, 32),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: !isMain
              ? Border.all(color: const Color.fromARGB(255, 46, 46, 46))
              : null,
          boxShadow: isMain
              ? [
                  BoxShadow(
                    color: Color.fromARGB(158, 227, 177, 69),
                    blurRadius: 50,
                  ),
                ]
              : [],
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                FaIcon(icon, color: iconColor, size: 22),
                SizedBox(width: 15),
                Text(
                  text,
                  style: GoogleFonts.urbanist(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.chevron_right_outlined, color: iconColor),
                SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infoBar(String text, FaIconData icon){
    return SizedBox(height: 50,child: Row(
      children: [
        FaIcon(icon, color: const Color.fromARGB(255, 227, 178, 69), ),
        SizedBox(width: 10,),
        Text(text, style: GoogleFonts.urbanist(color: Colors.white, fontSize: 13),)
      ],
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 10, 8, 18),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Image.asset("assets/logo/baymax3.png", width: 50),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BayMax",
                        style: GoogleFonts.spaceGrotesk(
                          color: Color.fromARGB(255, 253, 253, 252),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Your ",
                            style: GoogleFonts.spaceGrotesk(
                              color: Color.fromARGB(255, 253, 253, 252),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Personal Agent",
                            style: GoogleFonts.spaceGrotesk(
                              color: const Color.fromARGB(255, 227, 178, 69),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Stack(
              children: [
                SizedBox(height: 250, width: double.infinity),
                Positioned(
                  right: -40,
                  top: 0,
                  child: Image.asset("assets/images/robot.png", width: 200),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Welcome Back!",
                    style: GoogleFonts.urbanist(
                      color: const Color.fromARGB(255, 227, 178, 69),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Let",
                              style: GoogleFonts.urbanist(
                                color: Color.fromARGB(255, 253, 253, 252),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "'",
                              style: GoogleFonts.urbanist(
                                color: const Color.fromARGB(255, 227, 178, 69),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "s Pick Up ",
                              style: GoogleFonts.urbanist(
                                color: Color.fromARGB(255, 253, 253, 252),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "where you left off",
                              style: GoogleFonts.urbanist(
                                color: Color.fromARGB(255, 253, 253, 252),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ".",
                              style: GoogleFonts.urbanist(
                                color: const Color.fromARGB(255, 227, 178, 69),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Positioned(
                  bottom: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Sign in to continue \nwith your conversations.",
                      style: GoogleFonts.urbanist(
                        color: Color.fromARGB(161, 253, 253, 252),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                infoBar("Smart\nConversations", FontAwesomeIcons.commentDots)
                ,VerticalDivider(width: 2,color: Colors.white,)
              ],
            ),

            SizedBox(height: 30),
            optionsButton(
              "Continue with Password",
              Colors.black,
              FontAwesomeIcons.lock,
              Colors.black,
              Colors.white,
              true,
            ),
            SizedBox(height: 20),
            optionsButton(
              "Continue with Google",
              Colors.white,
              FontAwesomeIcons.google,
              Colors.white,
              const Color.fromARGB(255, 202, 202, 202),
              false,
            ),
            SizedBox(height: 20),

            optionsButton(
              "Sign Up",
              Colors.white,
              FontAwesomeIcons.userPlus,
              Colors.white,
              const Color.fromARGB(255, 202, 202, 202),
              false,
            ),
          ],
        ),
      ),
    );
  }
}
