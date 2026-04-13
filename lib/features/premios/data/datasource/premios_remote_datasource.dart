import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/premio_model.dart';
import 'package:flutter/foundation.dart';

class PremiosRemoteDataSource {
  final String baseUrl = kIsWeb
    ? 'http://localhost:5062/api'
    : 'http://10.0.2.2:5062/api';

  Future<Map<String, List<PremioModel>>> getPremios(String cedula) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Premios/$cedula'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final disponibles = (data['disponibles'] as List)
          .map((item) => PremioModel.fromJson(item))
          .toList();

      final proximos = (data['proximos'] as List)
          .map((item) => PremioModel.fromJson(item))
          .toList();

      return {
        'disponibles': disponibles,
        'proximos': proximos,
      };
    } else {
      throw Exception('Error al cargar premios');
    }
  }

  Future<void> canjearPremio({
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

  if (response.statusCode != 200) {
    throw Exception('Error al canjear premio: ${response.body}');
  }
}
}