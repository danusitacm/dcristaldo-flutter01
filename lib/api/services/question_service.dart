import 'package:dcristaldo/data/question_repository.dart';
import 'package:dcristaldo/domain/question.dart';

class QuestionService {
  final QuestionRepository _repository = QuestionRepository();

  // Método para obtener las preguntas desde el repositorio
  List<Question> getQuestions() {
    return _repository.getQuestions();
  }
}
