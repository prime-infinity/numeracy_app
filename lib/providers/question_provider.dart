import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/services/question_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_provider.g.dart';

@riverpod
class QuestionNotifier extends _$QuestionNotifier {
  @override
  List<Question> build() {
    return generateRandomQuestions();
  }

  //replaces current questions with new ones
  void replaceQuestions(List<Question> questions) {
    state = questions;
  }
}
