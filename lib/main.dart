import 'package:flutter/material.dart';
import 'model/hero_model.dart';
import 'service/api_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Trunfo Heroes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HeroListPage(),
    );
  }
}

class HeroListPage extends StatefulWidget {
  const HeroListPage({super.key});
  @override
  State<HeroListPage> createState() => _HeroListPageState();
}

class _HeroListPageState extends State<HeroListPage> {
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
            return const Center(child: Text('Nenhum herói'));
          }
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (c, i) {
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
