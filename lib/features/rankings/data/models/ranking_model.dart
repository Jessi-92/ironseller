class RankingVendedorModel {
  final int posicion;
  final String cedula;
  final String nombre;
  final String idTienda;
  final int puntosDisponibles;

  RankingVendedorModel({
    required this.posicion,
    required this.cedula,
    required this.nombre,
    required this.idTienda,
    required this.puntosDisponibles,
  });

  factory RankingVendedorModel.fromJson(Map<String, dynamic> json) {
    return RankingVendedorModel(
      posicion: json['POSICION'] ?? 0,
      cedula: json['CEDULA'] ?? '',
      nombre: json['NOMBRE'] ?? '',
      idTienda: json['ID_TIENDA'] ?? '',
      puntosDisponibles: json['PUNTOS_DISPONIBLES'] ?? 0,
    );
  }
}

class RankingTiendaModel {
  final int posicion;
  final String idTienda;
  final String nombreTienda;
  final int totalVendedores;
  final int puntosTotales;

  RankingTiendaModel({
    required this.posicion,
    required this.idTienda,
    required this.nombreTienda,
    required this.totalVendedores,
    required this.puntosTotales,
  });

  factory RankingTiendaModel.fromJson(Map<String, dynamic> json) {
    return RankingTiendaModel(
      posicion: json['POSICION'] ?? 0,
      idTienda: json['ID_TIENDA'] ?? '',
      nombreTienda: json['NOMBRE_TIENDA'] ?? '',
      totalVendedores: json['TOTAL_VENDEDORES'] ?? 0,
      puntosTotales: json['PUNTOS_TOTALES'] ?? 0,
    );
  }
}

class RankingModel {
  final String cedula;
  final String nombre;
  final String idTienda;
  final int rankingUsuario;
  final int rankingTiendaUsuario;
  final List<RankingVendedorModel> vendedores;
  final List<RankingTiendaModel> tiendas;

  RankingModel({
    required this.cedula,
    required this.nombre,
    required this.idTienda,
    required this.rankingUsuario,
    required this.rankingTiendaUsuario,
    required this.vendedores,
    required this.tiendas,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      cedula: json['cedula'] ?? '',
      nombre: json['nombre'] ?? '',
      idTienda: json['idTienda'] ?? '',
      rankingUsuario: json['rankingUsuario'] ?? 0,
      rankingTiendaUsuario: json['rankingTiendaUsuario'] ?? 0,
      vendedores: (json['vendedores'] as List<dynamic>? ?? [])
          .map((item) => RankingVendedorModel.fromJson(item))
          .toList(),
      tiendas: (json['tiendas'] as List<dynamic>? ?? [])
          .map((item) => RankingTiendaModel.fromJson(item))
          .toList(),
    );
  }
}