import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/config/app_config.dart';
import '../models/login_response_model.dart';

class LoginRemoteDataSource {
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<LoginResponseModel> login({
    required String cedula,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'cedula': cedula,
        'password': password,
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(data);
    } else {
      throw Exception(data['mensaje'] ?? 'Error al iniciar sesión');
    }
  }
}