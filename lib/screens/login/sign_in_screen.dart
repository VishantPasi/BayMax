import 'package:baymax/network/apiHandling/auth.dart';
import 'package:baymax/screens/login/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:lottie/lottie.dart';
// import 'package:overcloud/firebase/firebase_auth_service.dart';

// import 'package:overcloud/screens/login/sign_up_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscure = true;
  bool isChecked = false;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  // final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(15, 15, 15, 1),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(15, 15, 15, 1),
        body: GestureDetector(
          onTap: () {
            setState(() {
              emailFocus.unfocus();
              passwordFocus.unfocus();
            });
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 290,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 50,
                            right: 10,
                            child: Image.asset(
                              "assets/images/sign_in_robot.png",
                              width: 160,
                            ),
                          ),
                          Positioned(
                            top: 70,
                            left: 20,
                            bottom: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello,",
                                  style: GoogleFonts.urbanist(
                                    shadows: [
                                      Shadow(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        offset: Offset(0, 0),
                                        blurRadius: 100,
                                      ),
                                    ],
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 255, 198, 75),
                                          Color.fromARGB(255, 180, 124, 6),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds),
                                  child: Text(
                                    "I'm BayMax.",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),
                                Container(
                                  height: 3,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 198, 75),
                                        Color.fromARGB(255, 180, 124, 6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "AI Agent, Reimagined.",
                                  style: GoogleFonts.urbanist(
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 1,
                                        ),
                                        offset: Offset(0, 0),
                                        blurRadius: 50,
                                      ),
                                    ],
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  "Your Intelligent Companion\nalways here to help.",
                                  style: GoogleFonts.urbanist(
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        offset: Offset(0, 0),
                                        blurRadius: 100,
                                      ),
                                    ],
                                    color: Colors.white54,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "SMART",
                          style: GoogleFonts.urbanist(
                            shadows: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                offset: Offset(0, 0),
                                blurRadius: 100,
                              ),
                            ],
                            color: Color.fromARGB(255, 255, 198, 75),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          "✦",
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
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
                            letterSpacing: 2,
                            color: Color.fromARGB(255, 255, 198, 75),
                            fontSize: 12,
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
                            color: Color.fromARGB(255, 255, 198, 75),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 23.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Welcome Back",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    " !",
                                    style: GoogleFonts.urbanist(
                                      color: Color.fromARGB(255, 255, 198, 75),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 5),
                              Text(
                                "Sign in to your BayMax Account",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                        customTextField(
                          "Email",
                          emailController,
                          emailFocus,
                          false,
                          Icons.email_outlined,
                        ),
                        SizedBox(height: 15),
                        customTextField(
                          "Password",
                          passwordController,
                          passwordFocus,
                          obscure,
                          Icons.lock_outline_rounded,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.black,
                                    activeColor: Color.fromARGB(
                                      255,
                                      255,
                                      198,
                                      75,
                                    ),
                                    value: isChecked,
                                    onChanged: ((value) => setState(() {
                                      isChecked = value!;
                                    })),
                                  ),
                                  Text(
                                    "Remember Me",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.white54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.urbanist(
                                    color: Color.fromARGB(255, 255, 198, 75),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Handle sign-in logic here
                                Auth auth = Auth();
                                auth.signIn(
                                  context,
                                  emailController.text,
                                  passwordController.text,
                                );
                                
                              },
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(158, 227, 177, 69),
                                      blurRadius: 20,
                                    ),
                                  ],
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 182, 25),
                                      Color.fromARGB(255, 180, 124, 6),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                
                                child: Center(
                                  child: Text(
                                    "SIGN IN",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // ),
                        ),
                        SizedBox(height: 25),

                        Stack(
                          children: [
                            Image.asset(
                              "assets/images/waves.png",
                              fit: BoxFit.cover,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?  ",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    emailFocus.unfocus();
                                    passwordFocus.unfocus();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: GoogleFonts.urbanist(
                                      color: Color.fromARGB(255, 255, 198, 75),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ValueListenableBuilder(
              //   valueListenable: _firebaseAuthService.isLoading,
              //   builder: (context, loading, child) {
              //     return loading
              //         ? Container(
              //             height: size.height,
              //             width: size.width,
              //             color: Colors.black.withValues(alpha: 0.6),
              //             child: Center(
              //               child: CircularProgressIndicator(
              //                 color: Colors.deepOrange,
              //                 backgroundColor: Colors.grey.shade300,
              //               ),
              //             ),
              //           )
              //         : SizedBox();
              // },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget obscureIcon() {
    if (obscure) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
          icon: FaIcon(
            FontAwesomeIcons.eye,
            color: Color.fromARGB(255, 255, 198, 75).withValues(alpha: 0.7),
            size: 20,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
          icon: FaIcon(
            FontAwesomeIcons.eyeSlash,
            color: Color.fromARGB(255, 255, 198, 75).withValues(alpha: 0.7),
            size: 20,
          ),
        ),
      );
    }
  }

  Widget customTextField(
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
    bool obscure,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23.0),
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          color: Color.fromRGBO(29, 29, 29, 0.491),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white38, width: 0.2),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                icon,
                color: Color.fromARGB(255, 255, 198, 75).withValues(alpha: 0.7),
                size: 25,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscure,
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                focusNode: focusNode,
                onSubmitted: (value) {
                  if (emailFocus.hasFocus) {
                    FocusScope.of(context).requestFocus(passwordFocus);
                  } else {
                    // _firebaseAuthService.signIn(
                    //   emailController,
                    //   passwordController,
                    //   context,
                    // );
                  }
                },
                cursorColor: Color.fromARGB(255, 255, 198, 75),

                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: GoogleFonts.urbanist(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            controller == passwordController ? obscureIcon() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
