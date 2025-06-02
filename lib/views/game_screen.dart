import 'package:flutter/material.dart';
import 'package:dcristaldo/api/service/question_service.dart';
import 'package:dcristaldo/components/side_menu.dart';
import 'package:dcristaldo/domain/question.dart';
import 'package:dcristaldo/views/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  final QuestionService _questionService = QuestionService();
  List<Question> questionsList = [];
  int currentQuestionIndex = 0;
  int userScore = 0;
  int? selectedAnswerIndex;
  bool? isCorrectAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _questionService.getQuestions();
    setState(() {
      questionsList = questions;
    });
  }

  void _onAnswerSelected(int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      isCorrectAnswer = questionsList[currentQuestionIndex].isCorrect(
        selectedIndex,
      );

      if (isCorrectAnswer!) {
        userScore++;
      }
    });

    final snackBarMessage =
        isCorrectAnswer == true
            ? const SnackBar(
              content: Text('¡Correcto!'),
              backgroundColor: Colors.green,
            )
            : const SnackBar(
              content: Text('Incorrecto'),
              backgroundColor: Colors.red,
            );

    ScaffoldMessenger.of(context).showSnackBar(snackBarMessage);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (currentQuestionIndex < questionsList.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswerIndex = null;
          isCorrectAnswer = null;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultScreen(
                  finalScoreGame: userScore,
                  totalQuestions: questionsList.length,
                ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questionsList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final questionCounterText =
        'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
    final currentQuestion = questionsList[currentQuestionIndex];
    const double spacingHeight = 16;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Preguntas'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              const Text(
                '¡Bienvenido al Juego!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Puntaje: $userScore',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                questionCounterText,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                currentQuestion.questionText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: spacingHeight),
              ...currentQuestion.answerOptions.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;

                final buttonColor =
                    isCorrectAnswer == true
                        ? Colors.green
                        : (selectedAnswerIndex == index
                            ? Colors.red
                            : Colors.blue);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed:
                        selectedAnswerIndex == null
                            ? () => _onAnswerSelected(index)
                            : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(option, style: const TextStyle(fontSize: 16)),
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver al Inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
