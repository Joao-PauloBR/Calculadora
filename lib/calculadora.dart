import 'package:flutter/material.dart';
import 'package:calculadora/pages/tela.dart';

class Calculadora extends StatelessWidget {
  const Calculadora({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Tela(),
    );
  }
}

