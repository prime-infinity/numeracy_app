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
    try {
      final journeyData = _box.get(_journeyKey);

      if (journeyData != null) {
        final journey = Journey.fromMap(Map<String, dynamic>.from(journeyData));
        return await _updateJourneyProgress(journey);
      }

      // Create default journey if none exists
      final defaultJourney = Journey.createDefault();
      await _saveJourney(defaultJourney);
      return await _updateJourneyProgress(defaultJourney);
    } catch (e) {
      print('Error getting current journey: $e');
      // If there's any error, create a fresh journey
      final defaultJourney = Journey.createDefault();
      await _saveJourney(defaultJourney);
      return await _updateJourneyProgress(defaultJourney);
    }
  }

  static Future<Journey> _updateJourneyProgress(Journey journey) async {
    try {
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
          accuracy: stepStats.totalAttempts > 0 ? stepStats.accuracy : null,
          totalAttempts:
              stepStats.totalAttempts > 0 ? stepStats.totalAttempts : null,
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
    } catch (e) {
      print('Error updating journey progress: $e');
      // Return the original journey if update fails
      return journey;
    }
  }

  static Future<({double accuracy, int totalAttempts})> _getStepStats(
      JourneyStep step) async {
    try {
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
    } catch (e) {
      print('Error getting step stats: $e');
      return (accuracy: 0.0, totalAttempts: 0);
    }
  }

  static Future<void> _saveJourney(Journey journey) async {
    try {
      await _box.put(_journeyKey, journey.toMap());
    } catch (e) {
      print('Error saving journey: $e');
      throw e;
    }
  }

  static Future<void> resetJourney() async {
    try {
      // Clear all journey data
      await _box.clear();

      // Create and save a fresh default journey
      final defaultJourney = Journey.createDefault();
      await _saveJourney(defaultJourney);
    } catch (e) {
      print('Error resetting journey: $e');
      throw e;
    }
  }

  static Future<void> completeStep(JourneyStep step) async {
    try {
      final journey = await getCurrentJourney();
      final updatedSteps = journey.steps.map((s) {
        if (s.stepNumber == step.stepNumber) {
          return s.copyWith(isCompleted: true);
        }
        return s;
      }).toList();

      final updatedJourney = journey.copyWith(steps: updatedSteps);
      await _saveJourney(updatedJourney);
    } catch (e) {
      print('Error completing step: $e');
      throw e;
    }
  }

  static Future<bool> canAccessStep(JourneyStep step) async {
    try {
      final journey = await getCurrentJourney();
      final stepInJourney = journey.steps.firstWhere(
        (s) => s.stepNumber == step.stepNumber,
        orElse: () => step, // Return the step itself if not found
      );
      return stepInJourney.isUnlocked;
    } catch (e) {
      print('Error checking step access: $e');
      return false;
    }
  }

  static Future<List<JourneyStep>> getCompletedSteps() async {
    try {
      final journey = await getCurrentJourney();
      return journey.steps.where((step) => step.isCompleted).toList();
    } catch (e) {
      print('Error getting completed steps: $e');
      return [];
    }
  }

  static Future<List<JourneyStep>> getUnlockedSteps() async {
    try {
      final journey = await getCurrentJourney();
      return journey.steps.where((step) => step.isUnlocked).toList();
    } catch (e) {
      print('Error getting unlocked steps: $e');
      return [];
    }
  }

  static Future<JourneyStep?> getNextStep() async {
    try {
      final journey = await getCurrentJourney();
      if (journey.currentStepIndex < journey.steps.length - 1) {
        return journey.steps[journey.currentStepIndex + 1];
      }
      return null;
    } catch (e) {
      print('Error getting next step: $e');
      return null;
    }
  }

  static Future<double> getJourneyProgress() async {
    try {
      final journey = await getCurrentJourney();
      final completedSteps =
          journey.steps.where((step) => step.isCompleted).length;
      return completedSteps / journey.totalSteps;
    } catch (e) {
      print('Error getting journey progress: $e');
      return 0.0;
    }
  }

  static Future<void> clearJourneyData() async {
    try {
      await _box.clear();
    } catch (e) {
      print('Error clearing journey data: $e');
      throw e;
    }
  }
}
