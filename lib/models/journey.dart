// models/journey.dart
import 'package:numeracy_app/models/operation.dart';

enum JourneyDifficulty {
  easy('a', '1-10', 'Easy'),
  medium('b', '1-100', 'Medium'),
  hard('c', '1-1000', 'Hard');

  const JourneyDifficulty(this.code, this.range, this.displayName);

  final String code;
  final String range;
  final String displayName;
}

class JourneyStep {
  final Operation operation;
  final JourneyDifficulty difficulty;
  final int stepNumber;
  final bool isUnlocked;
  final bool isCompleted;
  final double? accuracy;
  final int? totalAttempts;

  JourneyStep({
    required this.operation,
    required this.difficulty,
    required this.stepNumber,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.accuracy,
    this.totalAttempts,
  });

  String get title => '${operation.name} - ${difficulty.displayName}';

  String get description =>
      '${operation.name} with numbers ${difficulty.range}';

  JourneyStep copyWith({
    Operation? operation,
    JourneyDifficulty? difficulty,
    int? stepNumber,
    bool? isUnlocked,
    bool? isCompleted,
    double? accuracy,
    int? totalAttempts,
  }) {
    return JourneyStep(
      operation: operation ?? this.operation,
      difficulty: difficulty ?? this.difficulty,
      stepNumber: stepNumber ?? this.stepNumber,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      accuracy: accuracy ?? this.accuracy,
      totalAttempts: totalAttempts ?? this.totalAttempts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'operation': operation.name,
      'difficulty': difficulty.name,
      'stepNumber': stepNumber,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'accuracy': accuracy,
      'totalAttempts': totalAttempts,
    };
  }

  static JourneyStep fromMap(Map<String, dynamic> map) {
    return JourneyStep(
      operation: OperationExtension.fromString(map['operation']),
      difficulty: JourneyDifficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
      ),
      stepNumber: map['stepNumber'] ?? 0,
      isUnlocked: map['isUnlocked'] ?? false,
      isCompleted: map['isCompleted'] ?? false,
      accuracy: map['accuracy']?.toDouble(),
      totalAttempts: map['totalAttempts'],
    );
  }
}

class Journey {
  final List<JourneyStep> steps;
  final int currentStepIndex;
  final int totalSteps;

  Journey({
    required this.steps,
    this.currentStepIndex = 0,
  }) : totalSteps = steps.length;

  JourneyStep get currentStep => steps[currentStepIndex];

  bool get isCompleted =>
      currentStepIndex >= steps.length - 1 && currentStep.isCompleted;

  double get overallProgress => currentStepIndex / totalSteps;

  static Journey createDefault() {
    final List<JourneyStep> steps = [];
    int stepNumber = 1;

    // Create steps for each operation and difficulty
    for (final operation in Operation.values) {
      for (final difficulty in JourneyDifficulty.values) {
        steps.add(JourneyStep(
          operation: operation,
          difficulty: difficulty,
          stepNumber: stepNumber,
          isUnlocked: stepNumber == 1, // Only first step is unlocked initially
          isCompleted: false,
        ));
        stepNumber++;
      }
    }

    return Journey(steps: steps);
  }

  Journey copyWith({
    List<JourneyStep>? steps,
    int? currentStepIndex,
  }) {
    return Journey(
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'steps': steps.map((step) => step.toMap()).toList(),
      'currentStepIndex': currentStepIndex,
    };
  }

  static Journey fromMap(Map<String, dynamic> map) {
    return Journey(
      steps: (map['steps'] as List<dynamic>)
          .map((stepMap) => JourneyStep.fromMap(stepMap))
          .toList(),
      currentStepIndex: map['currentStepIndex'] ?? 0,
    );
  }
}
