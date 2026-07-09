import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../app/config/app_config.dart';
import '../models/perfil_model.dart';

class PerfilRemoteDataSource {
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<PerfilModel> getPerfil(String cedula) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Perfil/$cedula'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return PerfilModel.fromJson(data);
    }

    throw Exception(data['mensaje'] ?? 'Error al cargar perfil');
  }

  Future<String> guardarPerfil({
    required String cedula,
    required String descripcion,
    required String telefono,
    required String correo,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Perfil/guardar'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'cedula': cedula,
        'descripcion': descripcion,
        'telefono': telefono,
        'correo': correo,
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data['mensaje'] ?? 'Perfil guardado correctamente.';
    }

    throw Exception(data['mensaje'] ?? 'Error al guardar perfil');
  }

  Future<String> subirFoto({
    required String cedula,
    required XFile foto,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/Perfil/subir-foto'),
    );

    request.fields['Cedula'] = cedula;

    final bytes = await foto.readAsBytes();

    request.files.add(
      http.MultipartFile.fromBytes(
        'Foto',
        bytes,
        filename: foto.name,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data['fotoUrl'] ?? '';
    }

    throw Exception(data['mensaje'] ?? 'Error al subir foto');
  }
}