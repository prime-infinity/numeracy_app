import 'dart:math';

import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/models/question.dart';

///Generates a list of math questions based on specific parameters
///
///[operations] - Optional list of operations to use. If null, use all operations
///[range] - Optional difficulty range 'a'(1-10), 'b'(1-100), 'c'(1-1000), default is 'b'

List<Question> generateQuestions({
  List<Operation>? operations,
  String range = 'b',
}) {
  final Random random = Random();
  final List<Question> questions = [];

  //range map to determine number range based on difficulty
  final Map<String, (int, int)> ranges = {
    'a': (1, 10),
    'b': (1, 100),
    'c': (1, 1000),
  };
  final (minRange, maxRange) = ranges[range] ?? (1, 100);

  // Use provided operations or all operations
  final availableOperations = operations ?? Operation.values;

  for (int i = 1; i <= 10; i++) {
    final operation =
        availableOperations[random.nextInt(availableOperations.length)];
    int operand1;
    int operand2;
    int result;

    // Special handling for division to ensure clean division
    if (operation == Operation.division) {
      // Adjust division logic based on range
      final maxResult =
          (maxRange ~/ 10).clamp(1, 12); // Ensure reasonable difficulty
      result = random.nextInt(maxResult) + 1;
      operand2 = random.nextInt(maxResult) + 1;
      operand1 = result * operand2;
    } else {
      operand1 = random.nextInt(maxRange - minRange + 1) + minRange;
      operand2 = random.nextInt(maxRange - minRange + 1) + minRange;
      result = operation.calculate(operand1, operand2);
    }

    // Generate unique wrong answers
    final Set<int> wrongAnswers = {};
    while (wrongAnswers.length < 3) {
      final bool shouldAdd = random.nextBool();
      // Scale the offset based on the range
      final maxOffset = (maxRange * 0.1).round().clamp(1, 10);
      final offset = random.nextInt(maxOffset) + 1;
      final wrongAnswer = shouldAdd ? result + offset : result - offset;

      // Only add if it's different from the correct answer and not already in the set
      if (wrongAnswer != result && !wrongAnswers.contains(wrongAnswer)) {
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
