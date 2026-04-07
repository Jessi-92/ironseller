import 'package:flutter/material.dart';

class PremiosPage extends StatelessWidget {
  const PremiosPage({super.key});

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
              _tabs(),
              const SizedBox(height: 20),
              _disponibles(),
              const SizedBox(height: 20),
              _proximos(),
            ],
          ),
        ),
      ),
    );
  }

  // 🧠 HEADER
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("Recompensas",
            style: TextStyle(color: Colors.white, fontSize: 24)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Puntos Disponibles",
                style: TextStyle(color: Colors.white54)),
            Text("6,420",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  // 🔘 TABS (solo visual por ahora)
  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _tab("Catálogo", true),
          _tab("Insignias", false),
          _tab("Historial", false),
        ],
      ),
    );
  }

  Widget _tab(String text, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.lime : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.black : Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 🟢 DISPONIBLES
  Widget _disponibles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 6),
            Text("Disponibles para Canjear",
                style: TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 10),

        _itemDisponible(
            "Audífonos BT ENV Lifepod C15", "3,000 pts"),
        _itemDisponible(
            "Parlante BT ENV Boom-Pro", "4,500 pts"),
      ],
    );
  }

  Widget _itemDisponible(String title, String pts) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withOpacity(0.3), Colors.teal.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.headphones, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.white)),
                Text(pts,
                    style: const TextStyle(color: Colors.greenAccent)),
                const Text("Electrónica",
                    style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {},
            child: const Text("Canjear"),
          )
        ],
      ),
    );
  }

  // 🔒 PRÓXIMOS
  Widget _proximos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.lock, color: Colors.white54),
            SizedBox(width: 6),
            Text("Próximas Recompensas",
                style: TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 10),

        _itemBloqueado(
            "Smartwatch ENV Watch X Lite Negro", "4,000 pts", 0.8, "-2420"),
        _itemBloqueado(
            "Audífonos BT Pantalla Táctil", "6,500 pts", 0.95, "80"),
      ],
    );
  }

  Widget _itemBloqueado(
      String title, String pts, double progress, String faltan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.watch, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(color: Colors.white)),
                    const Text("Electrónica",
                        style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
              Text(pts,
                  style: const TextStyle(color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
            color: Colors.yellow,
          ),
          const SizedBox(height: 6),
          Text("Te faltan $faltan pts",
              style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

 
}