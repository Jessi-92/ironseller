import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.cardDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.happyGreen,
      secondary: AppColors.happyBlueSoft,
      surface: AppColors.cardDark,
      background: AppColors.backgroundDark,
      error: AppColors.error,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.cardLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.happyGreen,
      secondary: AppColors.happyBlue,
      surface: AppColors.cardLight,
      background: AppColors.backgroundLight,
      error: AppColors.error,
    ),
  );
}