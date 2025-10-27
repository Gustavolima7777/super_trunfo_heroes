import 'package:flutter/material.dart';
import '../../model/hero_model.dart';
import 'tela_detalhe_heroi.dart';

class TelaMinhasCartas extends StatelessWidget {
  final List<HeroModel> cartasObtidas;
  const TelaMinhasCartas({super.key, required this.cartasObtidas});

  int _overallPower(Map<String, dynamic> ps) {
    final vals = <int>[];
    for (final v in ps.values) {
      final n = int.tryParse(v.toString());
      if (n != null) vals.add(n);
    }
    if (vals.isEmpty) return 0;
    return (vals.reduce((a, b) => a + b) / vals.length).round();
  }

  @override
  Widget build(BuildContext context) {
    final total = cartasObtidas.length > 15 ? 15 : cartasObtidas.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Cartas'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: total == 0
          ? const Center(child: Text('Nenhuma carta obtida ainda!'))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.72,
        ),
        itemCount: total,
        itemBuilder: (context, i) {
          final carta = cartasObtidas[i];
          final poder = _overallPower(carta.powerstats);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TelaDetalheHeroi(heroi: carta)),
              );
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Expanded(
                    child: carta.imageUrl.isEmpty
                        ? const Icon(Icons.image_not_supported, size: 64)
                        : Image.network(carta.imageUrl, fit: BoxFit.cover, width: double.infinity),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(carta.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text('Poder: $poder', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
