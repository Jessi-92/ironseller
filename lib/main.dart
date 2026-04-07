import 'package:appsellerv1/features/rankings/presentation/pages/rankings_page.dart';
import 'package:appsellerv1/features/velocimetro/presentation/pages/velocimetro_page.dart';
import 'package:flutter/material.dart';
import 'features/inicio/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RankingsPage(),
      // VelocimetroPage(),
      // home: VelocimetroPage(),

    );
  }
}