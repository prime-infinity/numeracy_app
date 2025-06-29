import 'package:numeracy_app/models/operation.dart';

class Question {
  Question({
    required this.operand1,
    required this.operand2,
    required this.operation,
    required this.questionNumber,
    required List<Map<String, int>> options,
  })  : _options = options,
        _result = operation.calculate(operand1, operand2) {
    // Validate that one option matches the result
    if (!options.any((option) => option.values.first == _result)) {
      throw ArgumentError('One option must match the correct result: $_result');
    }
  }

  final int operand1;
  final int operand2;
  final Operation operation;
  final int questionNumber;
  final List<Map<String, int>> _options;
  final int _result;

  //getters
  List<Map<String, int>> get options => List.unmodifiable(_options);

  // Get question as string for display
  String get questionText => '$operand1 ${operation.symbol} $operand2';

  // Check answer directly
  bool isCorrect(int answer) => answer == _result;

  // Method to get the correct option
  String getCorrectOptionId() {
    return _options
        .firstWhere((option) => option.values.first == _result)
        .keys
        .first;
  }
}
