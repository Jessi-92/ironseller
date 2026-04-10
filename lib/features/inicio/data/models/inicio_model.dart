class TopVendedorModel {
  final int posicion;
  final String cedula;
  final String nombre;
  final int puntosDisponibles;

  TopVendedorModel({
    required this.posicion,
    required this.cedula,
    required this.nombre,
    required this.puntosDisponibles,
  });

  factory TopVendedorModel.fromJson(Map<String, dynamic> json) {
    return TopVendedorModel(
      posicion: json['POSICION'] ?? 0,
      cedula: json['CEDULA'] ?? '',
      nombre: json['NOMBRE'] ?? '',
      puntosDisponibles: json['PUNTOS_DISPONIBLES'] ?? 0,
    );
  }
}

class TopTiendaModel {
  final int posicion;
  final String idTienda;
  final String nombreTienda;
  final int totalVendedores;
  final int puntosTotales;

  TopTiendaModel({
    required this.posicion,
    required this.idTienda,
    required this.nombreTienda,
    required this.totalVendedores,
    required this.puntosTotales,
  });

  factory TopTiendaModel.fromJson(Map<String, dynamic> json) {
    return TopTiendaModel(
      posicion: json['POSICION'] ?? 0,
      idTienda: json['ID_TIENDA'] ?? '',
      nombreTienda: json['NOMBRE_TIENDA'] ?? '',
      totalVendedores: json['TOTAL_VENDEDORES'] ?? 0,
      puntosTotales: json['PUNTOS_TOTALES'] ?? 0,
    );
  }
}

class InicioModel {
  final String nombre;
  final String cedula;
  final String idTienda;
  final int puntosTotales;
  final int ranking;
  final int rankingTienda;
  final int ventasHoy;
  final int metaDiaria;
  final int porcentajeMeta;
  final int totalVentas;
  final List<TopVendedorModel> topVendedores;
  final List<TopTiendaModel> topTiendas;

  InicioModel({
    required this.nombre,
    required this.cedula,
    required this.idTienda,
    required this.puntosTotales,
    required this.ranking,
    required this.rankingTienda,
    required this.ventasHoy,
    required this.metaDiaria,
    required this.porcentajeMeta,
    required this.totalVentas,
    required this.topVendedores,
    required this.topTiendas,
  });

  factory InicioModel.fromJson(Map<String, dynamic> json) {
    return InicioModel(
      nombre: json['nombre'] ?? '',
      cedula: json['cedula'] ?? '',
      idTienda: json['idTienda'] ?? '',
      puntosTotales: json['puntosTotales'] ?? 0,
      ranking: json['ranking'] ?? 0,
      rankingTienda: json['rankingTienda'] ?? 0,
      ventasHoy: json['ventasHoy'] ?? 0,
      metaDiaria: json['metaDiaria'] ?? 0,
      porcentajeMeta: json['porcentajeMeta'] ?? 0,
      totalVentas: json['totalVentas'] ?? 0,
      topVendedores: (json['topVendedores'] as List<dynamic>? ?? [])
          .map((item) => TopVendedorModel.fromJson(item))
          .toList(),
      topTiendas: (json['topTiendas'] as List<dynamic>? ?? [])
          .map((item) => TopTiendaModel.fromJson(item))
          .toList(),
    );
  }
}