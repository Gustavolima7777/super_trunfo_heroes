import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hero_model.dart';

class ApiService {
  static const String baseHost = 'http://10.0.2.2:3000';
  final String heroesUrl = '$baseHost/heroes';

  Future<List<HeroModel>> fetchHeroes() async {
    try {
      final uri = Uri.parse(heroesUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('Nenhum herói encontrado na resposta.');
        }
        return data.map((e) => HeroModel.fromJson(e)).toList();
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Falha ao carregar heróis: $e');
    }
  }
}
