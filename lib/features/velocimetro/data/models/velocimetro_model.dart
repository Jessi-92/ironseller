class PremioVelocimetroModel {
  final String codigoBarras;
  final String descripcion;
  final int puntosRequeridos;
  final int puntosDisponibles;
  final int puntosFaltantes;

  PremioVelocimetroModel({
    required this.codigoBarras,
    required this.descripcion,
    required this.puntosRequeridos,
    required this.puntosDisponibles,
    required this.puntosFaltantes,
  });

  factory PremioVelocimetroModel.fromJson(Map<String, dynamic> json) {
    return PremioVelocimetroModel(
      codigoBarras: json['codigoBarras'] ?? '',
      descripcion: json['descripcion'] ?? '',
      puntosRequeridos: json['puntosRequeridos'] ?? 0,
      puntosDisponibles: json['puntosDisponibles'] ?? 0,
      puntosFaltantes: json['puntosFaltantes'] ?? 0,
    );
  }
}

class VelocimetroModel {
  final String nombre;
  final String cedula;
  final int puntosDisponibles;
  final int ranking;
  final PremioVelocimetroModel? premioDisponible;
  final PremioVelocimetroModel? proximoPremio;
  final PremioVelocimetroModel? premioPremium;

  VelocimetroModel({
    required this.nombre,
    required this.cedula,
    required this.puntosDisponibles,
    required this.ranking,
    required this.premioDisponible,
    required this.proximoPremio,
    required this.premioPremium,
  });

  factory VelocimetroModel.fromJson(Map<String, dynamic> json) {
    return VelocimetroModel(
      nombre: json['nombre'] ?? '',
      cedula: json['cedula'] ?? '',
      puntosDisponibles: json['puntosDisponibles'] ?? 0,
      ranking: json['ranking'] ?? 0,
      premioDisponible: json['premioDisponible'] != null
          ? PremioVelocimetroModel.fromJson(json['premioDisponible'])
          : null,
      proximoPremio: json['proximoPremio'] != null
          ? PremioVelocimetroModel.fromJson(json['proximoPremio'])
          : null,
      premioPremium: json['premioPremium'] != null
          ? PremioVelocimetroModel.fromJson(json['premioPremium'])
          : null,
    );
  }
}