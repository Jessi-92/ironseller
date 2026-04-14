import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/datasource/velocimetro_remote_datasource.dart';
import '../../data/models/velocimetro_model.dart';
import '../../../premios/presentation/widgets/canje_comprobante_dialog.dart';

class VelocimetroPage extends StatefulWidget {
  const VelocimetroPage({super.key});

  @override
  State<VelocimetroPage> createState() => _VelocimetroPageState();
}

class _VelocimetroPageState extends State<VelocimetroPage> {
  final VelocimetroRemoteDataSource dataSource = VelocimetroRemoteDataSource();

  VelocimetroModel? veloData;
  bool isLoading = true;
  String error = '';

  final String cedulaActual = '1700000001';

  @override
  void initState() {
    super.initState();
    cargarVelocimetro();
  }

  Future<void> cargarVelocimetro() async {
    try {
      final result = await dataSource.getVelocimetro(cedulaActual);

      if (!mounted) return;

      setState(() {
        veloData = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final puntos = veloData?.puntosDisponibles ?? 0;
    final maxGauge = _maximoGauge();

    return Scaffold(
      backgroundColor: const Color(0xFF081B2E),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent),
              )
            : error.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: cargarVelocimetro,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            "Velocímetro de Puntos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "¿Cuánto te falta para tu premio?",
                            style: TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(height: 20),
                          _gaugeCard(puntos, maxGauge),
                          const SizedBox(height: 16),
                          if (veloData?.premioDisponible != null)
                            _premioDisponible(veloData!.premioDisponible!),
                          if (veloData?.premioDisponible != null)
                            const SizedBox(height: 16),
                          if (veloData?.proximoPremio != null)
                            _proximoPremio(veloData!.proximoPremio!),
                          if (veloData?.proximoPremio != null)
                            const SizedBox(height: 16),
                          if (veloData?.premioPremium != null)
                            _premioPremium(veloData!.premioPremium!),
                          const SizedBox(height: 16),
                          _resumenFinal(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _gaugeCard(int puntos, int maxGauge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 260,
            child: CustomPaint(
              painter: GaugePainter(
                value: puntos.toDouble(),
                max: maxGauge.toDouble(),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      _formatearNumero(puntos),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "puntos",
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("0 pts", style: TextStyle(color: Colors.white70)),
              Text(
                "${_formatearNumero(maxGauge ~/ 2)} pts",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "${_formatearNumero(maxGauge)} pts",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _premioDisponible(PremioVelocimetroModel premio) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0C5C4E).withOpacity(0.55),
            const Color(0xFF0A2437),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.85)),
      ),
      child: Row(
        children: [
          Icon(
            _getPremioIcon(premio.descripcion),
            color: Colors.white70,
            size: 38,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PREMIO DISPONIBLE",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  premio.descripcion,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "¡Ya puedes canjearlo!",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF19C58E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => _confirmarCanje(premio),
            child: const Text(
              "Canjear",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _proximoPremio(PremioVelocimetroModel premio) {
    final progreso = premio.puntosRequeridos > 0
        ? (premio.puntosDisponibles / premio.puntosRequeridos).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PRÓXIMO PREMIO",
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                _getPremioIcon(premio.descripcion),
                color: Colors.white70,
                size: 34,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  premio.descripcion,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: Colors.white12,
              color: Colors.lime,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: "Te faltan ",
                  style: TextStyle(color: Colors.white70),
                ),
                TextSpan(
                  text: "${premio.puntosFaltantes}",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: " pts",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _premioPremium(PremioVelocimetroModel premio) {
    final progreso = premio.puntosRequeridos > 0
        ? ((premio.puntosRequeridos - premio.puntosFaltantes) /
                premio.puntosRequeridos)
            .clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.redAccent.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Premio Premium",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            premio.descripcion,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${_formatearNumero(premio.puntosRequeridos)} pts",
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: Colors.white12,
              color: Colors.lime,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Te faltan ${_formatearNumero(premio.puntosFaltantes)} pts para alcanzar el premio más aspiracional.",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _resumenFinal() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Resumen del Día",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _infoMiniCard(
                  "${_formatearNumero(veloData?.puntosDisponibles ?? 0)}",
                  "Puntos actuales",
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoMiniCard(
                  "#${veloData?.ranking ?? 0}",
                  "Posición Ranking",
                  Colors.greenAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.lightBlue.withOpacity(0.5)),
            ),
            child: const Text(
              "🎯 Sigue así, cada venta te acerca más a tu próximo premio. ¡Tú puedes!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoMiniCard(String valor, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2338),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarCanje(PremioVelocimetroModel premio) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF0F2A44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: const Text(
        'Confirmar canje',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        '¿Deseas canjear ${premio.descripcion} por ${premio.puntosRequeridos} pts?',
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Canjear'),
        ),
      ],
    ),
  );

  if (confirmar != true) return;

  try {
    final comprobante = await dataSource.canjearPremio(
      cedula: cedulaActual,
      codigoBarras: premio.codigoBarras,
    );

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CanjeComprobanteDialog(
        comprobante: comprobante,
      ),
    );

    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    await cargarVelocimetro();
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al canjear: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  int _maximoGauge() {
    final premium = veloData?.premioPremium?.puntosRequeridos ?? 10000;
    if (premium <= 0) return 10000;

    final redondeado = ((premium + 999) ~/ 1000) * 1000;
    return redondeado < 3000 ? 3000 : redondeado;
  }

  IconData _getPremioIcon(String descripcion) {
    final desc = descripcion.toLowerCase();

    if (desc.contains('aud') || desc.contains('audí')) {
      return Icons.headphones;
    }
    if (desc.contains('parlante') || desc.contains('boom')) {
      return Icons.volume_up;
    }
    if (desc.contains('watch') || desc.contains('smartwatch')) {
      return Icons.watch;
    }
    if (desc.contains('gafas')) {
      return Icons.visibility_outlined;
    }
    if (desc.contains('telefono') || desc.contains('teléfono')) {
      return Icons.smartphone;
    }
    return Icons.card_giftcard;
  }

  String _formatearNumero(int numero) {
    final texto = numero.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = texto.length - 1; i >= 0; i--) {
      buffer.write(texto[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(',');
        count = 0;
      }
    }

    return buffer.toString().split('').reversed.join();
  }
}
class GaugePainter extends CustomPainter {
  final double value;
  final double max;

  GaugePainter({
    required this.value,
    required this.max,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width * 0.42;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final greenZonePaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final yellowZonePaint = Paint()
      ..color = Colors.amber.withOpacity(0.50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final redZonePaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    // fondo general
    canvas.drawArc(rect, pi, pi, false, backgroundPaint);

    // zonas del gauge:
    // verde = inicio a 70%
    canvas.drawArc(rect, pi, pi * 0.70, false, greenZonePaint);

    // amarillo = 70% a 90%
    canvas.drawArc(rect, pi + pi * 0.70, pi * 0.20, false, yellowZonePaint);

    // rojo = 90% a 100% (máximo premio)
    canvas.drawArc(rect, pi + pi * 0.90, pi * 0.10, false, redZonePaint);

    // progreso actual
    final progress = (value / max).clamp(0.0, 1.0);
    final sweep = progress * pi;
    final angle = pi + sweep;

    Color progressColor;
    if (progress >= 0.90) {
      progressColor = Colors.redAccent;
    } else if (progress >= 0.70) {
      progressColor = Colors.amber;
    } else {
      progressColor = const Color(0xFF18C58F);
    }

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, pi, sweep, false, progressPaint);

    // aguja
    final needlePaint = Paint()
      ..color = progressColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final arrowLength = radius - 30;
    final end = Offset(
      center.dx + arrowLength * cos(angle),
      center.dy + arrowLength * sin(angle),
    );

    canvas.drawLine(center, end, needlePaint);

    // punta flecha
    final arrowHeadSize = 12.0;
    final arrowAngle1 = angle - pi / 10;
    final arrowAngle2 = angle + pi / 10;

    final arrowPoint1 = Offset(
      end.dx - arrowHeadSize * cos(arrowAngle1),
      end.dy - arrowHeadSize * sin(arrowAngle1),
    );

    final arrowPoint2 = Offset(
      end.dx - arrowHeadSize * cos(arrowAngle2),
      end.dy - arrowHeadSize * sin(arrowAngle2),
    );

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy);

    canvas.drawPath(arrowPath, needlePaint);

    // centro
    final centerCircle = Paint()..color = progressColor;
    canvas.drawCircle(center, 8, centerCircle);

    final centerCircleInner = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, centerCircleInner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}