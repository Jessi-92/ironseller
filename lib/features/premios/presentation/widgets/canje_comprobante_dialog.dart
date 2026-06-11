import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/canje_comprobante_model.dart';

class CanjeComprobanteDialog extends StatefulWidget {
  final CanjeComprobanteModel comprobante;

  const CanjeComprobanteDialog({
    super.key,
    required this.comprobante,
  });

  @override
  State<CanjeComprobanteDialog> createState() => _CanjeComprobanteDialogState();
}

class _CanjeComprobanteDialogState extends State<CanjeComprobanteDialog> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool guardando = false;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDark ? const Color(0xFF071C31) : const Color(0xFFF4F7FB);

  Color get _cardColor =>
      _isDark ? const Color(0xFF0A223A) : Colors.white;

  Color get _innerCardColor =>
      _isDark ? const Color(0xFF0A1F36) : const Color(0xFFF1F5F9);

  Color get _titleColor =>
      _isDark ? Colors.white : const Color(0xFF0F172A);

  Color get _subtitleColor =>
      _isDark ? Colors.white.withOpacity(0.68) : const Color(0xFF64748B);

  Color get _mutedColor =>
      _isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF94A3B8);

  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.06);

  Color get _successColor =>
      _isDark ? const Color(0xFF19D29A) : const Color(0xFF059669);

  Future<void> guardarComprobante() async {
    try {
      setState(() {
        guardando = true;
      });

      final Uint8List? imageBytes = await screenshotController.capture(
        pixelRatio: 2,
      );

      if (imageBytes == null) {
        throw Exception('No se pudo generar la imagen');
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/comprobante_${widget.comprobante.idCanje}.png',
      );

      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Comprobante de canje - ${widget.comprobante.premio}',
      );

      if (!mounted) return;

      setState(() {
        guardando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar comprobante: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatearFecha(DateTime? fecha) {
    if (fecha == null) return '';

    return '${fecha.day.toString().padLeft(2, '0')} '
        '${_mes(fecha.month)} ${fecha.year}, '
        '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}';
  }

  String _mes(int month) {
    const meses = [
      '',
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return meses[month];
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.comprobante;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: _backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogHeader(),

              Flexible(
                child: SingleChildScrollView(
                  child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                      color: _backgroundColor,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: _isDark
                                  ? const Color(0xFF083D48)
                                  : const Color(0xFFE0F2FE),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isDark
                                    ? Colors.white.withOpacity(0.08)
                                    : const Color(0xFF38BDF8),
                              ),
                            ),
                            child: Icon(
                              _getPremioIcon(c.premio),
                              color: _isDark
                                  ? Colors.white70
                                  : const Color(0xFF0284C7),
                              size: 44,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            c.premio,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _titleColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Premio Canjeado',
                            style: TextStyle(
                              color: _subtitleColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 20),

                          _codigoCanjeBox(c.codigoCanje),

                          const SizedBox(height: 18),

                          _infoBox(
                            Icons.person_outline,
                            'Vendedor',
                            c.vendedor,
                            Colors.lightBlueAccent,
                          ),

                          const SizedBox(height: 12),

                          _infoBox(
                            Icons.storefront_outlined,
                            'Tienda',
                            c.tienda,
                            Colors.amber,
                          ),

                          const SizedBox(height: 12),

                          _infoBox(
                            Icons.calendar_month_outlined,
                            'Fecha de Canje',
                            formatearFecha(c.fecha),
                            Colors.greenAccent,
                          ),

                          const SizedBox(height: 12),

                          _infoBox(
                            Icons.my_location_outlined,
                            'Puntos Utilizados',
                            '${c.puntosUsados} pts',
                            Colors.pinkAccent,
                          ),

                          const SizedBox(height: 18),

                          _instruccionesBox(),

                          const SizedBox(height: 20),

                          Divider(color: _borderColor),

                          const SizedBox(height: 10),

                          Text(
                            'Este comprobante es válido por 30 días desde la fecha de canje',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Happy - IronSeller © 2025',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _subtitleColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              _actionsFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF22B8FF),
            Color(0xFF1487D4),
          ],
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              '¡Canje Exitoso!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _codigoCanjeBox(String codigoCanje) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isDark ? Colors.greenAccent : const Color(0xFF10B981),
        ),
        boxShadow: _shadow(),
      ),
      child: Column(
        children: [
          Text(
            'CÓDIGO DE CANJE',
            style: TextStyle(
              color: _subtitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            codigoCanje,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _successColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Presenta este código para retirar tu premio',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _subtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _instruccionesBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _isDark ? const Color(0xFF082742) : const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isDark ? Colors.lightBlue : const Color(0xFF38BDF8),
        ),
        boxShadow: _shadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instrucciones de Retiro',
            style: TextStyle(
              color: _titleColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '1. Guarda este comprobante en tu dispositivo\n'
            '2. Dirígete a tu tienda Happy asignada\n'
            '3. Presenta el código de canje al supervisor\n'
            '4. Retira tu premio físicamente',
            style: TextStyle(
              color: _subtitleColor,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsFooter() {
    return Container(
      color: _backgroundColor,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19C58E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: guardando ? null : guardarComprobante,
              icon: guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download_outlined),
              label: Text(
                guardando ? 'Guardando...' : 'Guardar',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isDark ? Colors.white : const Color(0xFFE2E8F0),
                foregroundColor:
                    _isDark ? Colors.black54 : const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cerrar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(IconData icon, String title, String value, Color iconColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _innerCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<BoxShadow> _shadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(_isDark ? 0.14 : 0.06),
        blurRadius: 14,
        offset: const Offset(0, 7),
      ),
    ];
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
}