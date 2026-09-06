import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:baymax/screens/chat_history_screen.dart';
import 'package:baymax/screens/chat_screen.dart';
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
    final List<Widget> bottomBarPages = [HomeContent(controller: _controller), ChatScreen(controller: _controller),ChatHistoryScreen(controller: _controller), ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(15, 15, 15, 1),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(15, 15, 15, 1),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            bottomBarPages.length,
            (index) => bottomBarPages[index],
          ),
          
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
    ? Container(
                color: Colors.transparent,
                child: AnimatedNotchBottomBar(
                  notchBottomBarController: _controller,

                  bottomBarHeight: 62,
                  circleMargin: 3,
                  kIconSize: 22,

                  showLabel: true,
                  showShadow: false,

                  color: Color.fromRGBO(40, 40, 40, 1),
                  notchColor: Color.fromARGB(255, 255, 198, 75),

                  itemLabelStyle: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),

                  bottomBarItems: const [
                    BottomBarItem(
                      inActiveItem: FaIcon(
                        FontAwesomeIcons.house,
                        color: Colors.white,
                      ),
                      activeItem: FaIcon(
                        FontAwesomeIcons.house,
                        color: Colors.black,
                      ),
                      itemLabel: 'Home',
                    ),

                    BottomBarItem(
                      inActiveItem: FaIcon(
                        FontAwesomeIcons.wandMagicSparkles,
                        color: Colors.white,
                      ),
                      activeItem: FaIcon(
                        FontAwesomeIcons.wandMagicSparkles,
                        color: Colors.black,
                      ),
                      itemLabel: 'Ask AI',
                    ),

                    BottomBarItem(
                      inActiveItem: FaIcon(
                        FontAwesomeIcons.clockRotateLeft,
                        color: Colors.white,
                      ),
                      activeItem: FaIcon(
                        FontAwesomeIcons.clockRotateLeft,
                        color: Colors.black,
                      ),
                      itemLabel: 'History',
                    ),  
                      
                    
                  ],

                  onTap: (index) {
                    _pageController.jumpToPage(index);
                  },
                  kBottomRadius: 28,
                ),
              )
            : null,
      ),
    );
  }

  
}

class HomeContent extends StatefulWidget {
  final NotchBottomBarController? controller;

  const HomeContent({Key? key, this.controller}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
                      FaIcon(
                        FontAwesomeIcons.barsStaggered,
                        color: Color.fromARGB(255, 255, 198, 75),
                        size: 22,
                      ),
                      Row(
                        children: [
                          Image.asset("assets/logo/applogo_transparent.png", width: 40),
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
                                cursorColor: Colors.white,
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),

                                decoration: InputDecoration(
                                  hintText: "Ask me anything...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.white),
                                  hoverColor: Colors.white,
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
                                  color: Colors.white,
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
