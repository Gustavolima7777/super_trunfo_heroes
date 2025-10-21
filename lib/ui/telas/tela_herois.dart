import 'package:flutter/material.dart';
import '../../model/hero_model.dart';
import '../../service/api_service.dart';

class TelaHerois extends StatefulWidget {
  const TelaHerois({super.key});

  @override
  State<TelaHerois> createState() => _TelaHeroisState();
}

class _TelaHeroisState extends State<TelaHerois> {
  final ApiService api = ApiService();
  late Future<List<HeroModel>> futureHeroes;

  @override
  void initState() {
    super.initState();
    futureHeroes = api.fetchHeroes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heróis')),
      body: FutureBuilder<List<HeroModel>>(
        future: futureHeroes,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Erro: ${snap.error}'));
          } else if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text('Nenhum herói encontrado.'));
          }
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final h = list[i];
              return ListTile(
                title: Text(h.name),
                subtitle: Text('Força: ${h.powerstats['strength'] ?? '—'}'),
              );
            },
          );
        },
      ),
    );
  }
}
