import 'dart:math';

import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/models/question.dart';

/// Generates a list of 10 random math questions with varying operations and options.
List<Question> generateRandomQuestions() {
  final Random random = Random();
  final List<Question> questions = [];

  for (int i = 1; i <= 10; i++) {
    final operation = Operation.values[random.nextInt(Operation.values.length)];
    int operand1;
    int operand2;
    int result;

    // Special handling for division to ensure clean division
    if (operation == Operation.division) {
      // First generate the result (1-12 for reasonable difficulty)
      result = random.nextInt(12) + 1;
      // Then generate the second operand (1-10 for reasonable difficulty)
      operand2 = random.nextInt(10) + 1;
      // Calculate first operand by multiplying to ensure clean division
      operand1 = result * operand2;
    } else {
      operand1 = random.nextInt(50) + 1;
      operand2 = random.nextInt(50) + 1;
      result = operation.calculate(operand1, operand2);
    }

    // Generate unique wrong answers
    final Set<int> wrongAnswers = {};
    while (wrongAnswers.length < 3) {
      // Randomly decide whether to add or subtract
      final bool shouldAdd = random.nextBool();
      final offset = random.nextInt(6) + 1;
      final wrongAnswer = shouldAdd ? result + offset : result - offset;

      // Only add if it's different from the correct answer and not already in the set
      if (wrongAnswer != result) {
        wrongAnswers.add(wrongAnswer);
      }
    }

    // Create options list with the correct answer and wrong answers
    final options = [
      {"a": result},
      {"b": wrongAnswers.elementAt(0)},
      {"c": wrongAnswers.elementAt(1)},
      {"d": wrongAnswers.elementAt(2)},
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
