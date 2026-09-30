import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color backgroundColor = Color.fromRGBO(15, 15, 15, 1);
  static const Color primaryColor = Color.fromARGB(255, 255, 198, 75);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: backgroundColor,

    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
      surface: backgroundColor,
    ),

    textTheme: GoogleFonts.urbanistTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintStyle: TextStyle(
        color: Colors.white70,
      ),
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: Color.fromARGB(80, 255, 198, 75),
      selectionHandleColor: primaryColor,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),

    iconTheme: const IconThemeData(
      color: Colors.white,
    ),

    dividerTheme: const DividerThemeData(
      color: Colors.white24,
    ),
  );
}