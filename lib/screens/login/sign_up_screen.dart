import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:overcloud/firebase/firebase_auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  // final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    nameFocus.dispose();
    phoneFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();

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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    nameFocus.unfocus();
                    phoneFocus.unfocus();
                    emailFocus.unfocus();
                    passwordFocus.unfocus();
                    confirmPasswordFocus.unfocus();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 290,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 10,
                            top: 40,
                            child: Image.asset(
                              "assets/images/robot4.png",
                              width: 160
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
                                  "Think Beyond.",
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
                                    "Do More.",
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
                                  "One Agent. Every Need.",
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
                                  "Think, plan, and \nexecute effortlessly.",
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

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "PLAN",
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
                          "EXECUTE",
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
                          "ACHIEVE",
                          style: GoogleFonts.urbanist(
                            shadows: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                offset: Offset(0, 0),
                                blurRadius: 100,
                              ),
                            ],
                            color:Color.fromARGB(255, 255, 198, 75),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 23.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Create Your Account",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      
                                SizedBox(height: 5),
                                Text(
                                  "Get started with your OverCloud Account",
                                  maxLines: 2,
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
                            "Full Name",
                            "Enter your full name",
                            nameController,
                            nameFocus,
                            Icons.person_outline,
                            true,
                          ),
                          SizedBox(height: 20),
                          customTextField(
                            "Phone Number",
                            "Enter your phone number",
                            phoneController,
                            phoneFocus,
                            Icons.phone_outlined,
                            false,
                          ),
                          SizedBox(height: 20),
                          customTextField(
                            "Email Address",
                            "Enter your email",
                            emailController,
                            emailFocus,
                            Icons.email_outlined,
                            true,
                          ),
                          SizedBox(height: 20),
                      
                          customTextField(
                            "Password",
                            "Enter your password",
                            passwordController,
                            passwordFocus,
                            Icons.lock_outline,
                            true,
                          ),
                          SizedBox(height: 20),
                      
                          customTextField(
                            "Confirm Password",
                            "Enter your confirm password",
                            confirmPasswordController,
                            confirmPasswordFocus,
                            Icons.verified_user_outlined,
                            true,
                          ),
                          SizedBox(height: 40),

                          Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
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
                              // child: ElevatedButton(
                              //   onPressed: () {
                              //     FocusScope.of(context).unfocus();

                              //     // _firebaseAuthService.signIn(
                              //     //   emailController,
                              //     //   passwordController,
                              //     //   context,
                              //     // );
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: Colors.transparent,
                              //     minimumSize: Size(size.width, 60),

                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(20),
                              //     ),
                              //   ),
                              child: Center(
                                child: Text(
                                  "SIGN UP",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // ),
                        ),
                          // Center(
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 25.0,
                          //     ),
                          //     child: Container(
                          //       width: double.infinity,
                          //       height: 43,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(12),
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black.withValues(
                          //               alpha: 0.6,
                          //             ),
                          //             blurRadius: 10,
                          //             offset: Offset(0, 5),
                          //           ),
                          //           BoxShadow(
                          //             color: Color.fromARGB(255, 255, 198, 75).withValues(
                          //               alpha: 0.4,
                          //             ),
                          //             blurRadius: 10,
                          //             offset: Offset(0, -5),
                          //           ),
                          //         ],
                          //         gradient: const LinearGradient(
                          //           colors: [
                          //             Color.fromRGBO(255, 132, 61, 0.89),
                          //             Color.fromRGBO(233, 89, 17, 1),
                          //             Color.fromRGBO(205, 61, 0, 1),
                          //           ],
                          //           begin: Alignment.topLeft,
                          //           end: Alignment.bottomRight,
                          //         ),
                          //       ),
                          //       child: ElevatedButton(
                          //         // onPressed: () =>
                          //         //     _firebaseAuthService.signUp(
                          //         //       nameController,
                          //         //       phoneController,
                          //         //       emailController,
                          //         //       passwordController,
                          //         //       confirmPasswordController,
                          //         //       context,
                          //         //     ),
                          //         onPressed: (){},
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor: Colors.transparent,
                          //           minimumSize: Size(size.width, 45),
                      
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(15),
                          //           ),
                          //         ),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             SizedBox(),
                          //             Text(
                          //               "Create Account",
                          //               style: GoogleFonts.urbanist(
                          //                 color: Colors.white70,
                          //                 fontSize: 16,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             FaIcon(
                          //               FontAwesomeIcons.arrowRight,
                          //               color: Colors.white70,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                      
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?  ",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.urbanist(
                                    color: Color.fromARGB(255, 255, 182, 25),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
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
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget customTextField(
    String title,
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
    IconData icon,
    bool isRequired,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0),
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.urbanist(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              isRequired
                  ? Text(
                      " *",
                      style: GoogleFonts.urbanist(
                        color: Color.fromARGB(255, 255, 182, 25),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white38, width: 0.2),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(icon, color: Color.fromARGB(255, 255, 182, 25).withValues(alpha: 0.7), size: 25),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    keyboardType: controller == phoneController
                        ? TextInputType.phone
                        : TextInputType.text,
                    inputFormatters: controller == phoneController
                        ? [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ]
                        : [],
                    focusNode: focusNode,
                    onSubmitted: (value) {
                      if (emailFocus.hasFocus) {
                        FocusScope.of(context).requestFocus(passwordFocus);
                      } else {}
                    },
                    cursorColor: Color.fromARGB(255, 255, 182, 25),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: GoogleFonts.urbanist(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
