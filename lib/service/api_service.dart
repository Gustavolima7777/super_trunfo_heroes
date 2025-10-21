import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hero_model.dart';

class ApiService {
  static const String baseHost = 'http://10.0.2.2:3000';
  final String heroesUrl = '$baseHost/heroes';

  Future<List<HeroModel>> fetchHeroes() async {
    final uri = Uri.parse(heroesUrl);
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return data.map((e) => HeroModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ${resp.statusCode} ao buscar heróis');
    }
  }
}
