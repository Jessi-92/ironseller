import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/datasource/velocimetro_remote_datasource.dart';
import '../../data/models/velocimetro_model.dart';
import '../../../premios/presentation/widgets/canje_comprobante_dialog.dart';
import '../../../../app/theme/app_colors.dart';

class VelocimetroPage extends StatefulWidget {
  final String cedula;

  const VelocimetroPage({
    super.key,
    required this.cedula,
  });

  @override
  State<VelocimetroPage> createState() => _VelocimetroPageState();
}

class _VelocimetroPageState extends State<VelocimetroPage> {
  final VelocimetroRemoteDataSource dataSource = VelocimetroRemoteDataSource();

  VelocimetroModel? veloData;
  bool isLoading = true;
  String error = '';

  String get cedulaActual => widget.cedula;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDark ? const Color(0xFF081B2E) : const Color.fromARGB(255, 220, 224, 228);

  Color get _cardColor =>
      _isDark ? const Color(0xFF0F2A44) : Colors.white;

  Color get _innerCardColor =>
      _isDark ? const Color(0xFF0A2338) : const Color(0xFFF1F5F9);

  Color get _titleColor =>
      _isDark ? Colors.white : const Color(0xFF0F172A);

  Color get _subtitleColor =>
      _isDark ? Colors.white.withOpacity(0.68) : const Color(0xFF64748B);

  Color get _mutedColor =>
      _isDark ? Colors.white.withOpacity(0.42) : const Color(0xFF94A3B8);

  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.06);

  Color get _primaryBlue =>
      _isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7);

  Color get _successColor =>
      _isDark ? AppColors.happyGreen : const Color(0xFF059669);

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
        error = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final puntos = veloData?.puntosDisponibles ?? 0;
    final maxGauge = _maximoGauge();

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: _successColor,
                ),
              )
            : error.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: _titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: _primaryBlue,
                    onRefresh: cargarVelocimetro,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 115),
                      child: Column(
                        children: [
                          Text(
                            "Velocímetro de Puntos",
                            style: TextStyle(
                              color: _titleColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            veloData?.nombre ?? '',
                            style: TextStyle(
                              color: _subtitleColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            veloData?.tienda ?? '',
                            style: TextStyle(
                              color: _mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
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
      decoration: _cardDecoration(radius: 22),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: GaugePainter(
                value: puntos.toDouble(),
                max: maxGauge.toDouble(),
                isDark: _isDark,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      _formatearNumero(puntos),
                      style: TextStyle(
                        color: _titleColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "puntos",
                      style: TextStyle(
                        color: _subtitleColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
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
              _gaugeLabel("0 pts"),
              _gaugeLabel("${_formatearNumero(maxGauge ~/ 2)} pts"),
              _gaugeLabel("${_formatearNumero(maxGauge)} pts"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gaugeLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _subtitleColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _premioDisponible(PremioVelocimetroModel premio) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDark
              ? [
                  const Color(0xFF0C5C4E).withOpacity(0.55),
                  const Color(0xFF0A2437),
                ]
              : [
                  const Color(0xFFD1FAE5),
                  const Color(0xFFFFFFFF),
                ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isDark
              ? AppColors.happyGreen.withOpacity(0.85)
              : const Color(0xFF10B981),
        ),
        boxShadow: _shadow(),
      ),
      child: Row(
        children: [
          Icon(
            _getPremioIcon(premio.descripcion),
            color: _isDark ? Colors.white70 : const Color(0xFF047857),
            size: 38,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PREMIO DISPONIBLE",
                  style: TextStyle(
                    color: _successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  premio.descripcion,
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "¡Ya puedes canjearlo!",
                  style: TextStyle(
                    color: _subtitleColor,
                    fontWeight: FontWeight.w600,
                  ),
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
      decoration: _cardDecoration(
        radius: 18,
        borderColor: AppColors.happyGreen.withOpacity(_isDark ? 0.35 : 0.55),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PRÓXIMO PREMIO",
            style: TextStyle(
              color: AppColors.happyGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                _getPremioIcon(premio.descripcion),
                color: _subtitleColor,
                size: 34,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  premio.descripcion,
                  style: TextStyle(
                    color: _titleColor,
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
              backgroundColor:
                  _isDark ? Colors.white12 : const Color(0xFFE2E8F0),
              color: Colors.lime,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Te faltan ",
                  style: TextStyle(
                    color: _subtitleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: "${premio.puntosFaltantes}",
                  style: const TextStyle(
                    color: AppColors.happyGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " pts",
                  style: TextStyle(
                    color: _subtitleColor,
                    fontWeight: FontWeight.w600,
                  ),
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
        color: _isDark
            ? Colors.red.withOpacity(0.14)
            : const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.redAccent.withOpacity(_isDark ? 0.35 : 0.55),
        ),
        boxShadow: _shadow(),
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
            style: TextStyle(
              color: _titleColor,
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
              backgroundColor:
                  _isDark ? Colors.white12 : const Color(0xFFE2E8F0),
              color: Colors.lime,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Te faltan ${_formatearNumero(premio.puntosFaltantes)} pts para alcanzar el premio más aspiracional.",
            style: TextStyle(
              color: _subtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumenFinal() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(
        radius: 18,
        borderColor: Colors.blueAccent.withOpacity(_isDark ? 0.35 : 0.45),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Resumen del Día",
              style: TextStyle(
                color: _titleColor,
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
                  AppColors.happyGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isDark
                  ? Colors.blue.withOpacity(0.18)
                  : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isDark
                    ? Colors.lightBlue.withOpacity(0.5)
                    : const Color(0xFF38BDF8),
              ),
            ),
            child: Text(
              "🎯 Sigue así, cada venta te acerca más a tu próximo premio. ¡Tú puedes!",
              style: TextStyle(
                color: _isDark ? Colors.white : const Color(0xFF075985),
                fontWeight: FontWeight.w700,
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
        color: _innerCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04),
        ),
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
            style: TextStyle(
              color: _subtitleColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarCanje(PremioVelocimetroModel premio) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF0F2A44) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Confirmar canje',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Deseas canjear ${premio.descripcion} por ${premio.puntosRequeridos} pts?',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.70)
                  : const Color(0xFF475569),
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDark
                      ? Colors.lightBlueAccent
                      : const Color(0xFF0284C7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19C58E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Canjear'),
            ),
          ],
        );
      },
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

  BoxDecoration _cardDecoration({
    required double radius,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: _cardColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? _borderColor),
      boxShadow: _shadow(),
    );
  }

  List<BoxShadow> _shadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(_isDark ? 0.14 : 0.06),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
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
  final bool isDark;

  GaugePainter({
    required this.value,
    required this.max,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width * 0.42;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..color = isDark ? Colors.white10 : const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final greenZonePaint = Paint()
      ..color = isDark
          ? AppColors.happyGreen.withOpacity(0.45)
          : const Color(0xFF10B981).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final yellowZonePaint = Paint()
      ..color = AppColors.happyGreen.withOpacity(isDark ? 0.50 : 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final redZonePaint = Paint()
      ..color = Colors.redAccent.withOpacity(isDark ? 0.55 : 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, pi, pi, false, backgroundPaint);
    canvas.drawArc(rect, pi, pi * 0.70, false, greenZonePaint);
    canvas.drawArc(rect, pi + pi * 0.70, pi * 0.20, false, yellowZonePaint);
    canvas.drawArc(rect, pi + pi * 0.90, pi * 0.10, false, redZonePaint);

    final progress = (value / max).clamp(0.0, 1.0);
    final sweep = progress * pi;
    final angle = pi + sweep;

    Color progressColor;
    if (progress >= 0.90) {
      progressColor = Colors.redAccent;
    } else if (progress >= 0.70) {
      progressColor = AppColors.happyGreen;
    } else {
      progressColor = const Color(0xFF18C58F);
    }

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, pi, sweep, false, progressPaint);

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

    final centerCircle = Paint()..color = progressColor;
    canvas.drawCircle(center, 8, centerCircle);

    final centerCircleInner = Paint()
      ..color = isDark ? Colors.white : const Color(0xFFF8FAFC);

    canvas.drawCircle(center, 4, centerCircleInner);
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.max != max ||
        oldDelegate.isDark != isDark;
  }
}