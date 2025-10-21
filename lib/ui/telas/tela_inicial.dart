import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Trunfo Heroes'),
        backgroundColor: Colors.blue,
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
              onPressed: () {},
              child: const Text('Card Diário'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {},
              child: const Text('Minhas Cartas'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {},
              child: const Text('Batalhar'),
            ),
          ],
        ),
      ),
    );
  }
}
