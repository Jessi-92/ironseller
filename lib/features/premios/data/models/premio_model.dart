class PremioModel {
  final String cedula;
  final String nombre;
  final String tienda;
  final String codigoBarras;
  final String descripcion;
  final int puntosRequeridos;
  final int puntosDisponibles;
  final int? puntosFaltantes;
  

  PremioModel({
    required this.cedula,
    required this.nombre,
    required this.tienda,
    required this.codigoBarras,
    required this.descripcion,
    required this.puntosRequeridos,
    required this.puntosDisponibles,
    this.puntosFaltantes,
  });

  factory PremioModel.fromJson(Map<String, dynamic> json) {
    return PremioModel(
      cedula: json['CEDULA'] ?? '',
      nombre: json['NOMBRE_VENDEDOR'] ?? '',
      tienda: json['NOMBRE_TIENDA'] ?? '',
      codigoBarras: json['CODIGOBARRAS'] ?? '',
      descripcion: json['DESCRIPCION'] ?? '',
      puntosRequeridos: json['PUNTOS_REQUERIDOS'] ?? 0,
      puntosDisponibles: json['PUNTOS_DISPONIBLES'] ?? 0,
      puntosFaltantes: json['PUNTOS_FALTANTES'],
      
    );
  }
}

class HistorialPremioModel {
  final int idCanjeo;
  final String cedula;
  final String nombre;
  final String tienda;
  final String codigoBarras;
  final String descripcion;
  final int puntosUsados;
  final String codigoCanje;
  final DateTime? fechaCanjeo;

  HistorialPremioModel({
    required this.idCanjeo,
    required this.cedula,
    required this.nombre,
    required this.tienda,
    required this.codigoBarras,
    required this.descripcion,
    required this.puntosUsados,
    required this.codigoCanje,
    required this.fechaCanjeo,
  });

  factory HistorialPremioModel.fromJson(Map<String, dynamic> json) {
    return HistorialPremioModel(
      idCanjeo: json['ID_CANJEO'] ?? 0,
      cedula: json['CEDULA'] ?? '',
      nombre: json['NOMBRE_VENDEDOR'] ?? '',
      tienda: json['NOMBRE_TIENDA'] ?? '',
      codigoBarras: json['CODIGOBARRAS'] ?? '',
      descripcion: json['DESCRIPCION'] ?? '',
      puntosUsados: json['PUNTOS_USADOS'] ?? 0,
      codigoCanje: json['CODIGO_CANJEO'] ?? '',
      fechaCanjeo: json['FECHA_CANJEO'] != null
          ? DateTime.tryParse(json['FECHA_CANJEO'])
          : null,
    );
  }
}