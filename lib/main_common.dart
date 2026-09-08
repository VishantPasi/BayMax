import 'package:baymax/env_config.dart';
import 'package:baymax/screens/home_screen.dart';
import 'package:baymax/screens/login/initial_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void mainCommon() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint(
    "----------------------  Environment: ${AppEnvironment.environmentName}  ----------------------",
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BayMax',
      debugShowCheckedModeBanner: false,

      home: InitialLoginScreen(),
      // home: HomeScreen(),
    );
  }
}
