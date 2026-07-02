class DetalleVentaSemanaModel {
  final String fecha;
  final String factura;
  final String marca;
  final String modelo;
  final double precioVenta;

  DetalleVentaSemanaModel({
    required this.fecha,
    required this.factura,
    required this.marca,
    required this.modelo,
    required this.precioVenta,
  });

  factory DetalleVentaSemanaModel.fromJson(Map<String, dynamic> json) {
    return DetalleVentaSemanaModel(
      fecha: json['fecha'] ?? '',
      factura: json['factura'] ?? '',
      marca: json['marca'] ?? 'No registrado',
      modelo: json['modelo'] ?? 'No registrado',
      precioVenta: double.tryParse('${json['precioVenta'] ?? 0}') ?? 0,
    );
  }
}

class DiaSemanaModel {
  final String fecha;
  final int dia;
  final double vendidoDia;
  final int cantidadVentas;

  DiaSemanaModel({
    required this.fecha,
    required this.dia,
    required this.vendidoDia,
    required this.cantidadVentas,
  });

  factory DiaSemanaModel.fromJson(Map<String, dynamic> json) {
    return DiaSemanaModel(
      fecha: json['fecha'] ?? '',
      dia: json['dia'] ?? 0,
      vendidoDia: double.tryParse('${json['vendidoDia'] ?? 0}') ?? 0,
      cantidadVentas: json['cantidadVentas'] ?? 0,
    );
  }
}

class VentaSemanaModel {
  final int semana;
  final String fechaInicio;
  final String fechaFin;
  final int diasSemana;

  final double metaBaseSemanal;
  final double arrastreAnterior;
  final double metaAjustadaSemanal;
  final double vendidoSemanal;

  final int cantidadVentas;
  final int puntosGanados;

  final double diferencia;
  final double faltante;
  final double sobrante;
  final double porcentajeCumplimiento;

  final String estado;
  final bool esSemanaActual;

  final List<DiaSemanaModel> dias;
  final List<DetalleVentaSemanaModel> detalleVentas;

  VentaSemanaModel({
    required this.semana,
    required this.fechaInicio,
    required this.fechaFin,
    required this.diasSemana,
    required this.metaBaseSemanal,
    required this.arrastreAnterior,
    required this.metaAjustadaSemanal,
    required this.vendidoSemanal,
    required this.cantidadVentas,
    required this.puntosGanados,
    required this.diferencia,
    required this.faltante,
    required this.sobrante,
    required this.porcentajeCumplimiento,
    required this.estado,
    required this.esSemanaActual,
    required this.dias,
    required this.detalleVentas,
  });

  factory VentaSemanaModel.fromJson(Map<String, dynamic> json) {
    return VentaSemanaModel(
      semana: json['semana'] ?? 0,
      fechaInicio: json['fechaInicio'] ?? '',
      fechaFin: json['fechaFin'] ?? '',
      diasSemana: json['diasSemana'] ?? 0,
      metaBaseSemanal:
          double.tryParse('${json['metaBaseSemanal'] ?? 0}') ?? 0,
      arrastreAnterior:
          double.tryParse('${json['arrastreAnterior'] ?? 0}') ?? 0,
      metaAjustadaSemanal:
          double.tryParse('${json['metaAjustadaSemanal'] ?? 0}') ?? 0,
      vendidoSemanal:
          double.tryParse('${json['vendidoSemanal'] ?? 0}') ?? 0,
      cantidadVentas: json['cantidadVentas'] ?? 0,
      puntosGanados: json['puntosGanados'] ?? 0,
      diferencia: double.tryParse('${json['diferencia'] ?? 0}') ?? 0,
      faltante: double.tryParse('${json['faltante'] ?? 0}') ?? 0,
      sobrante: double.tryParse('${json['sobrante'] ?? 0}') ?? 0,
      porcentajeCumplimiento:
          double.tryParse('${json['porcentajeCumplimiento'] ?? 0}') ?? 0,
      estado: json['estado'] ?? '',
      esSemanaActual: json['esSemanaActual'] ?? false,
      dias: (json['dias'] as List<dynamic>? ?? [])
          .map((item) => DiaSemanaModel.fromJson(item))
          .toList(),
      detalleVentas: (json['detalleVentas'] as List<dynamic>? ?? [])
          .map((item) => DetalleVentaSemanaModel.fromJson(item))
          .toList(),
    );
  }
}

class RendimientoModel {
  final String nombre;
  final String cedula;
  final String tienda;

  final double metaDolares;
  final double vendidoTotalPeriodo;
  final int ventasTotalPeriodo;
  final double porcentajeGeneral;
  final double faltanteGeneral;

  final String fechaInicioMeta;
  final String fechaFinMeta;
  final int totalSemanas;
  final double metaBaseSemanal;

  final List<VentaSemanaModel> ventasPorSemana;

  RendimientoModel({
    required this.nombre,
    required this.cedula,
    required this.tienda,
    required this.metaDolares,
    required this.vendidoTotalPeriodo,
    required this.ventasTotalPeriodo,
    required this.porcentajeGeneral,
    required this.faltanteGeneral,
    required this.fechaInicioMeta,
    required this.fechaFinMeta,
    required this.totalSemanas,
    required this.metaBaseSemanal,
    required this.ventasPorSemana,
  });

  factory RendimientoModel.fromJson(Map<String, dynamic> json) {
    return RendimientoModel(
      nombre: json['nombre'] ?? '',
      cedula: json['cedula'] ?? '',
      tienda: json['tienda'] ?? '',
      metaDolares: double.tryParse('${json['metaDolares'] ?? 0}') ?? 0,
      vendidoTotalPeriodo:
          double.tryParse('${json['vendidoTotalPeriodo'] ?? 0}') ?? 0,
      ventasTotalPeriodo: json['ventasTotalPeriodo'] ?? 0,
      porcentajeGeneral:
          double.tryParse('${json['porcentajeGeneral'] ?? 0}') ?? 0,
      faltanteGeneral:
          double.tryParse('${json['faltanteGeneral'] ?? 0}') ?? 0,
      fechaInicioMeta: json['fechaInicioMeta'] ?? '',
      fechaFinMeta: json['fechaFinMeta'] ?? '',
      totalSemanas: json['totalSemanas'] ?? 0,
      metaBaseSemanal:
          double.tryParse('${json['metaBaseSemanal'] ?? 0}') ?? 0,
      ventasPorSemana: (json['ventasPorSemana'] as List<dynamic>? ?? [])
          .map((item) => VentaSemanaModel.fromJson(item))
          .toList(),
    );
  }
}