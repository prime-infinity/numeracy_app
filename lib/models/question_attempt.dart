// models/question_attempt.dart
class QuestionAttempt {
  final DateTime date;
  final String
      operation; // 'addition', 'subtraction', 'multiplication', 'division'
  final String difficulty; // 'a', 'b', 'c' (easy, medium, hard)
  final int result; // 0 for incorrect, 1 for correct
  final bool isJourneyMode;

  QuestionAttempt({
    required this.date,
    required this.operation,
    required this.difficulty,
    required this.result,
    required this.isJourneyMode,
  });

  // Convert to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'operation': operation,
      'difficulty': difficulty,
      'result': result,
      'isJourneyMode': isJourneyMode,
    };
  }

  // Create from Map for Hive retrieval
  factory QuestionAttempt.fromMap(Map<String, dynamic> map) {
    return QuestionAttempt(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      operation: map['operation'],
      difficulty: map['difficulty'],
      result: map['result'],
      isJourneyMode: map['isJourneyMode'] ?? false,
    );
  }

  @override
  String toString() {
    return 'QuestionAttempt(date: $date, operation: $operation, difficulty: $difficulty, result: $result, isJourneyMode: $isJourneyMode)';
  }
}
