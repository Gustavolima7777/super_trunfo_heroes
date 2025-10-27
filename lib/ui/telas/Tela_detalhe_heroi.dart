import 'package:flutter/material.dart';
import '../../model/hero_model.dart';

class TelaDetalheHeroi extends StatelessWidget {
  final HeroModel heroi;
  const TelaDetalheHeroi({super.key, required this.heroi});

  List<MapEntry<String, String>> _statsLegiveis() {
    if (heroi.powerstats.isEmpty) return [];
    return heroi.powerstats.entries.map((e) {
      final key = e.key[0].toUpperCase() + e.key.substring(1);
      final value = e.value?.toString() ?? 'N/A';
      return MapEntry(key, value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _statsLegiveis();

    return Scaffold(
      appBar: AppBar(
        title: Text(heroi.name),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: heroi.imageUrl.isEmpty
                  ? Container(
                height: 280,
                color: Colors.black12,
                child: const Icon(Icons.image, size: 72),
              )
                  : Image.network(
                heroi.imageUrl,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 280,
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 72),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            heroi.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Powerstats',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 8),
          if (stats.isEmpty)
            const Text('Sem estatísticas disponíveis.'),
          ...stats.map(
                (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: const TextStyle(fontSize: 16)),
                  Text(
                    e.value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
