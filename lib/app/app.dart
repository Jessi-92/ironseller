import 'package:flutter/material.dart';

import '../features/inicio/presentation/pages/home_page.dart';
import '../features/velocimetro/presentation/pages/velocimetro_page.dart';
import '../features/rankings/presentation/pages/rankings_page.dart';
import '../features/premios/presentation/pages/premios_page.dart';
import '../features/rendimiento/presentation/pages/rendimiento_page.dart';

import 'theme/theme_toggle_switch.dart';

class MainLayout extends StatefulWidget {
  final String cedula;

  const MainLayout({
    super.key,
    required this.cedula,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      HomePage(cedula: widget.cedula),
      VelocimetroPage(cedula: widget.cedula),
      RendimientoPage(cedula: widget.cedula),
      RankingsPage(cedula: widget.cedula),
      PremiosPage(cedula: widget.cedula),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: pages,
          ),

          Positioned(
            right: 16,
            bottom: 92,
            child: SafeArea(
              child: ThemeToggleSwitch(
                compact: true,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF081B2E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.10),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor:
                isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
            unselectedItemColor:
                isDark ? const Color(0xFFC1D002) : const Color(0xFF8A8A8A),
            selectedFontSize: 12,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Inicio",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.speed_rounded),
                label: "Velocímetro",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart_rounded),
                label: "Rendimiento",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_rounded),
                label: "Rankings",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard_rounded),
                label: "Premios",
              ),
            ],
          ),
        ),
      ),
    );
  }
}