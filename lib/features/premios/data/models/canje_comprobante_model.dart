class CanjeComprobanteModel {
  final int idCanje;
  final String cedula;
  final String vendedor;
  final String idTienda;
  final String tienda;
  final String codigoBarras;
  final String premio;
  final DateTime? fecha;
  final int puntosUsados;
  final String codigoCanje;

  CanjeComprobanteModel({
    required this.idCanje,
    required this.cedula,
    required this.vendedor,
    required this.idTienda,
    required this.tienda,
    required this.codigoBarras,
    required this.premio,
    required this.fecha,
    required this.puntosUsados,
    required this.codigoCanje,
  });

  factory CanjeComprobanteModel.fromJson(Map<String, dynamic> json) {
    return CanjeComprobanteModel(
      idCanje: json['idCanje'] ?? 0,
      cedula: json['cedula'] ?? '',
      vendedor: json['vendedor'] ?? '',
      idTienda: json['idTienda'] ?? '',
      tienda: json['tienda'] ?? '',
      codigoBarras: json['codigoBarras'] ?? '',
      premio: json['premio'] ?? '',
      fecha: json['fecha'] != null ? DateTime.tryParse(json['fecha']) : null,
      puntosUsados: json['puntosUsados'] ?? 0,
      codigoCanje: json['codigoCanje'] ?? '',
    );
  }
}