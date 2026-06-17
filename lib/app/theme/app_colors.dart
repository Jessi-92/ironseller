import 'package:flutter/material.dart';

class AppColors {
  static const Color happyGreen = Color(0xFFC2D100);

  static const Color happyBlue = Color(0xFF19375F);
  static const Color happyBlueDark = Color(0xFF102744);
  static const Color happyBlueSoft = Color(0xFFE0F2FE);

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF071B2D);

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF0F2A44);

  static const Color textLight = Color(0xFF0F172A);
  static const Color textDark = Color(0xFFFFFFFF);

  static const Color mutedLight = Color(0xFF64748B);
  static const Color mutedDark = Color(0xB3FFFFFF);

  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0x1AFFFFFF);

  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  static const LinearGradient headerGradient = LinearGradient(
    colors: [
      Color(0xFF19375F),
      Color(0xFF102744),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}