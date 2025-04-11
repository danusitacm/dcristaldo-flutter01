import 'package:dcristaldo/domain/question.dart';

class QuestionRepository {
  final List<Question> _questions = [
    Question(
      question: '¿Cuál es la capital de Francia?',
      options: ['París', 'Londres', 'Madrid', 'Berlín'],
      correctAnswer: 'París',
    ),
    Question(
      question: '¿Cuál es el planeta más grande del sistema solar?',
      options: ['Tierra', 'Marte', 'Júpiter', 'Saturno'],
      correctAnswer: 'Júpiter',
    ),
    Question(
      question: '¿En qué año llegó el hombre a la luna?',
      options: ['1965', '1969', '1972', '1980'],
      correctAnswer: '1969',
    ),
  ];

  List<Question> getQuestions() {
    return _questions;
  }
}
