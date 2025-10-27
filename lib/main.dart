import 'package:flutter/material.dart';
import 'package:super_trunfo_heroes/ui/telas/tela_inicial.dart';
import 'package:super_trunfo_heroes/ui/telas/tela_herois.dart';
import 'package:super_trunfo_heroes/ui/telas/tela_minhas_cartas.dart';
import 'package:super_trunfo_heroes/model/hero_model.dart';

void main() {
  runApp(const SuperTrunfoApp());
}

class SuperTrunfoApp extends StatelessWidget {
  const SuperTrunfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Trunfo Heroes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TelaInicial(),
      routes: {
        '/herois': (context) => const TelaHerois(),
        // rota opcional pra testes
        '/minhas_cartas': (context) => TelaMinhasCartas(cartasObtidas: [
          HeroModel(
            id: 1,
            name: 'Iron Man',
            powerstats: {
              'intelligence': 100, 'strength': 85, 'speed': 75, 'durability': 85, 'power': 95, 'combat': 85,
            },
            imageUrl: 'https://upload.wikimedia.org/wikipedia/en/e/e0/Iron_Man_bleeding_edge.jpg',
          ),
        ]),
      },
    );
  }
}
