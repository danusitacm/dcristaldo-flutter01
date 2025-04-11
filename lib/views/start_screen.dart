import 'package:flutter/material.dart';
import 'package:dcristaldo/views/game_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Juego de Preguntas')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GameScreen()),
            );
          },
          child: const Text('Comenzar Juego'),
        ),
      ),
    );
  }
}
