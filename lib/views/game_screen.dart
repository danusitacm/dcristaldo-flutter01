import 'package:dcristaldo/constants.dart';
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
  int questionCounterText = 1;
  
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
        questionCounterText=currentQuestionIndex + 1;
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
    int totalQuestion = questionList.length;

    return Scaffold(
      appBar: AppBar(title: const Text(gameTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pregunta $questionCounterText de  $totalQuestion', style: const TextStyle(color: Colors.grey),),
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...question.answerOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _answerQuestion(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(option),
                  ),
                ],
              );
            }),
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
