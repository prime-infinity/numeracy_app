import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/models/question_response.dart';
import 'package:numeracy_app/services/question_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_provider.g.dart';

@riverpod
class QuestionNotifier extends _$QuestionNotifier {
  @override
  Map<String, dynamic> build() {
    return {
      'timelimit': 10,
      'questions': generateRandomQuestions(),
      'answeredQuestions': <int, QuestionResponse>{},
    };
  }

  // method to record answers
  void recordAnswer(int questionNumber, bool isCorrect, String selectedOption) {
    // Create a copy of the current answered questions
    final currentAnswers =
        Map<int, QuestionResponse>.from(state['answeredQuestions']);

    // Add or update the answer for the specific question
    currentAnswers[questionNumber] =
        QuestionResponse(isCorrect: isCorrect, selectedOption: selectedOption);

    // Update the state with the new answered questions map
    state = {
      ...state,
      'answeredQuestions': currentAnswers,
    };
  }

  //replaces current questions with new ones
  void replaceQuestions(List<Question> questions) {
    state = {
      'timelimit': 10,
      'questions': questions,
      'answeredQuestions': <int, QuestionResponse>{},
    };
  }

  // Method to get a specific question's response
  QuestionResponse? getQuestionResponse(int questionNumber) {
    return state['answeredQuestions'][questionNumber];
  }

  // Method to check if a question has been answered
  bool isQuestionAnswered(int questionNumber) {
    return state['answeredQuestions'].containsKey(questionNumber);
  }
}
//dart run build_runner watch