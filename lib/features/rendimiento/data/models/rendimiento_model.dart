class DetalleVentaDiaModel {
  final String factura;
  final String marca;
  final String modelo;
  final double precioVenta;

  DetalleVentaDiaModel({
    required this.factura,
    required this.marca,
    required this.modelo,
    required this.precioVenta,
  });

  factory DetalleVentaDiaModel.fromJson(Map<String, dynamic> json) {
    return DetalleVentaDiaModel(
      factura: json['factura'] ?? '',
      marca: json['marca'] ?? 'No registrado',
      modelo: json['modelo'] ?? 'No registrado',
      precioVenta: double.tryParse('${json['precioVenta'] ?? 0}') ?? 0,
    );
  }
}

class VentaDiaModel {
  final String fecha;
  final int ventasRealizadas;
  final double totalDolares;
  final int puntosGanados;
  final List<DetalleVentaDiaModel> detalleVentas;

  VentaDiaModel({
    required this.fecha,
    required this.ventasRealizadas,
    required this.totalDolares,
    required this.puntosGanados,
    required this.detalleVentas,
  });

  factory VentaDiaModel.fromJson(Map<String, dynamic> json) {
    return VentaDiaModel(
      fecha: json['fecha'] ?? '',
      ventasRealizadas: json['ventasRealizadas'] ?? 0,
      totalDolares: double.tryParse('${json['totalDolares'] ?? 0}') ?? 0,
      puntosGanados: json['puntosGanados'] ?? 0,
      detalleVentas: (json['detalleVentas'] as List<dynamic>? ?? [])
          .map((item) => DetalleVentaDiaModel.fromJson(item))
          .toList(),
    );
  }
}

class RendimientoModel {
  final String nombre;
  final String cedula;
  final String tienda;
  final List<VentaDiaModel> ventasPorDia;

  RendimientoModel({
    required this.nombre,
    required this.cedula,
    required this.tienda,
    required this.ventasPorDia,
  });

  factory RendimientoModel.fromJson(Map<String, dynamic> json) {
    return RendimientoModel(
      nombre: json['nombre'] ?? '',
      cedula: json['cedula'] ?? '',
      tienda: json['tienda'] ?? '',
      ventasPorDia: (json['ventasPorDia'] as List<dynamic>? ?? [])
          .map((item) => VentaDiaModel.fromJson(item))
          .toList(),
    );
  }
}