import 'package:dcristaldo/constants.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/views/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestion;

  const ResultScreen({super.key, required this.finalScore, required this.totalQuestion});

  @override
  Widget build(BuildContext context) {
    String scoreText = '$finalScoreLabel $finalScore/$totalQuestion';
    String feedbackMessage = finalScore >= (totalQuestion/2) ? 'Buen trabajo' : 'Sigue intentando';
    TextStyle scoreTextStyle = const TextStyle(fontSize: 24,fontWeight:  FontWeight.bold);
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scoreText,
              style: scoreTextStyle,
            ),
            Text(feedbackMessage, style: const TextStyle(color: Colors.grey),),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                  (route) => true,
                );
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.green)),
              child: const Text(playAgain),
            ),
            
          ],
        ),
      ),
    );
  }
}
