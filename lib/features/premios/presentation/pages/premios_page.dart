import 'package:flutter/material.dart';
import '../../data/datasource/premios_remote_datasource.dart';
import '../../data/models/premio_model.dart';

class PremiosPage extends StatefulWidget {
  const PremiosPage({super.key});

  @override
  State<PremiosPage> createState() => _PremiosPageState();
}

class _PremiosPageState extends State<PremiosPage> {
  final PremiosRemoteDataSource dataSource = PremiosRemoteDataSource();

  List<PremioModel> disponibles = [];
  List<PremioModel> proximos = [];

  bool isLoading = true;
  String error = '';

  // ⚠️ por ahora está fija para probar
  // luego esto vendrá del login o sesión del usuario
  final String cedulaActual = '1745236984';

  @override
  void initState() {
    super.initState();
    cargarPremios();
  }

  Future<void> cargarPremios() async {
    try {
      final result = await dataSource.getPremios(cedulaActual);

      setState(() {
        disponibles = result['disponibles'] ?? [];
        proximos = result['proximos'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  int get puntosDisponiblesHeader {
    if (disponibles.isNotEmpty) {
      return disponibles.first.puntosDisponibles;
    }
    if (proximos.isNotEmpty) {
      return proximos.first.puntosDisponibles;
    }
    return 0;
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
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: cargarPremios,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _header(),
                          const SizedBox(height: 20),
                          _tabs(),
                          const SizedBox(height: 20),
                          _disponibles(),
                          const SizedBox(height: 20),
                          _proximos(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  // HEADER
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recompensas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Puntos Disponibles",
              style: TextStyle(color: Colors.white54),
            ),
            Text(
              puntosDisponiblesHeader.toString(),
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }

  // TABS SOLO VISUALES
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
          _tab("Catálogo", true, Icons.card_giftcard_outlined),
          _tab("Insignias", false, Icons.star_border),
          _tab("Historial", false, Icons.calendar_today_outlined),
        ],
      ),
    );
  }

  Widget _tab(String text, bool active, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.lime : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? Colors.black : Colors.white54,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: active ? Colors.black : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DISPONIBLES
  Widget _disponibles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent),
            SizedBox(width: 6),
            Text(
              "Disponibles para Canjear",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (disponibles.isEmpty)
          _emptyCard("No hay premios disponibles por ahora.")
        else
          ...disponibles.map((premio) => _itemDisponible(premio)),
      ],
    );
  }

  Widget _itemDisponible(PremioModel premio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(
              _getPremioIcon(premio.descripcion),
              color: Colors.white70,
              size: 38,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  premio.descripcion,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${premio.puntosRequeridos} pts",
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Electrónica",
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF19C58E),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            //Aqui va la funcion de canjear premio que se conecta con el datasource 
            // y luego recarga la lista de premios para actualizar los puntos disponibles  
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF0F2A44),
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
                await dataSource.canjearPremio(
                  cedula: cedulaActual,
                  codigoBarras: premio.codigoBarras,
                );

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${premio.descripcion} canjeado correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );

                setState(() {
                  isLoading = true;
                });

                await cargarPremios();
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al canjear: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },

            child: const Text(
              "Canjear",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // PROXIMOS
  Widget _proximos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.white54),
            SizedBox(width: 6),
            Text(
              "Próximas Recompensas",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (proximos.isEmpty)
          _emptyCard("No hay próximos premios.")
        else
          ...proximos.map((premio) => _itemBloqueado(premio)),
      ],
    );
  }

  Widget _itemBloqueado(PremioModel premio) {
    final int disponiblesActuales = premio.puntosDisponibles;
    final int requeridos = premio.puntosRequeridos;

    double progress = 0;
    if (requeridos > 0) {
      progress = disponiblesActuales / requeridos;
      if (progress > 1) progress = 1;
      if (progress < 0) progress = 0;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: Icon(
                  _getPremioIcon(premio.descripcion),
                  color: Colors.white60,
                  size: 38,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      premio.descripcion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "Electrónica",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${premio.puntosRequeridos} pts",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.lock_outline, size: 14, color: Colors.white38),
                      SizedBox(width: 4),
                      Text(
                        "Bloqueado",
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white12,
              color: Colors.lime,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Te faltan ",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  TextSpan(
                    text: "${premio.puntosFaltantes ?? 0}",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: " pts",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70),
      ),
    );
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