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
  //bool isCorrect(int answer) => answer == _result;

  // Check answer by option ID
  /*bool isCorrectOption(String optionId) {
    final option = _options.firstWhere(
      (opt) => opt.containsKey(optionId),
      orElse: () => {},
    );
    return option.isNotEmpty && option[optionId] == _result;
  }*/
}

final List<Question> questions = [
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

/**
 * QuestionCard(
      questionNumber: '14',
      question: '5+4',
      options: const ['15', '9', '81', '91'],
    )
 */
/*
from typescript
export interface Question{
    id:string;
    question:string;
    difficulty: 1 | 2 | 3 | 4 | 5;
    category: string;
    subcategory: string;
    options: {
        id: string;
        text: string;
    }[];
    correctAnswer: string;
    tags: string[];
    relatedQuestions: string[];
    metadata:{
        author: string;
        usageStats: {
            timesAnswered: number;
            timesCorrect: number;
            averageTimeToAnswer: number; // in seconds
        };
    }
}*/