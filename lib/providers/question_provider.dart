import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_provider.g.dart';

@riverpod
class QuestionNotifier extends _$QuestionNotifier {
  @override
  List<Question> build() {
    return [
      Question(
          operand1: 5,
          operand2: 3,
          operation: Operation.addition,
          questionNumber: 1,
          options: [
            {"a": 7},
            {"b": 8},
            {"c": 9},
            {"d": 10},
          ]),
      Question(
        questionNumber: 2,
        operation: Operation.subtraction,
        operand1: 15,
        operand2: 7,
        options: [
          {"a": 6},
          {"b": 7},
          {"c": 8},
          {"d": 9},
        ],
      ),
      Question(
        questionNumber: 3,
        operation: Operation.multiplication,
        operand1: 4,
        operand2: 6,
        options: [
          {"a": 18},
          {"b": 20},
          {"c": 22},
          {"d": 24},
        ],
      ),
      Question(
        operation: Operation.division,
        operand1: 20,
        operand2: 5,
        questionNumber: 4,
        options: [
          {"a": 3},
          {"b": 4},
          {"c": 5},
          {"d": 6},
        ],
      ),
      Question(
        operation: Operation.addition,
        operand1: 9,
        operand2: 7,
        questionNumber: 5,
        options: [
          {"a": 14},
          {"b": 15},
          {"c": 16},
          {"d": 17},
        ],
      ),
      Question(
        operation: Operation.subtraction,
        operand1: 25,
        operand2: 8,
        questionNumber: 6,
        options: [
          {"a": 17},
          {"b": 16},
          {"c": 15},
          {"d": 18},
        ],
      ),
      Question(
        operation: Operation.multiplication,
        operand1: 3,
        operand2: 8,
        questionNumber: 7,
        options: [
          {"a": 21},
          {"b": 22},
          {"c": 23},
          {"d": 24},
        ],
      ),
      Question(
        operation: Operation.division,
        operand1: 36,
        operand2: 6,
        questionNumber: 8,
        options: [
          {"a": 5},
          {"b": 6},
          {"c": 7},
          {"d": 8},
        ],
      ),
      Question(
        operation: Operation.addition,
        operand1: 12,
        operand2: 13,
        questionNumber: 9,
        options: [
          {"a": 23},
          {"b": 24},
          {"c": 25},
          {"d": 26},
        ],
      ),
      Question(
        operation: Operation.subtraction,
        operand1: 30,
        operand2: 14,
        questionNumber: 10,
        options: [
          {"a": 14},
          {"b": 15},
          {"c": 13},
          {"d": 16},
        ],
      ),
    ];
  }

  //replaces current questions with new ones
  void replaceQuestions(List<Question> questions) {
    state = questions;
  }
}
