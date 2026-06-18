import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/config/app_config.dart';
import '../models/ranking_model.dart';

class RankingRemoteDataSource {
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<RankingModel> getRanking(String cedula) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Ranking/$cedula'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return RankingModel.fromJson(data);
    } else {
      throw Exception('Error al cargar rankings: ${response.body}');
    }
  }
}