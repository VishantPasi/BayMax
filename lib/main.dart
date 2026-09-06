import 'package:baymax/screens/home_screen.dart';
import 'package:baymax/screens/login/initial_login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BayMax',
      debugShowCheckedModeBanner: false,

      // home: InitialLoginScreen()
      home: HomeScreen(),
    );
  }
}
