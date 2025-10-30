import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../model/hero_model.dart';

class TelaMinhasCartas extends StatefulWidget {
  final List<HeroModel> cartasObtidas;
  const TelaMinhasCartas({super.key, required this.cartasObtidas});

  @override
  State<TelaMinhasCartas> createState() => _TelaMinhasCartasState();
}

class _TelaMinhasCartasState extends State<TelaMinhasCartas> {
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
    final cartas = widget.cartasObtidas;
    final total = cartas.length > 15 ? 15 : cartas.length;

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
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: total,
        itemBuilder: (context, i) {
          final carta = cartas[i];
          final poder = _overallPower(carta.powerstats);

          return GestureDetector(
            onTap: () async {
              final removed = await Navigator.pushNamed(
                context,
                '/detalhes_minha_carta',
                arguments: carta,
              );
              if (removed == true && mounted) {
                setState(() {
                  cartas.removeAt(i);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${carta.name} removido da coleção')),
                );
              }
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Expanded(
                    child: carta.imageUrl.isEmpty
                        ? const Icon(Icons.image_not_supported, size: 64)
                        : CachedNetworkImage(
                      imageUrl: carta.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) =>
                      const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          carta.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text('Poder: $poder',
                            style: const TextStyle(color: Colors.grey)),
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
