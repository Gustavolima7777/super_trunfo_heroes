// lib/service/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/hero_model.dart';

class LocalStorageService {
  static const _keyCartas = 'minhas_cartas';

  Future<List<HeroModel>> listarCartas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyCartas) ?? [];
    return raw.map((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return HeroModel(
        id: map['id'] ?? 0,
        name: map['name'] ?? '',
        powerstats:
        Map<String, dynamic>.from(map['powerstats'] ?? <String, dynamic>{}),
        imageUrl: map['imageUrl'] ?? '',
      );
    }).toList();
  }

  Future<void> salvarCartas(List<HeroModel> cartas) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = cartas.map((h) => jsonEncode({
      'id': h.id,
      'name': h.name,
      'powerstats': h.powerstats,
      'imageUrl': h.imageUrl,
    })).toList();
    await prefs.setStringList(_keyCartas, raw);
  }

  Future<void> adicionarCarta(HeroModel heroi) async {
    final cartas = await listarCartas();
    if (!cartas.any((c) => c.id == heroi.id)) {
      cartas.add(heroi);
      await salvarCartas(cartas);
    }
  }

  Future<void> removerCarta(int id) async {
    final cartas = await listarCartas();
    cartas.removeWhere((c) => c.id == id);
    await salvarCartas(cartas);
  }
}
