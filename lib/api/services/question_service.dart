import 'package:dcristaldo/data/question_repository.dart';
import 'package:dcristaldo/domain/question.dart';

class QuestionService {
  final QuestionRepository _repository = QuestionRepository();

  List<Question> fetchQuestions() {
    return _repository.getQuestions();
  }
}
