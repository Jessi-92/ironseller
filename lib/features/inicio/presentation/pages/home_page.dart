import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 20),
              _resumen(),
              const SizedBox(height: 20),
              _meta(),
              const SizedBox(height: 20),
              _cards(),
              const SizedBox(height: 20),
              _ranking(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // 🔵 HEADER
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1DA1F2), Color(0xFF0D6EFD)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white24,
            child: Text("SJ", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Sandro Jaramillo",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              Text("⭐ Elite Vendedor  Nivel 8",
                  style: TextStyle(color: Colors.yellow)),
            ],
          )
        ],
      ),
    );
  }

  // 📊 RESUMEN
  Widget _resumen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("⚡ Resumen del Día",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 12),
        Row(
          children: [
            _miniCard("Ventas Hoy", "12", "+3 vs ayer"),
            const SizedBox(width: 10),
            _miniCard("Puntos Totales", "6,420", "pts acumulados"),
          ],
        ),
      ],
    );
  }

  Widget _miniCard(String title, String value, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0F2A44),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text(value,
                style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.white38)),
          ],
        ),
      ),
    );
  }

  // 🎯 META
  Widget _meta() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("🎯 Meta del Día",
                  style: TextStyle(color: Colors.white)),
              Text("75%", style: TextStyle(color: Colors.greenAccent)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white12,
            color: Colors.greenAccent,
          ),
          const SizedBox(height: 10),
          const Text("12 de 16 ventas completadas",
              style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }

  // 📦 CARDS
  Widget _cards() {
    return Row(
      children: [
        _bigCard("\$2.4K", "Comisiones", Colors.blue),
        const SizedBox(width: 10),
        _bigCard("87%", "Conversión", Colors.green),
        const SizedBox(width: 10),
        _bigCard("#3", "Ranking", Colors.orange),
      ],
    );
  }

  Widget _bigCard(String value, String title, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // 🏆 RANKING
  Widget _ranking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🏆 Ranking de Vendedores",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 12),
        _rankItem("1", "Dayana Agama", "8,850 pts"),
        _rankItem("2", "Grace Pilataxi", "7,250 pts"),
        _rankItem("3", "Sandro Jaramillo", "6,420 pts", isUser: true),
      ],
    );
  }

  Widget _rankItem(String pos, String name, String pts,
      {bool isUser = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue.withOpacity(0.2) : const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(child: Text(pos)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(name,
                  style: const TextStyle(color: Colors.white))),
          Text(pts, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // 📱 NAV BAR
  Widget _bottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF081B2E),
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.white38,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
        BottomNavigationBarItem(
            icon: Icon(Icons.speed), label: "Velocímetro"),
        BottomNavigationBarItem(
            icon: Icon(Icons.show_chart), label: "Rendimiento"),
        BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events), label: "Rankings"),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard), label: "Premios"),
      ],
    );
  }
}