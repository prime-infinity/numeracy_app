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
      final dynamic attemptData = _box.getAt(i);

      // Handle the type conversion safely
      Map<String, dynamic> attemptMap;
      if (attemptData is Map<String, dynamic>) {
        attemptMap = attemptData;
      } else if (attemptData is Map) {
        // Convert Map<dynamic, dynamic> to Map<String, dynamic>
        attemptMap = Map<String, dynamic>.from(attemptData);
      } else {
        // Skip invalid data
        continue;
      }

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

  // NEW: Get accuracy data over time for graphing
  static List<AccuracyDataPoint> getAccuracyOverTime({int? daysBack}) {
    final attempts = getAllAttempts();
    if (attempts.isEmpty) return [];

    // Sort attempts by date
    attempts.sort((a, b) => a.date.compareTo(b.date));

    // Determine date range
    final endDate = DateTime.now();
    final startDate = daysBack != null
        ? endDate.subtract(Duration(days: daysBack))
        : attempts.first.date;

    // Filter attempts within date range
    final filteredAttempts = attempts
        .where((attempt) =>
            attempt.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            attempt.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    // Group attempts by date and calculate daily accuracy
    final Map<String, List<QuestionAttempt>> attemptsByDate = {};

    for (final attempt in filteredAttempts) {
      final dateKey =
          '${attempt.date.year}-${attempt.date.month}-${attempt.date.day}';
      attemptsByDate[dateKey] = attemptsByDate[dateKey] ?? [];
      attemptsByDate[dateKey]!.add(attempt);
    }

    // Convert to accuracy data points
    final List<AccuracyDataPoint> dataPoints = [];

    for (final entry in attemptsByDate.entries) {
      final dateKey = entry.key;
      final dayAttempts = entry.value;

      final correctCount = dayAttempts.where((a) => a.result == 1).length;
      final accuracy = (correctCount / dayAttempts.length) * 100;

      // Parse date from key
      final dateParts = dateKey.split('-');
      final date = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );

      dataPoints.add(AccuracyDataPoint(
        date: date,
        accuracy: accuracy,
        totalQuestions: dayAttempts.length,
        correctAnswers: correctCount,
      ));
    }

    // Sort by date
    dataPoints.sort((a, b) => a.date.compareTo(b.date));

    return dataPoints;
  }

  // NEW: Get weekly accuracy averages
  static List<AccuracyDataPoint> getWeeklyAccuracyAverages({int? weeksBack}) {
    final attempts = getAllAttempts();
    if (attempts.isEmpty) return [];

    attempts.sort((a, b) => a.date.compareTo(b.date));

    final endDate = DateTime.now();
    final startDate = weeksBack != null
        ? endDate.subtract(Duration(days: weeksBack * 7))
        : attempts.first.date;

    final filteredAttempts = attempts
        .where((attempt) =>
            attempt.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            attempt.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    // Group by week
    final Map<String, List<QuestionAttempt>> attemptsByWeek = {};

    for (final attempt in filteredAttempts) {
      // Get the start of the week (Monday)
      final weekStart =
          attempt.date.subtract(Duration(days: attempt.date.weekday - 1));
      final weekKey = '${weekStart.year}-${weekStart.month}-${weekStart.day}';

      attemptsByWeek[weekKey] = attemptsByWeek[weekKey] ?? [];
      attemptsByWeek[weekKey]!.add(attempt);
    }

    final List<AccuracyDataPoint> dataPoints = [];

    for (final entry in attemptsByWeek.entries) {
      final weekKey = entry.key;
      final weekAttempts = entry.value;

      final correctCount = weekAttempts.where((a) => a.result == 1).length;
      final accuracy = (correctCount / weekAttempts.length) * 100;

      // Parse date from key
      final dateParts = weekKey.split('-');
      final weekStartDate = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );

      dataPoints.add(AccuracyDataPoint(
        date: weekStartDate,
        accuracy: accuracy,
        totalQuestions: weekAttempts.length,
        correctAnswers: correctCount,
      ));
    }

    dataPoints.sort((a, b) => a.date.compareTo(b.date));
    return dataPoints;
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

// NEW: Data class for accuracy over time
class AccuracyDataPoint {
  final DateTime date;
  final double accuracy;
  final int totalQuestions;
  final int correctAnswers;

  AccuracyDataPoint({
    required this.date,
    required this.accuracy,
    required this.totalQuestions,
    required this.correctAnswers,
  });

  @override
  String toString() {
    return 'AccuracyDataPoint(date: $date, accuracy: ${accuracy.toStringAsFixed(1)}%, total: $totalQuestions, correct: $correctAnswers)';
  }
}
