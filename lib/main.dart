import 'package:flutter/material.dart';
import 'model/hero_model.dart';
import 'package:flutter/material.dart';
import 'model/hero_model.dart';
import 'service/api_service.dart';
import 'ui/telas/tela_inicial.dart';
import 'ui/telas/tela_herois.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Trunfo Heroes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaInicial(),
      routes: {
        '/herois': (context) => const TelaHerois(),
      },
    );
  }
}
