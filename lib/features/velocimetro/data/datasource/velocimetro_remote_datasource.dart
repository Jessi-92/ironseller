import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/config/app_config.dart';
import '../models/velocimetro_model.dart';
import '../../../premios/data/models/canje_comprobante_model.dart';

class VelocimetroRemoteDataSource {
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<VelocimetroModel> getVelocimetro(String cedula) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Velocimetro/$cedula'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return VelocimetroModel.fromJson(data);
    } else {
      throw Exception('Error al cargar velocímetro: ${response.body}');
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

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['comprobante'] == null) {
        throw Exception('No se recibió comprobante del backend');
      }

      return CanjeComprobanteModel.fromJson(data['comprobante']);
    } else {
      throw Exception('Error al canjear premio: ${response.body}');
    }
  }
}