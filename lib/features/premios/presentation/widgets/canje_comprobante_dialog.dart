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
          color: const Color(0xFF071C31),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF22B8FF), Color(0xFF1487D4)],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: Colors.white, size: 30),
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
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                      color: const Color(0xFF071C31),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: const Color(0xFF083D48),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.headphones,
                              color: Colors.white70,
                              size: 44,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            c.premio,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Premio Canjeado',
                            style: TextStyle(color: Colors.white60),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A223A),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.greenAccent),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'CÓDIGO DE CANJE',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  c.codigoCanje,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF19D29A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Presenta este código para retirar tu premio',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          _infoBox(Icons.person_outline, 'Vendedor', c.vendedor,
                              Colors.lightBlueAccent),
                          const SizedBox(height: 12),
                          _infoBox(Icons.storefront_outlined, 'Tienda', c.tienda,
                              Colors.amber),
                          const SizedBox(height: 12),
                          _infoBox(Icons.calendar_month_outlined,
                              'Fecha de Canje', formatearFecha(c.fecha),
                              Colors.greenAccent),
                          const SizedBox(height: 12),
                          _infoBox(Icons.my_location_outlined, 'Puntos Utilizados',
                              '${c.puntosUsados} pts', Colors.pinkAccent),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF082742),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.lightBlue),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Instrucciones de Retiro',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  '1. Guarda este comprobante en tu dispositivo\n'
                                  '2. Dirígete a tu tienda Happy asignada\n'
                                  '3. Presenta el código de canje al supervisor\n'
                                  '4. Retira tu premio físicamente',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white12),
                          const SizedBox(height: 10),
                          const Text(
                            'Este comprobante es válido por 30 días desde la fecha de canje',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white38),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Happy - IronSeller © 2025',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: const Color(0xFF071C31),
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
                          guardando ? 'Guardando...' : 'Guardar Comprobante',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(IconData icon, String title, String value, Color iconColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F36),
        borderRadius: BorderRadius.circular(16),
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
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
}