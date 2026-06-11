import 'package:flutter/material.dart';
import 'package:appsellerv1/features/login/presentation/pages/login_page.dart';
import 'package:provider/provider.dart';

import 'app/theme/app_theme.dart';
import 'app/theme/theme_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      home: const LoginPage(),
    );
  }
}