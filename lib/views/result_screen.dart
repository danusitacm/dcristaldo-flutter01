import 'package:dcristaldo/constants.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/views/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestion;

  const ResultScreen({super.key, required this.finalScore, required this.totalQuestion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$finalScoreLabel $finalScore/$totalQuestion',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                );
              },
              child: const Text(playAgain),
            ),
          ],
        ),
      ),
    );
  }
}
