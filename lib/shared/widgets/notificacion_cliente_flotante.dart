import 'dart:async';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../models/notificacion_cliente_model.dart';
import '../services/notificaciones_cliente_service.dart';

class NotificacionClienteFlotante extends StatefulWidget {
  const NotificacionClienteFlotante({super.key});

  @override
  State<NotificacionClienteFlotante> createState() =>
      _NotificacionClienteFlotanteState();
}

class _NotificacionClienteFlotanteState
    extends State<NotificacionClienteFlotante> {
  NotificacionClienteModel? notificacionActual;
  bool visible = false;

  StreamSubscription<NotificacionClienteModel>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription =
        NotificacionesClienteService().notificaciones.listen((notificacion) {
      if (!mounted) return;

      setState(() {
        notificacionActual = notificacion;
        visible = true;
      });

      Future.delayed(const Duration(seconds: 7), () {
        if (!mounted) return;

        setState(() {
          visible = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (notificacionActual == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alerta = notificacionActual!.estaEnListaNegra;

    return Positioned(
      top: 18,
      left: 16,
      right: 16,
      child: IgnorePointer(
        ignoring: !visible,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 350),
          child: AnimatedSlide(
            offset: visible ? Offset.zero : const Offset(0, -0.25),
            duration: const Duration(milliseconds: 350),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F2A44) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: alerta ? Colors.redAccent : AppColors.happyGreen,
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.35 : 0.14),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _avatar(alerta),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notificacionActual!.nombreCliente,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : AppColors.happyBlueDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notificacionActual!.mensaje,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.76)
                                  : const Color(0xFF475569),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (notificacionActual!.creditosVigentes > 0) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Créditos vigentes: ${notificacionActual!.creditosVigentes}',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white.withOpacity(0.70)
                                    : const Color(0xFF64748B),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          visible = false;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        color: isDark
                            ? Colors.white.withOpacity(0.70)
                            : const Color(0xFF64748B),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar(bool alerta) {
    final fotoUrl = notificacionActual?.fotoUrl;

    if (fotoUrl != null && fotoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          fotoUrl,
          width: 42,
          height: 42,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _iconoDefault(alerta);
          },
        ),
      );
    }

    return _iconoDefault(alerta);
  }

  Widget _iconoDefault(bool alerta) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: alerta
            ? Colors.redAccent.withOpacity(0.16)
            : AppColors.happyGreen.withOpacity(0.18),
        shape: BoxShape.circle,
      ),
      child: Icon(
        alerta ? Icons.warning_amber_rounded : Icons.verified,
        color: alerta ? Colors.redAccent : AppColors.happyGreen,
      ),
    );
  }
}