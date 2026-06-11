import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/login_response_model.dart';

class LoginRemoteDataSource {
  final String baseUrl = kIsWeb
      ? 'http://localhost:5062/api'
      : 'http://10.0.2.2:5062/api';

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