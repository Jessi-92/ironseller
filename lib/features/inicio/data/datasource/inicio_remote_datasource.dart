import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/config/app_config.dart';
import '../models/inicio_model.dart';

class InicioRemoteDataSource {
  final String baseUrl = AppConfig.apiBaseUrl;

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