// services/stats_service.dart
import 'package:hive/hive.dart';
import 'package:numeracy_app/models/question_attempt.dart';

class StatsService {
  static const String _boxName = 'question_attempts';

  // Get the Hive box for storing question attempts
  static Box get _box => Hive.box(_boxName);

  // Initialize the stats service (call this in main.dart)
  static Future<void> initialize() async {
    await Hive.openBox(_boxName);
  }

  // Record a question attempt
  static Future<void> recordAttempt({
    required String operation,
    required String difficulty,
    required bool isCorrect,
  }) async {
    final attempt = QuestionAttempt(
      date: DateTime.now(),
      operation: operation,
      difficulty: difficulty,
      result: isCorrect ? 1 : 0,
    );

    await _box.add(attempt.toMap());
  }

  // Get all question attempts
  static List<QuestionAttempt> getAllAttempts() {
    final attempts = <QuestionAttempt>[];

    for (int i = 0; i < _box.length; i++) {
      final attemptMap = _box.getAt(i) as Map<String, dynamic>;
      attempts.add(QuestionAttempt.fromMap(attemptMap));
    }

    return attempts;
  }

  // Get attempts for a specific operation
  static List<QuestionAttempt> getAttemptsByOperation(String operation) {
    return getAllAttempts()
        .where((attempt) => attempt.operation == operation)
        .toList();
  }

  // Get attempts for a specific difficulty
  static List<QuestionAttempt> getAttemptsByDifficulty(String difficulty) {
    return getAllAttempts()
        .where((attempt) => attempt.difficulty == difficulty)
        .toList();
  }

  // Get attempts for a specific date range
  static List<QuestionAttempt> getAttemptsByDateRange(
      DateTime startDate, DateTime endDate) {
    return getAllAttempts()
        .where((attempt) =>
            attempt.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            attempt.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  // Get attempts for today
  static List<QuestionAttempt> getTodayAttempts() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getAttemptsByDateRange(startOfDay, endOfDay);
  }

  // Get attempts for this week
  static List<QuestionAttempt> getWeekAttempts() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return getAttemptsByDateRange(startOfWeekDay, now);
  }

  // Calculate accuracy for all attempts
  static double getOverallAccuracy() {
    final attempts = getAllAttempts();
    if (attempts.isEmpty) return 0.0;

    final correctAttempts =
        attempts.where((attempt) => attempt.result == 1).length;
    return (correctAttempts / attempts.length) * 100;
  }

  // Calculate accuracy for a specific operation
  static double getAccuracyByOperation(String operation) {
    final attempts = getAttemptsByOperation(operation);
    if (attempts.isEmpty) return 0.0;

    final correctAttempts =
        attempts.where((attempt) => attempt.result == 1).length;
    return (correctAttempts / attempts.length) * 100;
  }

  // Calculate accuracy for a specific difficulty
  static double getAccuracyByDifficulty(String difficulty) {
    final attempts = getAttemptsByDifficulty(difficulty);
    if (attempts.isEmpty) return 0.0;

    final correctAttempts =
        attempts.where((attempt) => attempt.result == 1).length;
    return (correctAttempts / attempts.length) * 100;
  }

  // Get total number of attempts
  static int getTotalAttempts() {
    return getAllAttempts().length;
  }

  // Get total correct attempts
  static int getTotalCorrect() {
    return getAllAttempts().where((attempt) => attempt.result == 1).length;
  }

  // Get streak (consecutive correct answers from most recent attempts)
  static int getCurrentStreak() {
    final attempts = getAllAttempts();
    if (attempts.isEmpty) return 0;

    // Sort by date descending (most recent first)
    attempts.sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    for (final attempt in attempts) {
      if (attempt.result == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // Get best streak ever
  static int getBestStreak() {
    final attempts = getAllAttempts();
    if (attempts.isEmpty) return 0;

    // Sort by date ascending (oldest first)
    attempts.sort((a, b) => a.date.compareTo(b.date));

    int currentStreak = 0;
    int bestStreak = 0;

    for (final attempt in attempts) {
      if (attempt.result == 1) {
        currentStreak++;
        bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
      } else {
        currentStreak = 0;
      }
    }

    return bestStreak;
  }

  // Clear all data (useful for testing or reset functionality)
  static Future<void> clearAllData() async {
    await _box.clear();
  }

  // Export data as a list of maps (useful for debugging)
  static List<Map<String, dynamic>> exportData() {
    return getAllAttempts().map((attempt) => attempt.toMap()).toList();
  }
}
