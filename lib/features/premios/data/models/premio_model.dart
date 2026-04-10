class PremioModel {
  final String cedula;
  final String nombre;
  final String codigoBarras;
  final String descripcion;
  final int puntosRequeridos;
  final int puntosDisponibles;
  final int? puntosFaltantes;

  PremioModel({
    required this.cedula,
    required this.nombre,
    required this.codigoBarras,
    required this.descripcion,
    required this.puntosRequeridos,
    required this.puntosDisponibles,
    this.puntosFaltantes,
  });

  factory PremioModel.fromJson(Map<String, dynamic> json) {
    return PremioModel(
      cedula: json['CEDULA'] ?? '',
      nombre: json['NOMBRE'] ?? '',
      codigoBarras: json['CODIGOBARRAS'] ?? '',
      descripcion: json['DESCRIPCION'] ?? '',
      puntosRequeridos: json['PUNTOS_REQUERIDOS'] ?? 0,
      puntosDisponibles: json['PUNTOS_DISPONIBLES'] ?? 0,
      puntosFaltantes: json['PUNTOS_FALTANTES'],
    );
  }
}