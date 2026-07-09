import 'package:flutter/material.dart';
import '../../data/datasource/inicio_remote_datasource.dart';
import '../../../login/presentation/pages/login_page.dart';
import '../../../perfil/presentation/pages/perfil_page.dart';
import '../../data/models/inicio_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/app_config.dart';



class HomePage extends StatefulWidget {
  final String cedula;

  const HomePage({
    super.key,
    required this.cedula,
  });

  @override
  State<HomePage> createState() => _HomePageState();

}
String _fotoPerfilUrl(String fotoUrl) {
  if (fotoUrl.trim().isEmpty) return '';

  if (fotoUrl.startsWith('http')) {
    return fotoUrl;
  }

  return '${AppConfig.serverBaseUrl}$fotoUrl';
}

class _HomePageState extends State<HomePage> {
  final InicioRemoteDataSource dataSource = InicioRemoteDataSource();

  InicioModel? inicioData;
  bool isLoading = true;
  String error = '';

  String get cedulaActual => widget.cedula;

  @override
  void initState() {
    super.initState();
    cargarInicio();
  }

  Future<void> cargarInicio() async {
    try {
      final result = await dataSource.getInicio(cedulaActual);

      if (!mounted) return;

      setState(() {
        inicioData = result;
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

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF0F2A44) : const Color(0xFFE5EAF0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Cerrar sesión',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Deseas salir y volver al login?',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.70)
                  : const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF081B2E) : const Color.fromARGB(255, 220, 224, 228),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color:
                      isDark ? AppColors.happyGreen : const Color(0xFF0284C7),
                ),
              )
            : error.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: isDark
                        ? AppColors.happyGreen
                        : const Color(0xFF0284C7),
                    onRefresh: cargarInicio,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                      child: Column(
                        children: [
                          _header(),
                          const SizedBox(height: 20),
                          _meta(),
                          const SizedBox(height: 20),
                          _cards(),
                          const SizedBox(height: 20),
                          _resumen(),
                          const SizedBox(height: 20),
                          _ranking(),
                          const SizedBox(height: 20),
                          _rankingTiendas(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _header() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nombre = inicioData?.nombre ?? '';
    final fotoUrl = inicioData?.fotoUrl ?? '';
    final fotoCompleta = _fotoPerfilUrl(fotoUrl);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF0F2A44),
                  const Color(0xFF1677FF),
                ]
              : [
                  const Color(0xFFFFFFFF),
                  const Color(0xFFDCEEFF),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.10)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PerfilPage(
                    cedula: cedulaActual,
                  ),
                ),
              );

              if (mounted) {
                cargarInicio();
              }
            },
            child: ClipOval(
              child: Container(
                width: 60,
                height: 60,
                color: isDark ? Colors.white.withOpacity(0.20) : Colors.white,
                child: fotoCompleta.isNotEmpty
                    ? Image.network(
                        fotoCompleta,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              _iniciales(nombre),
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0284C7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          _iniciales(nombre),
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0284C7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _capitalizarNombre(nombre),
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFBFCF03)
                        : const Color(0xFF0F3558),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFC2D100), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      inicioData?.cargo ?? "Vendedor",
                      style: const TextStyle(
                        color: Color(0xFFC2D100),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _cerrarSesion,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.16)
                    : const Color(0xFF0284C7).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.logout,
                color: isDark ? Colors.white : const Color(0xFF0284C7),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Resumen Section

    Widget _resumen() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final valueColor = isDark ? AppColors.happyGreen : const Color(0xFF19375F);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: Color(0xFFC2D100)),
              const SizedBox(width: 6),
              Text(
                "Mi resumen",
                style: TextStyle(
                  color: titleColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _miniCard(
                  "Ventas Hoy",
                  "${inicioData?.ventasHoy ?? 0}",
                  "ventas del día",
                  valueColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniCard(
                  "Ventas Mes",
                  "${inicioData?.ventasMesActual ?? 0}",
                  "mes actual",
                  valueColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _miniCard(
                  "Total Mes",
                  "\$${_formatearDecimal(inicioData?.totalDolaresMesActual ?? 0)}",
                  "vendido este mes",
                  valueColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniCard(
                  "Ticket Mes",
                  "\$${_formatearDecimal(inicioData?.ticketPromedio ?? 0)}",
                  "promedio por factura",
                  valueColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _miniCard(
                  "Productividad",
                  "${_formatearDecimal(inicioData?.productividad ?? 0)}/día",
                  "${inicioData?.diasTranscurridos ?? 0} días del mes",
                  valueColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniCard(
                  "Puntos Totales",
                  _formatearNumero(inicioData?.puntosTotales ?? 0),
                  "pts disponibles",
                  valueColor,
                ),
              ),
            ],
          ),
        ],
      );
    }

  Widget _miniCard(
  String title,
  String value,
  String subtitle,
  Color valueColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardTitleColor =
        isDark ? AppColors.happyGreen : AppColors.happyBlue;

    final cardValueColor =
        isDark ? Colors.white : AppColors.happyGreen;

    final cardSubtitleColor =
        isDark ? Colors.white.withOpacity(0.65) : AppColors.mutedLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.14 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: cardTitleColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: cardValueColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: cardSubtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final porcentajeReal = inicioData?.porcentajeCumplimiento ?? 0;
    final porcentajeBarra = porcentajeReal.clamp(0, 100);
    final progreso = porcentajeBarra / 100;

    final vendido = inicioData?.totalDolaresMeta ?? 0;
    final meta = inicioData?.metaDolares ?? 0;
    final falta = inicioData?.faltanteMeta ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2A44) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.14 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes, color: Colors.redAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Meta de Ventas",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _metaDato(
                  titulo: "Vendido",
                  valor: "\$${_formatearDecimal(vendido)}",
                  color: isDark ? AppColors.happyGreen : AppColors.happyGreen,
                ),
              ),
              Expanded(
                child: _metaDato(
                  titulo: "Meta",
                  valor: "\$${_formatearDecimal(meta)}",
                  color:isDark ? Colors.lightBlueAccent : Color(0xFF19375F),
                ),
              ),
              Expanded(
                child: _metaDato(
                  titulo: "Falta",
                  valor: "\$${_formatearDecimal(falta)}",
                  color: AppColors.happyGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: isDark
                  ? const Color.fromARGB(181, 37, 120, 210)
                  : const Color(0xFFE2E8F0),
              color: const Color(0xFFC2D102),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Text(
                  "${porcentajeReal.toStringAsFixed(2)}% de cumplimiento",
                  style: TextStyle(
                    color: isDark ? AppColors.happyGreen : const Color(0xFF059669),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "Falta ${_formatearDecimal(inicioData?.porcentajeFaltante ?? 0)}%",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "💡",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    inicioData?.comentarioMeta ?? '',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.72)
                          : const Color(0xFF475569),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaDato({
    required String titulo,
    required String valor,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: isDark
                ? Colors.white.withOpacity(0.55)
                : const Color(0xFF64748B),
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

  Widget _cards() {
    return Row(
      children: [
        Expanded(
          child: _bigCard(
            "\$${_formatearDecimal(inicioData?.metaDolares ?? 0)}",
            "Meta",
            const LinearGradient(
              colors: [Color(0xFF063D77), Color(0xFF0A4E92)],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _bigCard(
            "${(inicioData?.porcentajeCumplimiento ?? 0).toStringAsFixed(2)}%",
            "Cumplimiento",
            const LinearGradient(
              colors: [Color(0xFF164C32), Color(0xFF224D36)],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _bigCard(
            "#${inicioData?.ranking ?? 0}",
            "Ranking",
            const LinearGradient(
              colors: [Color(0xFF5B4615), Color(0xFF65511B)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bigCard(String value, String title, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ranking() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final top = inicioData?.topVendedores ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber),
            const SizedBox(width: 6),
            Text(
              "Ranking de Vendedores",
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...top.map((item) => _rankingItem(item)).toList(),
      ],
    );
  }

  Widget _rankingTiendas() {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final topTiendas = inicioData?.topTiendas ?? [];
  final rankingTienda = inicioData?.rankingTienda ?? 0;
  final tiendaUsuario = inicioData?.tienda ?? '';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(Icons.storefront, color: AppColors.happyGreen),
          const SizedBox(width: 6),
          Text(
            "Ranking de Tiendas",
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textLight,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.13 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Text(
          "Competición por cumplimiento de meta en dólares. Tu equipo está en ${rankingTienda}ª posición nacional.",
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.mutedLight,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      const SizedBox(height: 12),

      ...topTiendas.map((tienda) {
        final esMiTienda = tienda.nombreTienda == tiendaUsuario;
        return _itemTienda(tienda, esMiTienda);
      }).toList(),
    ],
  );
}

  Widget _itemTienda(TopTiendaModel tienda, bool esMiTienda) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: esMiTienda
            ? AppColors.happyGreen
            : isDark
                ? Colors.white.withOpacity(0.06)
                : AppColors.borderLight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.13 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Text(
            "${tienda.posicion}°",
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tienda.nombreTienda,
                      style: const TextStyle(
                        color: AppColors.happyGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (esMiTienda)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.happyGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Tu Tienda",
                        style: TextStyle(
                          color: AppColors.happyBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "${tienda.porcentajeCumplimiento.toStringAsFixed(2)}% de cumplimiento",
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.happyBlue,
                  fontSize: 13,
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

  Widget _rankingItem(TopVendedorModel item) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final esUsuario = item.cedula == cedulaActual;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: esUsuario
            ? AppColors.happyGreen
            : isDark
                ? Colors.white.withOpacity(0.06)
                : AppColors.borderLight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.13 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Text(
            "${item.posicion}°",
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _capitalizarNombre(item.nombre),
                      style: TextStyle(
                        color: isDark ? AppColors.happyGreen :AppColors.happyGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (esUsuario)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.happyGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Tú",
                        style: TextStyle(
                          color: AppColors.happyBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "${item.totalVentas} ventas · Hoy ${item.ventasHoy} · ${item.porcentajeCumplimiento.toStringAsFixed(2)}%",
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.happyBlue,
                  fontSize: 13,
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
  String _iniciales(String nombre) {
    final partes = nombre.trim().split(' ').where((e) => e.isNotEmpty).toList();

    if (partes.isEmpty) return '??';
    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }

    return (partes[0].substring(0, 1) + partes[1].substring(0, 1))
        .toUpperCase();
  }

  String _capitalizarNombre(String texto) {
    if (texto.trim().isEmpty) return texto;

    return texto
        .toLowerCase()
        .split(' ')
        .map((palabra) {
          if (palabra.isEmpty) return palabra;
          return palabra[0].toUpperCase() + palabra.substring(1);
        })
        .join(' ');
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
}