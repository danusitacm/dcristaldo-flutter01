import 'package:dcristaldo/data/question_repository.dart';
import 'package:dcristaldo/domain/question.dart';

class QuestionService {
  final QuestionRepository _questionRepository = QuestionRepository();

  Future<List<Question>> getQuestions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _questionRepository.getInitialQuestions();
  }
}