import 'package:flutter/material.dart';
import '../../data/datasource/ranking_remote_datasource.dart';
import '../../data/models/ranking_model.dart';

class RankingsPage extends StatefulWidget {
  final String cedula;

  const RankingsPage({
    super.key,
    required this.cedula,
  });

  @override
  State<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  final RankingRemoteDataSource dataSource = RankingRemoteDataSource();

  RankingModel? rankingData;
  bool isLoading = true;
  String error = '';
  bool isNacional = true;

  String get cedulaActual => widget.cedula;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDark ? const Color(0xFF081B2E) : const Color.fromARGB(255, 220, 224, 228);

  Color get _cardColor =>
      _isDark ? const Color(0xFF0F2A44) : Colors.white;

  Color get _titleColor =>
      _isDark ? Colors.white : const Color(0xFF0F172A);

  Color get _subtitleColor =>
      _isDark ? Colors.white.withOpacity(0.68) : const Color(0xFF64748B);

  Color get _mutedColor =>
      _isDark ? Colors.white.withOpacity(0.48) : const Color(0xFF94A3B8);

  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.06);

  Color get _primaryBlue =>
      _isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7);

  Color get _successColor =>
      _isDark ? Colors.greenAccent : const Color(0xFF059669);

  @override
  void initState() {
    super.initState();
    cargarRanking();
  }

  Future<void> cargarRanking() async {
    try {
      final result = await dataSource.getRanking(cedulaActual);

      if (!mounted) return;

      setState(() {
        rankingData = result;
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
                      padding: const EdgeInsets.all(20),
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
                    onRefresh: cargarRanking,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 115),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Rankings",
                              style: TextStyle(
                                color: _titleColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _podio(),
                          const SizedBox(height: 20),
                          _tabs(),
                          const SizedBox(height: 20),
                          isNacional ? _listaRanking() : _listaEquipos(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _podio() {
    final top3 = (rankingData?.vendedores ?? []).take(3).toList();

    if (top3.isEmpty) {
      return _emptyBox("No hay datos para el podio.");
    }

    RankingVendedorModel? primero =
        top3.where((e) => e.posicion == 1).isNotEmpty
            ? top3.firstWhere((e) => e.posicion == 1)
            : null;

    RankingVendedorModel? segundo =
        top3.where((e) => e.posicion == 2).isNotEmpty
            ? top3.firstWhere((e) => e.posicion == 2)
            : null;

    RankingVendedorModel? tercero =
        top3.where((e) => e.posicion == 3).isNotEmpty
            ? top3.firstWhere((e) => e.posicion == 3)
            : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 22),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Podio Nacional",
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 16) / 3;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (segundo != null)
                    SizedBox(
                      width: itemWidth,
                      child: _podioItem(
                        segundo,
                        Colors.grey.shade300,
                        110,
                        62,
                      ),
                    ),
                  if (primero != null)
                    SizedBox(
                      width: itemWidth,
                      child: _podioItem(
                        primero,
                        Colors.yellow.shade600,
                        130,
                        72,
                      ),
                    ),
                  if (tercero != null)
                    SizedBox(
                      width: itemWidth,
                      child: _podioItem(
                        tercero,
                        Colors.orange.shade400,
                        90,
                        58,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _podioItem(
    RankingVendedorModel item,
    Color color,
    double boxHeight,
    double circleSize,
  ) {
    final iniciales = _iniciales(item.nombre);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: circleSize / 2,
          backgroundColor: color,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                iniciales,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _capitalizarNombre(item.nombre),
          style: TextStyle(
            color: _titleColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: boxHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(_isDark ? 0.55 : 0.75),
                color.withOpacity(_isDark ? 0.25 : 0.45),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.withOpacity(0.45),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${item.posicion}°",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${_formatearDecimal(item.porcentajeCumplimiento)}%",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "\$${_formatearDecimal(item.totalDolares)}",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: _cardDecoration(radius: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isNacional = true;
                });
              },
              child: _tab("Nacional", isNacional, Icons.group_outlined),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isNacional = false;
                });
              },
              child: _tab("Equipos", !isNacional, Icons.emoji_events_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String text, bool active, IconData icon) {
    final activeColor = _isDark ? Colors.lime : const Color(0xFF0284C7);
    final inactiveColor = _subtitleColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? (_isDark
                ? Colors.blue.withOpacity(0.30)
                : const Color(0xFFE0F2FE))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: active ? activeColor : inactiveColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: active ? activeColor : inactiveColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaRanking() {
    final vendedores = rankingData?.vendedores ?? [];

    return Column(
      children: vendedores
          .map(
            (item) => _itemVendedor(
              item,
              item.cedula == cedulaActual,
            ),
          )
          .toList(),
    );
  }

  Widget _itemVendedor(RankingVendedorModel item, bool isUser) {
    final bool up = item.posicion <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUser
            ? (_isDark
                ? Colors.blue.withOpacity(0.18)
                : const Color(0xFFE0F2FE))
            : _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUser
              ? (_isDark ? Colors.blueAccent : const Color(0xFF0284C7))
              : _borderColor,
        ),
        boxShadow: _shadow(),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                item.posicion <= 3 ? Colors.orange : _rankCircleColor(),
            child: Text(
              '${item.posicion}',
              style: TextStyle(
                color: item.posicion <= 3
                    ? Colors.black87
                    : (_isDark ? Colors.white : const Color(0xFF0F172A)),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                          color: _titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isUser)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _isDark
                              ? Colors.lightBlue
                              : const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Tú",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.totalVentas} ventas · ${_formatearDecimal(item.porcentajeCumplimiento)}%",
                  style: TextStyle(
                    color: _successColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "\$${_formatearDecimal(item.totalDolares)} / \$${_formatearDecimal(item.metaDolares)}",
                  style: TextStyle(
                    color: _subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            up ? Icons.trending_up : Icons.trending_down,
            color: up ? _successColor : Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _listaEquipos() {
    final tiendas = rankingData?.tiendas ?? [];
    final tiendaUsuario = rankingData?.tienda ?? '';

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(_isDark ? 0.12 : 0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.amber.withOpacity(_isDark ? 0.35 : 0.55),
            ),
            boxShadow: _shadow(),
          ),
          child: Row(
            children: [
              const Icon(Icons.emoji_events_outlined, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Competición nacional por cumplimiento de meta \$",
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...tiendas
            .map(
              (item) => _itemEquipo(
                item,
                item.nombreTienda == tiendaUsuario,
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _itemEquipo(RankingTiendaModel item, bool isUser) {
    final bool up = item.posicion <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUser
            ? (_isDark
                ? Colors.blue.withOpacity(0.18)
                : const Color(0xFFE0F2FE))
            : _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUser
              ? (_isDark ? Colors.blueAccent : const Color(0xFF0284C7))
              : _borderColor,
        ),
        boxShadow: _shadow(),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                item.posicion <= 3 ? Colors.orange : _rankCircleColor(),
            child: Text(
              '${item.posicion}',
              style: TextStyle(
                color: item.posicion <= 3
                    ? Colors.black87
                    : (_isDark ? Colors.white : const Color(0xFF0F172A)),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.nombreTienda,
                        style: TextStyle(
                          color: _titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isUser)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _isDark
                              ? Colors.lightBlue
                              : const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Tu Tienda",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.totalVendedores} vendedores · ${item.totalVentas} ventas",
                  style: TextStyle(
                    color: _mutedColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "${_formatearDecimal(item.porcentajeCumplimiento)}% de cumplimiento",
                  style: TextStyle(
                    color: _successColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "\$${_formatearDecimal(item.totalDolares)} / \$${_formatearDecimal(item.metaDolares)}",
                  style: TextStyle(
                    color: _subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            up ? Icons.trending_up : Icons.trending_down,
            color: up ? _successColor : Colors.redAccent,
          ),
        ],
      ),
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

  Color _rankCircleColor() {
    return _isDark ? const Color(0xFF334866) : const Color(0xFFE0F2FE);
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