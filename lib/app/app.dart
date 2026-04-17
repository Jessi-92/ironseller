import 'package:flutter/material.dart';

import '../features/inicio/presentation/pages/home_page.dart';
import '../features/velocimetro/presentation/pages/velocimetro_page.dart';
import '../features/rankings/presentation/pages/rankings_page.dart';
import '../features/premios/presentation/pages/premios_page.dart';
import '../features/rendimiento/presentation/pages/rendimiento_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    VelocimetroPage(), 
    RendimientoPage(),
    RankingsPage(),
    PremiosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: const Color(0xFF081B2E),
        selectedItemColor: const Color(0xFF183054),
        unselectedItemColor: const Color(0xFFC1D002),

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: "Velocímetro"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Rendimiento "),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Rankings"),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Premios"),
        ],
      ),
    );
  }
}