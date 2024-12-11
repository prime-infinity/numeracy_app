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
}


/**
 * <int, bool>{}
 * 1 = true;
 * 2 = false;
 * 
 * what i want
 * 1 = {true, selectedID}
 * 2 = {false, selectedID}
 * like below
 * 1 = {true, 'a'}
 * 2 = {false, 'c'}
 *  
 * solution(create a custom class)
 * class QuestionResponse{
 *  bool isCorrect, String selectedId
 * }
 * 
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

// Check answer by option ID
  /*bool isCorrectOption(String optionId) {
    final option = _options.firstWhere(
      (opt) => opt.containsKey(optionId),
      orElse: () => {},
    );
    return option.isNotEmpty && option[optionId] == _result;
  }*/