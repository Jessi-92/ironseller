import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/config/app_config.dart';
import '../models/canje_comprobante_model.dart';
import '../models/premio_model.dart';

class PremiosRemoteDataSource {
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<Map<String, dynamic>> getPremios(String cedula) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Premios/$cedula'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return {
        'disponibles': (data['disponibles'] as List<dynamic>? ?? [])
            .map((item) => PremioModel.fromJson(item))
            .toList(),
        'proximos': (data['proximos'] as List<dynamic>? ?? [])
            .map((item) => PremioModel.fromJson(item))
            .toList(),
        'historial': (data['historial'] as List<dynamic>? ?? [])
            .map((item) => HistorialPremioModel.fromJson(item))
            .toList(),
      };
    } else {
      throw Exception(data['mensaje'] ?? 'Error al cargar premios');
    }
  }

  Future<CanjeComprobanteModel> canjearPremio({
    required String cedula,
    required String codigoBarras,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Premios/canjear'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'cedula': cedula,
        'codigoBarras': codigoBarras,
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return CanjeComprobanteModel.fromJson(data['comprobante']);
    } else {
      throw Exception(data['mensaje'] ?? 'Error al canjear premio');
    }
  }
}