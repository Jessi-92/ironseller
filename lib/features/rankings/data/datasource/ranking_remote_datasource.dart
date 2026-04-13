import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ranking_model.dart';
import 'package:flutter/foundation.dart';

class RankingRemoteDataSource {
  final String baseUrl = kIsWeb
    ? 'http://localhost:5062/api'
    : 'http://10.0.2.2:5062/api';

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