// services/journey_service.dart
import 'package:hive/hive.dart';
import 'package:numeracy_app/models/journey.dart';
import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/services/stats_service.dart';

class JourneyService {
  static const String _boxName = 'journey_progress';
  static const String _journeyKey = 'current_journey';

  static Box get _box => Hive.box(_boxName);

  static Future<void> initialize() async {
    await Hive.openBox(_boxName);
  }

  static Future<Journey> getCurrentJourney() async {
    final journeyData = _box.get(_journeyKey);

    if (journeyData != null) {
      final journey = Journey.fromMap(Map<String, dynamic>.from(journeyData));
      return await _updateJourneyProgress(journey);
    }

    // Create default journey if none exists
    final defaultJourney = Journey.createDefault();
    await _saveJourney(defaultJourney);
    return defaultJourney;
  }

  static Future<Journey> _updateJourneyProgress(Journey journey) async {
    final updatedSteps = <JourneyStep>[];

    for (int i = 0; i < journey.steps.length; i++) {
      final step = journey.steps[i];

      // Get stats for this specific step
      final stepStats = await _getStepStats(step);

      // Check if step should be completed (90% accuracy with at least 10 attempts)
      final shouldBeCompleted =
          stepStats.accuracy >= 90.0 && stepStats.totalAttempts >= 10;

      // Check if step should be unlocked (previous step completed or it's the first step)
      final shouldBeUnlocked =
          i == 0 || (i > 0 && updatedSteps[i - 1].isCompleted);

      updatedSteps.add(step.copyWith(
        isUnlocked: shouldBeUnlocked,
        isCompleted: shouldBeCompleted,
        accuracy: stepStats.accuracy,
        totalAttempts: stepStats.totalAttempts,
      ));
    }

    // Find current step index (first incomplete step)
    int currentIndex = 0;
    for (int i = 0; i < updatedSteps.length; i++) {
      if (!updatedSteps[i].isCompleted) {
        currentIndex = i;
        break;
      }
      if (i == updatedSteps.length - 1) {
        // All steps completed
        currentIndex = i;
      }
    }

    final updatedJourney = Journey(
      steps: updatedSteps,
      currentStepIndex: currentIndex,
    );

    await _saveJourney(updatedJourney);
    return updatedJourney;
  }

  static Future<({double accuracy, int totalAttempts})> _getStepStats(
      JourneyStep step) async {
    // Get all attempts for this specific operation and difficulty
    final attempts = StatsService.getAllAttempts()
        .where((attempt) =>
            attempt.operation == step.operation.name &&
            attempt.difficulty == step.difficulty.code)
        .toList();

    if (attempts.isEmpty) {
      return (accuracy: 0.0, totalAttempts: 0);
    }

    final correctAttempts =
        attempts.where((attempt) => attempt.result == 1).length;
    final accuracy = (correctAttempts / attempts.length) * 100;

    return (accuracy: accuracy, totalAttempts: attempts.length);
  }

  static Future<void> _saveJourney(Journey journey) async {
    await _box.put(_journeyKey, journey.toMap());
  }

  static Future<void> resetJourney() async {
    final defaultJourney = Journey.createDefault();
    await _saveJourney(defaultJourney);
  }

  static Future<void> completeStep(JourneyStep step) async {
    final journey = await getCurrentJourney();
    final updatedSteps = journey.steps.map((s) {
      if (s.stepNumber == step.stepNumber) {
        return s.copyWith(isCompleted: true);
      }
      return s;
    }).toList();

    final updatedJourney = journey.copyWith(steps: updatedSteps);
    await _saveJourney(updatedJourney);
  }

  static Future<bool> canAccessStep(JourneyStep step) async {
    final journey = await getCurrentJourney();
    final stepInJourney = journey.steps.firstWhere(
      (s) => s.stepNumber == step.stepNumber,
    );
    return stepInJourney.isUnlocked;
  }

  static Future<List<JourneyStep>> getCompletedSteps() async {
    final journey = await getCurrentJourney();
    return journey.steps.where((step) => step.isCompleted).toList();
  }

  static Future<List<JourneyStep>> getUnlockedSteps() async {
    final journey = await getCurrentJourney();
    return journey.steps.where((step) => step.isUnlocked).toList();
  }

  static Future<JourneyStep?> getNextStep() async {
    final journey = await getCurrentJourney();
    if (journey.currentStepIndex < journey.steps.length - 1) {
      return journey.steps[journey.currentStepIndex + 1];
    }
    return null;
  }

  static Future<double> getJourneyProgress() async {
    final journey = await getCurrentJourney();
    final completedSteps =
        journey.steps.where((step) => step.isCompleted).length;
    return completedSteps / journey.totalSteps;
  }

  static Future<void> clearJourneyData() async {
    await _box.clear();
  }
}
