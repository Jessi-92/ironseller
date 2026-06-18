import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/config/app_config.dart';
import '../models/rendimiento_model.dart';

class RendimientoRemoteDataSource {
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<RendimientoModel> getRendimiento(String cedula) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Rendimiento/$cedula'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return RendimientoModel.fromJson(data);
    } else {
      throw Exception(data['mensaje'] ?? 'Error al cargar rendimiento');
    }
  }
}