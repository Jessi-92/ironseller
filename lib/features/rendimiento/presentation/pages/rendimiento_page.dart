import 'package:flutter/material.dart';
import '../../data/datasource/rendimiento_remote_datasource.dart';
import '../../data/models/rendimiento_model.dart';

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

  Color get _cardColor =>
      _isDark ? const Color(0xFF0F2A44) : Colors.white;

  Color get _titleColor =>
      _isDark ? Colors.white : const Color(0xFF0F172A);

  Color get _subtitleColor =>
      _isDark ? Colors.white.withOpacity(0.65) : const Color(0xFF64748B);

  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.06);

  Color get _primaryBlue =>
      _isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7);

  Color get _successColor =>
      _isDark ? Colors.greenAccent : const Color(0xFF059669);

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

                          _graficaVentasPorDia(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _barraPuntos({
    required String titulo,
    required int valor,
    required int mayor,
    required Color color,
  }) {
    final progreso = mayor == 0 ? 0.0 : (valor / mayor).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                titulo,
                style: TextStyle(
                  color: _isDark
                      ? Colors.white.withOpacity(0.72)
                      : const Color(0xFF475569),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              "${_formatearNumero(valor)} pts",
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progreso,
            minHeight: 10,
            backgroundColor:
                _isDark ? Colors.white12 : const Color(0xFFE2E8F0),
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _graficaVentasPorDia() {
    final ventasPorDia = rendimientoData?.ventasPorDia ?? [];

    if (ventasPorDia.isEmpty) {
      return _emptyBox("No hay ventas registradas por día.");
    }

    final mayorVentas = ventasPorDia
        .map((e) => e.ventasRealizadas)
        .fold<int>(1, (a, b) => a > b ? a : b);

    final totalVentas = ventasPorDia.fold<int>(
      0,
      (suma, item) => suma + item.ventasRealizadas,
    );

    final totalDolares = ventasPorDia.fold<double>(
      0,
      (suma, item) => suma + item.totalDolares,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("📈", style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                "Ventas por Día",
                style: TextStyle(
                  color: _titleColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "$totalVentas ventas acumuladas · \$${_formatearDecimal(totalDolares)} vendidos",
            style: TextStyle(
              color: _subtitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 250,
            child: Scrollbar(
              thumbVisibility: true,
              radius: const Radius.circular(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ventasPorDia.map((item) {
                    final altura = item.ventasRealizadas <= 0
                        ? 8.0
                        : ((item.ventasRealizadas / mayorVentas) * 145)
                            .clamp(20.0, 145.0)
                            .toDouble();

                    return GestureDetector(
                      onTap: () => _mostrarDetalleVentaDia(item),
                      child: Container(
                        width: 46,
                        margin: const EdgeInsets.only(right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${item.ventasRealizadas}",
                              style: TextStyle(
                                color: _successColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 19,
                              height: altura,
                              decoration: BoxDecoration(
                                color: _primaryBlue,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _primaryBlue.withOpacity(0.24),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatearFechaCorta(item.fecha),
                              style: TextStyle(
                                color: _subtitleColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Desliza horizontalmente para ver todos los días. Toca una barra para ver el detalle.",
            style: TextStyle(
              color: _isDark
                  ? Colors.white.withOpacity(0.38)
                  : const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalleVentaDia(VentaDiaModel item) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

      return AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F2A44) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(
          "Detalle del día",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detalleLinea(
                  "Fecha",
                  _formatearFechaCompleta(item.fecha),
                  isDark,
                ),
                const SizedBox(height: 10),
                _detalleLinea(
                  "Ventas",
                  "${item.ventasRealizadas}",
                  isDark,
                ),
                const SizedBox(height: 10),
                _detalleLinea(
                  "Total vendido",
                  "\$${_formatearDecimal(item.totalDolares)}",
                  isDark,
                ),

                const SizedBox(height: 18),

                Text(
                  "Productos vendidos",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 10),

                if (item.detalleVentas.isEmpty)
                  Text(
                    "No hay detalle de productos registrado.",
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.65)
                          : const Color(0xFF64748B),
                    ),
                  )
                else
                  ...item.detalleVentas.map((venta) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Marca: ${venta.marca.trim().isEmpty ? 'No registrado' : venta.marca}",
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Modelo: ${venta.modelo.trim().isEmpty ? 'No registrado' : venta.modelo}",
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Valor: \$${_formatearDecimal(venta.precioVenta)}",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.greenAccent
                                  : const Color(0xFF059669),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        actions: [
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
      );
    },
  );
}

  Widget _detalleLinea(String titulo, String valor, bool isDark) {
    return Row(
      children: [
        SizedBox(
          width: 105,
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
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
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