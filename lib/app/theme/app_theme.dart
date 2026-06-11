import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF071B2D),
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF38BDF8),
      secondary: Color(0xFF64FFDA),
      surface: Color(0xFF0F2A44),
      background: Color(0xFF071B2D),
    ),
    cardColor: const Color(0xFF102F4C),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromARGB(255, 141, 200, 200),
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0284C7),
      secondary: Color(0xFF0F766E),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF4F7FB),
    ),
    cardColor: const Color.fromARGB(255, 132, 169, 164),
  );
}


/* Color(0xFFFFFFFF),*/