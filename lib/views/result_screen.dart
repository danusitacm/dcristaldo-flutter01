import 'package:dcristaldo/constants.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/views/start_screen.dart';
import 'package:dcristaldo/helpers/common_widgets_helper.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestion;

  const ResultScreen({
    super.key,
    required this.finalScore,
    required this.totalQuestion,
  });

  @override
  Widget build(BuildContext context) {
    String scoreText = '$Constants.finalScoreLabel $finalScore/$totalQuestion';
    String feedbackMessage =
        finalScore >= (totalQuestion / 2) ? 'Buen trabajo' : 'Sigue intentando';
    TextStyle scoreTextStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    Color buttonColor =
        finalScore >= (totalQuestion / 2) ? Colors.blue : Colors.green;
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(scoreText, style: scoreTextStyle),
            CommonWidgetsHelper.buildSpacing(20),
            Text(feedbackMessage, style: const TextStyle(color: Colors.grey)),
            CommonWidgetsHelper.buildSpacing(16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                  (route) => true,
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(buttonColor),
              ),
              child: const Text(Constants.playAgain),
            ),
          ],
        ),
      ),
    );
  }
}
