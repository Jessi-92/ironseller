import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inicio_model.dart';

class InicioRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:5062/api';

  Future<InicioModel> getInicio(String cedula) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Inicio/$cedula'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return InicioModel.fromJson(data);
    } else {
      throw Exception('Error al cargar inicio: ${response.body}');
    }
  }
}