import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/rendimiento_model.dart';

class RendimientoRemoteDataSource {
  final String baseUrl = kIsWeb
      ? 'http://localhost:5062/api'
      : 'http://10.0.2.2:5062/api';

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