import 'package:flutter/material.dart';
import 'package:dcristaldo/api/services/question_service.dart';
import 'package:dcristaldo/domain/question.dart';
import 'package:dcristaldo/views/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  final QuestionService _service = QuestionService();
  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _questions = _service.fetchQuestions();
  }

  void _answerQuestion(String selectedAnswer) {
    if (_questions[_currentQuestionIndex].correctAnswer == selectedAnswer) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  ResultScreen(score: _score, total: _questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Juego de Preguntas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...question.options.map((option) {
              return ElevatedButton(
                onPressed: () => _answerQuestion(option),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
