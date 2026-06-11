class RankingVendedorModel {
  final int posicion;
  final String cedula;
  final String nombre;
  final String nombreTienda;

  final int puntosDisponibles;
  final int totalVentas;

  final double metaDolares;
  final double totalDolares;
  final double porcentajeCumplimiento;

  final String fechaInicio;
  final String fechaFin;

  RankingVendedorModel({
    required this.posicion,
    required this.cedula,
    required this.nombre,
    required this.nombreTienda,
    required this.puntosDisponibles,
    required this.totalVentas,
    required this.metaDolares,
    required this.totalDolares,
    required this.porcentajeCumplimiento,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory RankingVendedorModel.fromJson(Map<String, dynamic> json) {
    return RankingVendedorModel(
      posicion: json['POSICION'] ?? 0,
      cedula: json['CEDULA'] ?? '',
      nombre: json['NOMBRE_VENDEDOR'] ?? '',
      nombreTienda: json['NOMBRE_TIENDA'] ?? '',
      puntosDisponibles: json['PUNTOS_DISPONIBLES'] ?? 0,
      totalVentas: json['TOTAL_VENTAS'] ?? 0,
      metaDolares: double.tryParse('${json['META_DOLARES'] ?? 0}') ?? 0,
      totalDolares: double.tryParse('${json['TOTAL_DOLARES'] ?? 0}') ?? 0,
      porcentajeCumplimiento:
          double.tryParse('${json['PORCENTAJE_CUMPLIMIENTO'] ?? 0}') ?? 0,
      fechaInicio: '${json['FECHA_INICIO'] ?? ''}',
      fechaFin: '${json['FECHA_FIN'] ?? ''}',
    );
  }
}

class RankingTiendaModel {
  final int posicion;
  final String nombreTienda;

  final int totalVendedores;
  final int totalVentas;
  final int puntosDisponibles;

  final double metaDolares;
  final double totalDolares;
  final double porcentajeCumplimiento;

  final String fechaInicio;
  final String fechaFin;

  RankingTiendaModel({
    required this.posicion,
    required this.nombreTienda,
    required this.totalVendedores,
    required this.totalVentas,
    required this.puntosDisponibles,
    required this.metaDolares,
    required this.totalDolares,
    required this.porcentajeCumplimiento,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory RankingTiendaModel.fromJson(Map<String, dynamic> json) {
    return RankingTiendaModel(
      posicion: json['POSICION'] ?? 0,
      nombreTienda: json['NOMBRE_TIENDA'] ?? '',
      totalVendedores: json['TOTAL_VENDEDORES'] ?? 0,
      totalVentas: json['TOTAL_VENTAS'] ?? 0,
      puntosDisponibles: json['PUNTOS_DISPONIBLES'] ?? 0,
      metaDolares: double.tryParse('${json['META_DOLARES'] ?? 0}') ?? 0,
      totalDolares: double.tryParse('${json['TOTAL_DOLARES'] ?? 0}') ?? 0,
      porcentajeCumplimiento:
          double.tryParse('${json['PORCENTAJE_CUMPLIMIENTO'] ?? 0}') ?? 0,
      fechaInicio: '${json['FECHA_INICIO'] ?? ''}',
      fechaFin: '${json['FECHA_FIN'] ?? ''}',
    );
  }
}

class RankingModel {
  final String cedula;
  final String nombre;
  final String tienda;
  final int puntosDisponibles;
  final int rankingUsuario;
  final int rankingTiendaUsuario;
  final List<RankingVendedorModel> vendedores;
  final List<RankingTiendaModel> tiendas;

  RankingModel({
    required this.cedula,
    required this.nombre,
    required this.tienda,
    required this.puntosDisponibles,
    required this.rankingUsuario,
    required this.rankingTiendaUsuario,
    required this.vendedores,
    required this.tiendas,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      cedula: json['cedula'] ?? '',
      nombre: json['nombre'] ?? '',
      tienda: json['tienda'] ?? '',
      puntosDisponibles: json['puntosDisponibles'] ?? 0,
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