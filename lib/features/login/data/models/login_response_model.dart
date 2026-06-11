class LoginResponseModel {
  final String mensaje;
  final String cedula;
  final String nombre;
  final String email;

  LoginResponseModel({
    required this.mensaje,
    required this.cedula,
    required this.nombre,
    required this.email,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      mensaje: json['mensaje'] ?? '',
      cedula: json['cedula'] ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
    );
  }
}