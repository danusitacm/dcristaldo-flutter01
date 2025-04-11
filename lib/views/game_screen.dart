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
  late List<Question> questionList; // Lista de preguntas
  int currentQuestionIndex = 0; // Índice de la pregunta actual
  int userScore = 0; // Puntuación del usuario
  bool? isCorrectAnswer; // Indica si la respuesta seleccionada es correcta

  @override
  void initState() {
    super.initState();
    questionList =
        _service.getQuestions(); // Obtiene las preguntas del servicio
  }

  void _answerQuestion(int selectedAnswerIndex) {
    setState(() {
      // Verifica si la respuesta seleccionada es correcta
      isCorrectAnswer =
          questionList[currentQuestionIndex].correctAnswerIndex ==
          selectedAnswerIndex;

      if (isCorrectAnswer!) {
        userScore++; // Incrementa la puntuación si es correcta
      }

      // Avanza a la siguiente pregunta o navega a la pantalla de resultados
      if (currentQuestionIndex < questionList.length - 1) {
        currentQuestionIndex++;
        isCorrectAnswer = null; // Reinicia el estado de la respuesta
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ResultScreen(score: userScore, total: questionList.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questionList[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Juego de Preguntas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...question.answerOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return ElevatedButton(
                onPressed: () => _answerQuestion(index),
                child: Text(option),
              );
            }).toList(),
            const SizedBox(height: 16),
            if (isCorrectAnswer != null)
              Text(
                isCorrectAnswer!
                    ? '¡Respuesta Correcta!'
                    : 'Respuesta Incorrecta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCorrectAnswer! ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
