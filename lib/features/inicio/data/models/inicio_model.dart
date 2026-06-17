class TopVendedorModel {
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

  final int ventasHoy;

  TopVendedorModel({
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
    required this.ventasHoy,
  });

  factory TopVendedorModel.fromJson(Map<String, dynamic> json) {
    return TopVendedorModel(
      posicion: json['POSICION'] ?? 0,
      cedula: json['CEDULA'] ?? '',
      nombre: json['NOMBRE_VENDEDOR'] ?? '',
      nombreTienda: json['NOMBRE_TIENDA'] ?? '',
      puntosDisponibles: json['PUNTOS_DISPONIBLES'] ?? 0,
      totalVentas: json['TOTAL_VENTAS'] ?? 0,
      ventasHoy: json['VENTAS_HOY'] ?? 0,
      metaDolares: double.tryParse('${json['META_DOLARES'] ?? 0}') ?? 0,
      totalDolares: double.tryParse('${json['TOTAL_DOLARES'] ?? 0}') ?? 0,
      porcentajeCumplimiento:
          double.tryParse('${json['PORCENTAJE_CUMPLIMIENTO'] ?? 0}') ?? 0,
      fechaInicio: '${json['FECHA_INICIO'] ?? ''}',
      fechaFin: '${json['FECHA_FIN'] ?? ''}',
    );
  }
}

class TopTiendaModel {
  final int posicion;
  final String nombreTienda;

  final int totalVendedores;
  final int totalVentas;
  final int ventasHoy;
  final int puntosDisponibles;

  final double metaDolares;
  final double totalDolares;
  final double porcentajeCumplimiento;

  final String fechaInicio;
  final String fechaFin;


  TopTiendaModel({
    required this.posicion,
    required this.nombreTienda,
    required this.totalVendedores,
    required this.totalVentas,
    required this.ventasHoy,
    required this.puntosDisponibles,
    required this.metaDolares,
    required this.totalDolares,
    required this.porcentajeCumplimiento,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory TopTiendaModel.fromJson(Map<String, dynamic> json) {
    return TopTiendaModel(
      posicion: json['POSICION'] ?? 0,
      nombreTienda: json['NOMBRE_TIENDA'] ?? '',
      totalVendedores: json['TOTAL_VENDEDORES'] ?? 0,
      totalVentas: json['TOTAL_VENTAS'] ?? 0,
      ventasHoy: json['VENTAS_HOY'] ?? 0,
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

class InicioModel {
  final String nombre;
  final String cedula;
  final String tienda;

  final int puntosTotales;
  final int ranking;
  final int rankingTienda;

  final int totalVentas;

  final double totalDolares;
  final double metaDolares;
  final double totalDolaresMeta;
  final double porcentajeCumplimiento;

  final int ventasHoy;
  final int ventasMesActual;
  final int diasTranscurridos;

  final double totalDolaresMesActual;
  final double ticketPromedio;
  final double productividad;
  final double faltanteMeta;

  final String cargo;
  final int equiposEstimadosFaltantes;
  final String comentarioMeta;

  final int metaDiaria;
  final int porcentajeMeta;

  final List<TopVendedorModel> topVendedores;
  final List<TopTiendaModel> topTiendas;

  InicioModel({
    required this.nombre,
    required this.cedula,
    required this.tienda,
    required this.puntosTotales,
    required this.ranking,
    required this.rankingTienda,
    required this.totalVentas,
    required this.totalDolares,
    required this.metaDolares,
    required this.totalDolaresMeta,
    required this.porcentajeCumplimiento,
    required this.metaDiaria,
    required this.porcentajeMeta,
    required this.topVendedores,
    required this.topTiendas,
    required this.ventasHoy,
    required this.ventasMesActual,
    required this.diasTranscurridos,
    required this.totalDolaresMesActual,
    required this.ticketPromedio,
    required this.productividad,
    required this.cargo,
    required this.equiposEstimadosFaltantes,
    required this.comentarioMeta,
    required this.faltanteMeta,
  });

  factory InicioModel.fromJson(Map<String, dynamic> json) {
    return InicioModel(
      nombre: json['nombre'] ?? '',
      cedula: json['cedula'] ?? '',
      tienda: json['tienda'] ?? '',

      puntosTotales: json['puntosTotales'] ?? 0,
      ranking: json['ranking'] ?? 0,
      rankingTienda: json['rankingTienda'] ?? 0,

      totalVentas: json['totalVentas'] ?? 0,

      totalDolares: double.tryParse('${json['totalDolares'] ?? 0}') ?? 0,
      metaDolares: double.tryParse('${json['metaDolares'] ?? 0}') ?? 0,
      totalDolaresMeta:
          double.tryParse('${json['totalDolaresMeta'] ?? 0}') ?? 0,
      porcentajeCumplimiento:
          double.tryParse('${json['porcentajeCumplimiento'] ?? 0}') ?? 0,

      metaDiaria: json['metaDiaria'] ?? 0,
      porcentajeMeta: json['porcentajeMeta'] ?? 0,

      ventasHoy: json['ventasHoy'] ?? 0,
      ventasMesActual: json['ventasMesActual'] ?? 0,
      diasTranscurridos: json['diasTranscurridos'] ?? 0,

      cargo: json['cargo'] ?? 'Vendedor',
      equiposEstimadosFaltantes: json['equiposEstimadosFaltantes'] ?? 0,
      comentarioMeta: json['comentarioMeta'] ?? '',

      totalDolaresMesActual:
          double.tryParse('${json['totalDolaresMesActual'] ?? 0}') ?? 0,
      ticketPromedio: double.tryParse('${json['ticketPromedio'] ?? 0}') ?? 0,
      productividad: double.tryParse('${json['productividad'] ?? 0}') ?? 0,
      faltanteMeta: double.tryParse('${json['faltanteMeta'] ?? 0}') ?? 0,

      topVendedores: (json['topVendedores'] as List<dynamic>? ?? [])
          .map((item) => TopVendedorModel.fromJson(item))
          .toList(),

      topTiendas: (json['topTiendas'] as List<dynamic>? ?? [])
          .map((item) => TopTiendaModel.fromJson(item))
          .toList(),
    );
  }

}