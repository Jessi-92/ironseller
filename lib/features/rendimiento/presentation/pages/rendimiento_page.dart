import 'package:flutter/material.dart';
import '../../data/datasource/rendimiento_remote_datasource.dart';
import '../../data/models/rendimiento_model.dart';
import '../../../../app/theme/app_colors.dart';

class RendimientoPage extends StatefulWidget {
  final String cedula;

  const RendimientoPage({
    super.key,
    required this.cedula,
  });

  @override
  State<RendimientoPage> createState() => _RendimientoPageState();
}

class _RendimientoPageState extends State<RendimientoPage> {
  final RendimientoRemoteDataSource dataSource = RendimientoRemoteDataSource();

  RendimientoModel? rendimientoData;
  bool isLoading = true;
  String error = '';

  String get cedulaActual => widget.cedula;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDark ? const Color(0xFF081B2E) : const Color.fromARGB(255, 220, 224, 228);

  Color get _cardColor => _isDark ? const Color(0xFF0F2A44) : Colors.white;

  Color get _titleColor => _isDark ? Colors.white : const Color(0xFF0F172A);

  Color get _subtitleColor =>
      _isDark ? Colors.white.withOpacity(0.65) : const Color(0xFF64748B);

  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.06);

  Color get _primaryBlue =>
      _isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7);

  Color get _successColor =>
      _isDark ? AppColors.happyGreen : const Color(0xFF19375F);

  Color get _successColor1 =>
      _isDark ? AppColors.happyGreen : AppColors.happyGreen;

  @override
  void initState() {
    super.initState();
    cargarRendimiento();
  }

  Future<void> cargarRendimiento() async {
    try {
      final result = await dataSource.getRendimiento(cedulaActual);

      if (!mounted) return;

      setState(() {
        rendimientoData = result;
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
                    onRefresh: cargarRendimiento,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 115),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mi Rendimiento",
                            style: TextStyle(
                              color: _titleColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            rendimientoData?.nombre ?? '',
                            style: TextStyle(
                              color: _subtitleColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _graficaSemanal(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _datoResumen(String titulo, String valor, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: _subtitleColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          valor,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
Widget _graficaSemanal() {
  final semanas = rendimientoData?.ventasPorSemana ?? [];

  if (semanas.isEmpty) {
    return _emptyBox("No hay ventas semanales registradas.");
  }

  return Column(
    children: semanas.map((semana) => _cardSemana(semana)).toList(),
  );
}


Widget _cardSemana(VentaSemanaModel item) {
  final colorEstado = item.diferencia >= 0 ? _successColor1 : Colors.redAccent;
  final textoEstado = item.diferencia >= 0
      ? "Sobra \$${_formatearDecimal(item.sobrante)}"
      : "Falta \$${_formatearDecimal(item.faltante)}";

  final mayorDia = item.dias
      .map((e) => e.vendidoDia)
      .fold<double>(1, (a, b) => a > b ? a : b);

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: _cardColor,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: item.esSemanaActual
            ? AppColors.happyGreen
            : (_isDark ? _borderColor : AppColors.happyBlueDark),
        width: item.esSemanaActual ? 1.5 : 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(_isDark ? 0.14 : 0.06),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Semana ${item.semana}",
                style: TextStyle(
                  color: _titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: colorEstado.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colorEstado.withOpacity(0.55)),
              ),
              child: Text(
                textoEstado,
                style: TextStyle(
                  color: colorEstado,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          "${_formatearFechaCompleta(item.fechaInicio)} - ${_formatearFechaCompleta(item.fechaFin)} · ${item.diasSemana} días",
          style: TextStyle(
            color: _subtitleColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _datoSemana(
                "Meta",
                "\$${_formatearDecimal(item.metaAjustadaSemanal)}",
                _primaryBlue,
              ),
            ),
            Expanded(
              child: _datoSemana(
                "Hizo",
                "\$${_formatearDecimal(item.vendidoSemanal)}",
                _successColor,
              ),
            ),
            Expanded(
              child: _datoSemana(
                "Cumpl.",
                "${_formatearDecimal(item.porcentajeCumplimiento)}%",
                colorEstado,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: item.dias.map((dia) {
              final altura = dia.vendidoDia <= 0
                  ? 10.0
                  : ((dia.vendidoDia / mayorDia) * 105)
                      .clamp(16.0, 105.0)
                      .toDouble();

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (dia.vendidoDia > 0)
                        Text(
                          "\$${_formatearDecimal(dia.vendidoDia)}",
                          style: TextStyle(
                            color: _successColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 22,
                        height: altura,
                        decoration: BoxDecoration(
                          color: dia.vendidoDia > 0
                              ? _primaryBlue
                              : Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${dia.dia}",
                        style: TextStyle(
                          color: _subtitleColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 14),

        InkWell(
          onTap: () => _mostrarDetalleSemana(item),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: _isDark
                  ? Colors.white.withOpacity(0.06)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isDark
                    ? Colors.white.withOpacity(0.08)
                    : AppColors.happyBlueDark,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                "Ver detalle de la semana",
                style: TextStyle(
                  color: _primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}



  Widget _leyenda(String letra, String texto, Color color) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            letra,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          texto,
          style: TextStyle(
            color: _subtitleColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _mostrarDetalleSemana(VentaSemanaModel item) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final colorEstado =
          item.diferencia >= 0 ? AppColors.happyGreen : Colors.redAccent;

      return Dialog(
        insetPadding: const EdgeInsets.all(14),
        backgroundColor: isDark ? const Color(0xFF0F2A44) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 650,
            maxHeight: 760,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Semana ${item.semana}",
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'lib/assets/images/logo_happy.png',
                      height: 34,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detalleLinea(
                        "Periodo",
                        "${_formatearFechaCompleta(item.fechaInicio)} - ${_formatearFechaCompleta(item.fechaFin)}",
                        isDark,
                      ),
                      const SizedBox(height: 10),
                      _detalleLinea(
                        "Meta base",
                        "\$${_formatearDecimal(item.metaBaseSemanal)}",
                        isDark,
                      ),
                      const SizedBox(height: 10),
                      _detalleLinea(
                        "Meta ajustada",
                        "\$${_formatearDecimal(item.metaAjustadaSemanal)}",
                        isDark,
                      ),
                      const SizedBox(height: 10),
                      _detalleLinea(
                        "Vendido",
                        "\$${_formatearDecimal(item.vendidoSemanal)}",
                        isDark,
                      ),
                      const SizedBox(height: 10),
                      _detalleLinea(
                        "Ventas",
                        "${item.cantidadVentas}",
                        isDark,
                      ),
                      const SizedBox(height: 10),
                      _detalleLinea(
                        "Cumplimiento",
                        "${_formatearDecimal(item.porcentajeCumplimiento)}%",
                        isDark,
                      ),
                      const SizedBox(height: 10),
                      _detalleLinea(
                        item.diferencia >= 0 ? "Excedente" : "Faltante",
                        "\$${_formatearDecimal(item.diferencia.abs())}",
                        isDark,
                        valueColor: colorEstado,
                      ),

                      const SizedBox(height: 22),

                      Text(
                        "Detalle por día",
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...item.dias.map((dia) {
                        final ventasDelDia = item.detalleVentas
                            .where((venta) => venta.fecha == dia.fecha)
                            .toList();

                        return _detalleDiaSemana(
                          dia: dia,
                          ventasDelDia: ventasDelDia,
                          isDark: isDark,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        "Cerrar",
                        style: TextStyle(
                          color: isDark
                              ? Colors.lightBlueAccent
                              : const Color(0xFF0284C7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _detalleDiaSemana({
  required DiaSemanaModel dia,
  required List<DetalleVentaSemanaModel> ventasDelDia,
  required bool isDark,
}) {
  final totalDia = ventasDelDia.fold<double>(
    0,
    (suma, venta) => suma + venta.precioVenta,
  );

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.05),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Día ${_formatearFechaCompleta(dia.fecha)}",
                style: TextStyle(
                  color: isDark ? AppColors.happyGreen : AppColors.happyBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "${ventasDelDia.length} venta(s)",
              style: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.65)
                    : const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          "Total del día: \$${_formatearDecimal(totalDia)}",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        if (ventasDelDia.isEmpty)
          Text(
            "No se registraron ventas este día.",
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.50)
                  : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          )
        else
          ...ventasDelDia.map((venta) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0B2238)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.black.withOpacity(0.04),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Factura: ${venta.factura}",
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.75)
                          : const Color(0xFF475569),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Marca: ${venta.marca.trim().isEmpty ? 'No registrado' : venta.marca}",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Modelo: ${venta.modelo.trim().isEmpty ? 'No registrado' : venta.modelo}",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Valor: \$${_formatearDecimal(venta.precioVenta)}",
                    style: TextStyle(
                      color: isDark
                          ? AppColors.happyGreen
                          : const Color(0xFF059669),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    ),
  );
}

  Widget _detalleLinea(
    String titulo,
    String valor,
    bool isDark, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 115,
          child: Text(
            titulo,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.60)
                  : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: TextStyle(
              color: valueColor ??
                  (isDark ? Colors.white : const Color(0xFF0F172A)),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _datoSemana(String titulo, String valor, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titulo,
        style: TextStyle(
          color: _subtitleColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        valor,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

  Widget _emptyBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 18),
      child: Text(
        text,
        style: TextStyle(
          color: _subtitleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration({required double radius}) {
    return BoxDecoration(
      color: _cardColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: _borderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(_isDark ? 0.14 : 0.06),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  String _formatearDecimal(double numero) {
    return numero.toStringAsFixed(2);
  }

  String _formatearFechaCorta(String fecha) {
    if (fecha.length >= 10) {
      final partes = fecha.substring(0, 10).split('-');

      if (partes.length == 3) {
        return "${partes[2]}/${partes[1]}";
      }
    }

    return fecha;
  }

  String _formatearFechaCompleta(String fecha) {
    if (fecha.length >= 10) {
      final partes = fecha.substring(0, 10).split('-');

      if (partes.length == 3) {
        return "${partes[2]}/${partes[1]}/${partes[0]}";
      }
    }

    return fecha;
  }
}