class NotificacionClienteModel {
  final String idEvento;
  final String cedulaCliente;
  final String nombreCliente;
  final String? fotoUrl;

  final bool estaEnListaNegra;
  final int creditosVigentes;
  final String? estadoCredito;

  final int idLocal;
  final String nombreTienda;
  final String? camaraId;
  final DateTime? fechaDeteccion;

  final String mensaje;

  const NotificacionClienteModel({
    this.idEvento = '',
    this.cedulaCliente = '',
    required this.nombreCliente,
    this.fotoUrl,
    this.estaEnListaNegra = false,
    this.creditosVigentes = 0,
    this.estadoCredito,
    this.idLocal = 0,
    this.nombreTienda = '',
    this.camaraId,
    this.fechaDeteccion,
    required this.mensaje,
  });

  factory NotificacionClienteModel.fromSignalR(dynamic raw) {
    final data = _toMap(raw);
    final cliente = _toMap(data['cliente'] ?? data['Cliente']);
    final local = _toMap(data['local'] ?? data['Local']);

    return NotificacionClienteModel(
      idEvento: _toStringValue(data['idEvento'] ?? data['IdEvento']),
      cedulaCliente: _toStringValue(
        cliente['cedulaCliente'] ?? cliente['CedulaCliente'],
      ),
      nombreCliente: _toStringValue(
        cliente['nombreCliente'] ?? cliente['NombreCliente'],
        fallback: 'Cliente detectado',
      ),
      fotoUrl: _toNullableString(
        cliente['fotoUrl'] ?? cliente['FotoUrl'],
      ),
      estaEnListaNegra: _toBool(
        cliente['estaEnListaNegra'] ?? cliente['EstaEnListaNegra'],
      ),
      creditosVigentes: _toInt(
        cliente['creditosActivos'] ??
            cliente['CreditosActivos'] ??
            cliente['creditosVigentes'] ??
            cliente['CreditosVigentes'],
      ),
      estadoCredito: _toNullableString(
        cliente['estadoCredito'] ?? cliente['EstadoCredito'],
      ),
      idLocal: _toInt(
        local['idLocal'] ?? local['IdLocal'] ?? data['idLocal'] ?? data['IdLocal'],
      ),
      nombreTienda: _toStringValue(
        local['nombreTienda'] ??
            local['NombreTienda'] ??
            data['nombreTienda'] ??
            data['NombreTienda'],
      ),
      camaraId: _toNullableString(data['camaraId'] ?? data['CamaraId']),
      fechaDeteccion: _toDateTime(
        data['fechaDeteccion'] ?? data['FechaDeteccion'],
      ),
      mensaje: _toStringValue(
        data['mensaje'] ?? data['Mensaje'],
        fallback: 'Cliente detectado en tienda',
      ),
    );
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val),
      );
    }

    return {};
  }

  static String _toStringValue(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static String? _toNullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;

    final text = value.toString().toLowerCase().trim();

    return text == 'true' || text == '1' || text == 'si' || text == 'sí';
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}