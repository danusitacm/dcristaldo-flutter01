import 'package:dcristaldo/domain/question.dart';

class QuestionRepository {
  final List<Question> _questions = [
    Question(
      questionText: '¿Cuál es la capital de Francia?',
      answerOptions: ['París', 'Londres', 'Madrid', 'Berlín'],
      correctAnswerIndex: 0, // Índice de la respuesta correcta
    ),
    Question(
      questionText: '¿Cuál es el planeta más grande del sistema solar?',
      answerOptions: ['Tierra', 'Marte', 'Júpiter', 'Saturno'],
      correctAnswerIndex: 2, // Índice de la respuesta correcta
    ),
    Question(
      questionText: '¿En qué año llegó el hombre a la luna?',
      answerOptions: ['1965', '1969', '1972', '1980'],
      correctAnswerIndex: 1, // Índice de la respuesta correcta
    ),
  ];

  List<Question> getQuestions() {
    return _questions;
  }
}
