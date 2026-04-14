import 'package:flutter/material.dart';
import '../../data/datasource/inicio_remote_datasource.dart';
import '../../data/models/inicio_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InicioRemoteDataSource dataSource = InicioRemoteDataSource();

  InicioModel? inicioData;
  bool isLoading = true;
  String error = '';

  // temporal mientras no exista login
  final String cedulaActual = '1745236984';

  @override
  void initState() {
    super.initState();
    cargarInicio();
  }

  Future<void> cargarInicio() async {
    try {
      final result = await dataSource.getInicio(cedulaActual);

      setState(() {
        inicioData = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
// el override del build es el método que se encarga de construir la interfaz de usuario de la página.
//aqui se muestra un indicador de carga mientras se obtienen los datos

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
                    onRefresh: cargarInicio,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _header(),
                          const SizedBox(height: 20),
                          _resumen(),
                          const SizedBox(height: 20),
                          _meta(),
                          const SizedBox(height: 20),
                          _cards(),
                          const SizedBox(height: 20),
                          _ranking(),
                          const SizedBox(height: 20),
                          _rankingTiendas(),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _header() {
    final nombre = inicioData?.nombre ?? '';

    return Container(
      //El padding es para que el contenido no quede tan pegado a los bordes del contenedor

      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2DA8FF), Color(0xFF1677FF)],
        ), 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Text(
              _iniciales(nombre),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 4),
                    Text(
                      "Vendedor",
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 100),
                    Text(
                      "Nivel 8",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bolt, color: Colors.amber),
            SizedBox(width: 6),
            Text(
              "Resumen del Día",
              style: TextStyle(
                color: Colors.white,
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
                "Ventas Totales",
                "${inicioData?.totalVentas ?? 0}",
                "ventas completadas", 
                Colors.greenAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _miniCard(
                "Puntos Totales",
                _formatearNumero(inicioData?.puntosTotales ?? 0),
                "pts acumulados",
                Colors.greenAccent,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _meta() {
    final porcentaje = (inicioData?.porcentajeMeta ?? 0).clamp(0, 100);
    final progreso = porcentaje / 100;
    final totalventas = inicioData?.totalVentas ?? 0;
    //final ventasHoy = inicioData?.ventasHoy ?? 0;
    final metaDiaria = inicioData?.metaDiaria ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes, color: Colors.redAccent, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  "Meta del Día",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "$porcentaje%",
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 6,
              backgroundColor: const Color.fromARGB(181, 37, 120, 210),
              color: const Color(0xFFC2D102),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "$totalventas de $metaDiaria ventas completadas",
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _cards() {
    return Row(
      children: [
        Expanded(
          child: _bigCard(
            "\$0.0K",
            "Comisiones",
            const LinearGradient(
              colors: [Color(0xFF063D77), Color(0xFF0A4E92)],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _bigCard(
            "0%",
            "Conversión",
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
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _ranking() {
    final top = inicioData?.topVendedores ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber),
            SizedBox(width: 6),
            Text(
              "Ranking de Vendedores",
              style: TextStyle(
                color: Colors.white,
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
  final topTiendas = inicioData?.topTiendas ?? [];
  final rankingTienda = inicioData?.rankingTienda ?? 0;
  final idTiendaUsuario = inicioData?.idTienda ?? '';

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0F2A44),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ranking de Tiendas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "Competición colectiva entre tiendas por región. Tu equipo está en ${rankingTienda}ª posición nacional.",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        ...topTiendas.map((tienda) {
          final esMiTienda = tienda.idTienda == idTiendaUsuario;

          return _itemTienda(tienda, esMiTienda);
        }).toList(),
      ],
    ),
  );
}

Widget _itemTienda(TopTiendaModel tienda, bool esMiTienda) {
  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: esMiTienda ? const EdgeInsets.all(14) : EdgeInsets.zero,
    decoration: BoxDecoration(
      color: esMiTienda ? Colors.blue.withOpacity(0.18) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      border: esMiTienda ? Border.all(color: Colors.blueAccent) : null,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 36,
          child: Text(
            "${tienda.posicion}°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                        color: Colors.lime,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (esMiTienda)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
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
                "${_formatearNumero(tienda.puntosTotales)} pts",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
    final esUsuario = item.cedula == cedulaActual;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(18),
        border: esUsuario ? Border.all(color: Colors.blueAccent) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE6D7FF),
            child: Text(
              "${item.posicion}",
              style: const TextStyle(
                color: Color(0xFF342A5F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _capitalizarNombre(item.nombre),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            "${_formatearNumero(item.puntosDisponibles)} pts",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
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