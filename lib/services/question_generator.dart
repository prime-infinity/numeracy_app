import 'dart:math';

import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/models/question.dart';

/// Generates a list of math questions based on specific parameters.
///
/// [operations] - Optional list of operations to use. If null, use all operations.
/// [range] - Optional difficulty range 'a'(1-10), 'b'(1-100), 'c'(1-1000), default is 'b'.
List<Question> generateQuestions({
  List<Operation>? operations,
  String range = 'b',
}) {
  final Random random = Random();
  final List<Question> questions = [];

  // Range map to determine number range based on difficulty.
  final Map<String, (int, int)> ranges = {
    'a': (1, 10),
    'b': (1, 100),
    'c': (1, 1000),
  };
  final (minRange, maxRange) = ranges[range] ?? (1, 100);

  // Use provided operations or all operations.
  final availableOperations = operations ?? Operation.values;

  for (int i = 1; i <= 10; i++) {
    final operation =
        availableOperations[random.nextInt(availableOperations.length)];
    int operand1;
    int operand2;
    int result;

    // Special handling for division to ensure clean division.
    if (operation == Operation.division) {
      final maxResult = (maxRange ~/ 10).clamp(1, 12);
      result = random.nextInt(maxResult) + 1;
      operand2 = random.nextInt(maxResult) + 1;
      operand1 = result * operand2;
    } else {
      operand1 = random.nextInt(maxRange - minRange + 1) + minRange;
      operand2 = random.nextInt(maxRange - minRange + 1) + minRange;
      result = operation.calculate(operand1, operand2);
    }

    // Generate unique wrong answers.
    // Instead of using a fixed offset based on maxRange, we expand the offset until we have 3 wrong answers.
    final Set<int> wrongAnswers = {};
    int offset = 1;
    while (wrongAnswers.length < 3) {
      // Try adding a wrong answer above the correct answer.
      wrongAnswers.add(result + offset);

      // Try adding a wrong answer below the correct answer, ensuring it's positive.
      if (result - offset > 0) {
        wrongAnswers.add(result - offset);
      }
      offset++;
    }

    // Pick the first three wrong answers (they are now guaranteed to be unique).
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
