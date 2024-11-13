import 'dart:math';

import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/models/question.dart';

/// Generates a list of 10 random math questions with varying operations and options.
List<Question> generateRandomQuestions() {
  final Random random = Random();
  final List<Question> questions = [];

  for (int i = 1; i <= 10; i++) {
    final operation = Operation.values[random.nextInt(Operation.values.length)];
    final operand1 = random.nextInt(50) + 1;
    final operand2 = random.nextInt(50) + 1;
    final result = operation.calculate(operand1, operand2);

    // Generate 4 options, one of which is the correct answer
    final options = [
      {"a": result},
      {"b": result + random.nextInt(6) + 1},
      {"c": result - random.nextInt(6) + 1},
      {"d": result + random.nextInt(6) + 1},
    ]..shuffle();

    questions.add(Question(
      operand1: operand1,
      operand2: operand2,
      operation: operation,
      questionNumber: i,
      options: options,
    ));
  }

  return questions;
}
