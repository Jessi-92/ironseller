import 'package:flutter/material.dart';
import '../../data/datasource/ranking_remote_datasource.dart';
import '../../data/models/ranking_model.dart';

class RankingsPage extends StatefulWidget {
  const RankingsPage({super.key});

  @override
  State<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  final RankingRemoteDataSource dataSource = RankingRemoteDataSource();

  RankingModel? rankingData;
  bool isLoading = true;
  String error = '';
  bool isNacional = true;

  // temporal mientras no exista login  
  final String cedulaActual = '1700000012';

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
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: cargarRanking,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Rankings",
                              style: TextStyle(
                                color: Colors.white,
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
                          const SizedBox(height: 20),
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
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  "Podio Nacional",
                  style: TextStyle(
                    color: Colors.white,
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
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
              color.withOpacity(0.55),
              color.withOpacity(0.25),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
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
              "${_formatearNumero(item.puntosDisponibles)} pts",
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
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
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: active ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: active ? Colors.lime : Colors.white54,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: active ? Colors.lime : Colors.white54,
              fontWeight: FontWeight.w600,
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
          .map((item) => _itemVendedor(
                item,
                item.cedula == cedulaActual,
              ))
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
            ? Colors.blue.withOpacity(0.18)
            : const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(16),
        border: isUser ? Border.all(color: Colors.blueAccent) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: item.posicion <= 3
                ? Colors.orange
                : const Color(0xFF334866),
            child: Text(
              '${item.posicion}',
              style: const TextStyle(
                color: Colors.black87,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                          color: Colors.lightBlue,
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
                  "${item.posicion <= 0 ? 0 : item.posicion + 75} ventas • ${_formatearNumero(item.puntosDisponibles)} pts",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            up ? Icons.trending_up : Icons.trending_down,
            color: up ? Colors.greenAccent : Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _listaEquipos() {
    final tiendas = rankingData?.tiendas ?? [];

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.withOpacity(0.35)),
          ),
          child: const Row(
            children: [
              Icon(Icons.emoji_events_outlined, color: Colors.amber),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Competición nacional entre tiendas",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...tiendas
            .map((item) => _itemEquipo(
                  item,
                  item.idTienda == (rankingData?.idTienda ?? ''),
                ))
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
            ? Colors.blue.withOpacity(0.18)
            : const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(16),
        border: isUser ? Border.all(color: Colors.blueAccent) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: item.posicion <= 3
                ? Colors.orange
                : const Color(0xFF334866),
            child: Text(
              '${item.posicion}',
              style: const TextStyle(
                color: Colors.black87,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                          color: Colors.lightBlue,
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
                  "${item.totalVendedores} vendedores • ${_formatearNumero(item.puntosTotales)} pts totales",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            up ? Icons.trending_up : Icons.trending_down,
            color: up ? Colors.greenAccent : Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _emptyBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  String _iniciales(String nombre) {
    final partes =
        nombre.trim().split(' ').where((e) => e.isNotEmpty).toList();

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
}