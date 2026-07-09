class PerfilModel {
  final String cedula;
  final String nombre;
  final String tienda;
  final String fotoUrl;
  final String descripcion;
  final String telefono;
  final String correo;

  PerfilModel({
    required this.cedula,
    required this.nombre,
    required this.tienda,
    required this.fotoUrl,
    required this.descripcion,
    required this.telefono,
    required this.correo,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    return PerfilModel(
      cedula: json['cedula'] ?? '',
      nombre: json['nombre'] ?? '',
      tienda: json['tienda'] ?? '',
      fotoUrl: json['fotoUrl'] ?? '',
      descripcion: json['descripcion'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
    );
  }
}