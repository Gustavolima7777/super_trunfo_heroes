import 'package:flutter/material.dart';
import 'package:super_trunfo_heroes/ui/telas/tela_card_diario.dart';
import 'package:super_trunfo_heroes/ui/telas/tela_minhas_cartas.dart';
import '../../model/hero_model.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      minimumSize: const Size(220, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
    final List<HeroModel> cartasObtidas = [
      HeroModel(
        id: 1,
        name: 'Iron Man',
        powerstats: {
          'intelligence': 100,
          'strength': 85,
          'speed': 75,
          'durability': 85,
          'power': 95,
          'combat': 85,
        },
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/en/e/e0/Iron_Man_bleeding_edge.jpg',
      ),
      HeroModel(
        id: 2,
        name: 'Captain America',
        powerstats: {
          'intelligence': 70,
          'strength': 80,
          'speed': 65,
          'durability': 75,
          'power': 60,
          'combat': 100,
        },
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/en/9/91/CaptainAmerica109.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Trunfo Heroes'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => Navigator.pushNamed(context, '/herois'),
              child: const Text('Heróis'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CardDiarioScreen(),
                  ),
                );
              },
              child: const Text('Card Diário'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TelaMinhasCartas(cartasObtidas: cartasObtidas),
                  ),
                );
              },
              child: const Text('Minhas Cartas'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
              },
              child: const Text('Batalhar'),
            ),
          ],
        ),
      ),
    );
  }
}
