import 'package:flutter/material.dart';
import 'dart:math';

class VelocimetroPage extends StatelessWidget {
  const VelocimetroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Velocímetro de Puntos",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 6),
              const Text(
                "¿Cuánto te falta para tu premio?",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 20),

              // 🔥 GAUGE
              SizedBox(
                height: 220,
                child: CustomPaint(
                  painter: GaugePainter(6420, 10000),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("6,420",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        Text("puntos",
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              _premioDisponible(),
              const SizedBox(height: 16),
              _proximoPremio(),
              const SizedBox(height: 16),
              _equivalencias(),
              const SizedBox(height: 16),
              _ritmo(),
              const SizedBox(height: 20),
               _premioPremium(),
              const SizedBox(height: 16),
              _resumenFinal(),
            ],
          ),
        ),
      ),
    );
  }

  // 🟢 PREMIO DISPONIBLE
  Widget _premioDisponible() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.volume_up, color: Colors.greenAccent),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PREMIO DISPONIBLE",
                    style: TextStyle(color: Colors.greenAccent)),
                Text("Parlante BT ENV Boom-Pro",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Canjear"))
        ],
      ),
    );
  }

  // 🟡 PRÓXIMO PREMIO
  Widget _proximoPremio() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text("PRÓXIMO PREMIO",
              style: TextStyle(color: Colors.orange)),
          const SizedBox(height: 10),
          const Text("Smartwatch ENV Watch X Lite",
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.92,
            backgroundColor: Colors.white12,
            color: Colors.yellow,
          ),
          const SizedBox(height: 6),
          const Text("Te faltan 80 pts",
              style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _equivalencias() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0F2A44),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Equivalente a:",
            style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
        Text("• 1 venta de HONOR X6C + 1 Happy Connect",
            style: TextStyle(color: Colors.white70)),
        Text("• 2 ventas de TECNO SPARK 40 + accesorios",
            style: TextStyle(color: Colors.white70)),
      ],
    ),
  );
}

 // 🔵 RITMO
  Widget _ritmo() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0F2A44),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("⚡ Ritmo Actual",
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        const Text("650 pts/día",
            style: TextStyle(color: Colors.greenAccent)),
        const SizedBox(height: 10),
        const Text("Llegas en 1d 2h",
            style: TextStyle(color: Colors.orange)),
        const SizedBox(height: 10),
      ],
  ) );  
}

Widget _premioPremium() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🏆 Premio Premium",
            style: TextStyle(color: Colors.redAccent)),
        const SizedBox(height: 10),
        const Text("Escapada Fin de Semana para 2",
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: 0.65,
          backgroundColor: Colors.white12,
          color: const Color.fromARGB(255, 147, 231, 21),
        ),
        const SizedBox(height: 6),
        const Text("Te faltan 3,580 pts",
            style: TextStyle(color: Colors.white70)),
      ],
    ),
  );
}

Widget _resumenFinal() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0F2A44),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const Text("Resumen del Día",
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                children: const [
                  Text("850",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 20)),
                  Text("Puntos hoy",
                      style: TextStyle(color: Colors.white54)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: const [
                  Text("#3",
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 20)),
                  Text("Ranking",
                      style: TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Mañana con 2 ventas más llegas a los auriculares 🚀",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

}

class GaugePainter extends CustomPainter {
  final double value;
  final double max;

  GaugePainter(this.value, this.max);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 🎨 ARCOS POR ZONA
    final paintRed = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final paintYellow = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final paintGreen = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    // 🔴 zona roja (0% - 40%)
    canvas.drawArc(rect, pi, pi * 0.4, false, paintRed);

    // 🟡 zona amarilla (40% - 70%)
    canvas.drawArc(rect, pi + pi * 0.4, pi * 0.3, false, paintYellow);

    // 🟢 zona verde (70% - 100%)
    canvas.drawArc(rect, pi + pi * 0.7, pi * 0.3, false, paintGreen);

    // 📊 PROGRESO
    final progressPaint = Paint()
      ..color = Colors.tealAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;

    final sweep = (value / max) * pi;

    canvas.drawArc(rect, pi, sweep, false, progressPaint);

    // 🎯 ÁNGULO DEL PUNTERO
    final angle = pi + sweep;

    final needlePaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 4;

    final needleLength = radius - 20;

    final needleEnd = Offset(
      center.dx + needleLength * cos(angle),
      center.dy + needleLength * sin(angle),
    );

    // 📍 DIBUJAR PUNTERO
    canvas.drawLine(center, needleEnd, needlePaint);

    // 🟡 CÍRCULO CENTRAL
    final centerDot = Paint()
      ..color = Colors.amber;

    canvas.drawCircle(center, 6, centerDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
