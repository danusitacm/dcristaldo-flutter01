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
  int? selectedAnswerIndex;
  int questionCounterText = 1;
  Color correctAnswerColor= Colors.green;
  Color defaultButtonColor= Colors.blue;
  Color wrongAnswerColor= Colors.red;
  int totalQuestion=0;
  String snackBarMessage='Incorrecto';
  Color snackBarColor= Colors.red;
  
  @override
  void initState() {
    super.initState();
    questionList =
        _service.getQuestions(); // Obtiene las preguntas del servicio
  }

  void _answerQuestion(int selectedIndex) async {
  // Primer setState - para mostrar la respuesta seleccionada
  setState(() {
    selectedAnswerIndex = selectedIndex;
    isCorrectAnswer =
          questionList[currentQuestionIndex].correctAnswerIndex ==
          selectedAnswerIndex;

    if (isCorrectAnswer!) {
      userScore++;
      snackBarMessage='Correcto';
      snackBarColor=Colors.green;
    }else{
      snackBarMessage='Incorrecto';
      snackBarColor= Colors.red;
  
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackBarMessage),
          backgroundColor: snackBarColor,
          duration: const Duration(seconds: 1),
        ),
    );
  });

  // Espera 5 segundos
  await Future.delayed(const Duration(seconds: 2));

  // Verifica si el widget sigue montado antes de hacer cambios
  if (!mounted) return;

  // Segundo setState - para avanzar a la siguiente pregunta o resultados
  setState(() {
    if (currentQuestionIndex < questionList.length - 1) {
      currentQuestionIndex++;
      questionCounterText = currentQuestionIndex + 1;
      isCorrectAnswer = null;
      selectedAnswerIndex=null;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(finalScore: userScore, totalQuestion: totalQuestion),
        ),
      );
    }
  });
} 
  
  @override
  Widget build(BuildContext context) {
    final question = questionList[currentQuestionIndex];
    totalQuestion = questionList.length;

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
                    style: ButtonStyle( backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (selectedAnswerIndex == index) {
                              return isCorrectAnswer == true
                                  ? correctAnswerColor
                                  : wrongAnswerColor;
                            }
                            return defaultButtonColor;
                          },
                          
                        ),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: Text(option),
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
      

    );
  }
}
