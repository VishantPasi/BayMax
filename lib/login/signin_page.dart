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
    bool isGoogle,
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
                    const Color.fromARGB(255, 64, 64, 64),
                    const Color.fromARGB(255, 27, 27, 27),
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
                !isGoogle
                    ? FaIcon(icon, color: iconColor, size: 22)
                    : Image.asset("assets/logo/googlelogo.png", width: 27),
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

  Widget infoBar(String text, FaIconData icon) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          FaIcon(icon, color: const Color.fromARGB(255, 227, 178, 69)),
          SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.urbanist(
              color: Colors.white,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 10, 8, 18),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Image.asset("assets/logo/baymaxlogo3.png", width: 50),
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
                              "Your Personal Agent",
                              style: GoogleFonts.spaceGrotesk(
                                color: Color.fromARGB(255, 253, 253, 252),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ".",
                              style: GoogleFonts.spaceGrotesk(
                                color: const Color.fromARGB(255, 227, 178, 69),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  SizedBox(height: 250, width: double.infinity),
                  Positioned(
                    right: -40,
                    top: 0,
                    child: Image.asset("assets/images/robot.png", width: 200),
                  ),
                  Positioned(
                    top: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Text(
                            "Welcome Back",
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "!",
                            style: GoogleFonts.spaceGrotesk(
                              color: const Color.fromARGB(255, 227, 178, 69),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                                style: GoogleFonts.spaceGrotesk(
                                  color: Color.fromARGB(255, 253, 253, 252),
                                  fontSize: 23,
                                ),
                              ),
                              Text(
                                "'",
                                style: GoogleFonts.spaceGrotesk(
                                  color: const Color.fromARGB(
                                    255,
                                    227,
                                    178,
                                    69,
                                  ),
                                  fontSize: 23,
                                ),
                              ),
                              Text(
                                "s Pick Up ",
                                style: GoogleFonts.spaceGrotesk(
                                  color: Color.fromARGB(255, 253, 253, 252),
                                  fontSize: 23,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "where you left off",
                                style: GoogleFonts.spaceGrotesk(
                                  color: Color.fromARGB(255, 253, 253, 252),
                                  fontSize: 23,
                                ),
                              ),
                              Text(
                                ".",
                                style: GoogleFonts.spaceGrotesk(
                                  color: const Color.fromARGB(
                                    255,
                                    227,
                                    178,
                                    69,
                                  ),
                                  fontSize: 23,
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
                          color: Color.fromARGB(193, 253, 253, 252),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "SECURE",
                      style: GoogleFonts.urbanist(
                        shadows: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            offset: Offset(0, 0),
                            blurRadius: 100,
                          ),
                        ],
                        color: const Color.fromARGB(255, 227, 178, 69),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "✦",
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    Text(
                      "SCALABLE",
                      style: GoogleFonts.urbanist(
                        shadows: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            offset: Offset(0, 0),
                            blurRadius: 100,
                          ),
                        ],
                        letterSpacing: 2,
                        color: const Color.fromARGB(255, 227, 178, 69),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "✦",
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    Text(
                      "LIMITLESS",
                      style: GoogleFonts.urbanist(
                        shadows: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            offset: Offset(0, 0),
                            blurRadius: 100,
                          ),
                        ],
                        color: const Color.fromARGB(255, 227, 178, 69),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              optionsButton(
                "Continue with Password",
                const Color.fromARGB(255, 37, 37, 37),
                FontAwesomeIcons.lock,
                const Color.fromARGB(255, 37, 37, 37),
                Colors.white,
                true,
                false,
              ),
              SizedBox(height: 20),
              optionsButton(
                "Continue with Google",
                Colors.white,
                FontAwesomeIcons.google,
                Colors.white,
                const Color.fromARGB(255, 202, 202, 202),
                false,
                true,
              ),
              SizedBox(height: 20),

              optionsButton(
                "Sign Up",
                Colors.white,
                FontAwesomeIcons.userPlus,
                Colors.white,
                const Color.fromARGB(255, 202, 202, 202),
                false,
                false,
              ),
              SizedBox(height: 30),
              Stack(
                children: [
                  const SizedBox(height: 150, width: double.infinity),

                  Positioned(
                    bottom: 25,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/images/waves.png",
                      fit: BoxFit.cover,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.shieldHalved,
                        color: const Color.fromARGB(255, 227, 178, 69),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Your data is safe with us.",
                        style: GoogleFonts.urbanist(
                          letterSpacing: 2,
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
