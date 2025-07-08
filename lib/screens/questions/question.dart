import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/models/question_response.dart';
import 'package:numeracy_app/providers/question_provider.dart';
import 'package:numeracy_app/screens/questions/question_card.dart';
import 'package:numeracy_app/services/question_generator.dart';
import 'package:numeracy_app/shared/modals/completion_modal.dart';
import 'package:numeracy_app/theme.dart';
import 'package:numeracy_app/services/journey_service.dart';

class Question extends ConsumerStatefulWidget {
  final String range;
  final List<Operation> operations;
  final bool isJourneyMode;

  const Question({
    super.key,
    this.range = 'b',
    this.operations = Operation.values,
    this.isJourneyMode = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionState();
}

class _QuestionState extends ConsumerState<Question> {
  final _pageController = PageController(
    viewportFraction: 0.95,
  );

  double _currentPage = 0;
  int _index = 0;
  bool _hasStarted = false;
  bool _wasEverStarted = false;
  bool _quizEnded = false;
  bool _modalVisible = false;

  // Timer variables
  int _timeLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(questionNotifierProvider.notifier).replaceQuestions(
          generateQuestions(
              operations: widget.operations, range: widget.range));
    });
    _initializeTimer();
  }

  void _initializeTimer() {
    final state = ref.read(questionNotifierProvider);
    _timeLeft = state['timelimit'];
  }

  void _resetQuiz() {
    _timer?.cancel();
    _timer = null;

    ref.read(questionNotifierProvider.notifier).replaceQuestions(
        generateQuestions(range: widget.range, operations: widget.operations));

    setState(() {
      _hasStarted = false;
      _currentPage = 0;
      _index = 0;
      _quizEnded = false;
      _modalVisible = false;
      _wasEverStarted = false;
      _initializeTimer();
    });

    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null || _hasStarted || _quizEnded) return;

    setState(() {
      _hasStarted = true;
      _wasEverStarted = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_quizEnded) {
        timer.cancel();
        return;
      }

      setState(() {
        _timeLeft--;
      });

      if (_timeLeft == 0) {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    if (_modalVisible) return;

    _timer?.cancel();
    _endQuiz();
    _showCompletionDialog();
  }

  void _endQuiz() {
    setState(() {
      _quizEnded = true;
      _hasStarted = false;
    });
  }

  Color _getIndicatorColor(int index) {
    final state = ref.watch(questionNotifierProvider);
    final questions = state['questions'];
    final answeredQuestions = state['answeredQuestions'];

    final currentQuestion = questions[index];

    if (!answeredQuestions.containsKey(currentQuestion.questionNumber)) {
      return _index == index ? AppColors.primaryColor : AppColors.textTertiary;
    }

    return answeredQuestions[currentQuestion.questionNumber]!.isCorrect
        ? AppColors.successColor
        : AppColors.errorColor;
  }

  void _handleAnswerSelected() {
    if (_quizEnded) return;

    final state = ref.watch(questionNotifierProvider);
    final questions = state['questions'];
    final answeredQuestions =
        state['answeredQuestions'] as Map<int, QuestionResponse>;

    if (!_hasStarted) {
      _startTimer();
    }

    bool allQuestionsAnswered = questions.every(
        (question) => answeredQuestions.containsKey(question.questionNumber));

    Future.delayed(const Duration(milliseconds: 150), () {
      if (_index < questions.length - 1 && !_quizEnded) {
        _pageController.animateToPage(
          _index + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }

      if (allQuestionsAnswered && !_modalVisible) {
        _endQuiz();
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() async {
    if (_modalVisible) return;

    setState(() {
      _modalVisible = true;
    });

    final state = ref.watch(questionNotifierProvider);
    final questions = state['questions'];
    final answeredQuestions =
        state['answeredQuestions'] as Map<int, QuestionResponse>;

    int correctAnswers =
        answeredQuestions.values.where((response) => response.isCorrect).length;

    // Handle journey completion and get actual completion status
    bool isStepActuallyCompleted = false;
    if (widget.isJourneyMode) {
      isStepActuallyCompleted = await _handleJourneyCompletion();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CompletionModal(
          correctAnswers: correctAnswers,
          totalQuestions: questions.length,
          isJourneyMode: widget.isJourneyMode,
          isJourneyStepCompleted:
              isStepActuallyCompleted, // Add this new parameter
          onTryAgain: () {
            Navigator.of(context).pop();
            setState(() {
              _modalVisible = false;
            });
            _resetQuiz();
          },
          onClose: () {
            Navigator.of(context).pop();
            setState(() {
              _modalVisible = false;
            });
          },
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Helper method to convert operations to string list
  List<String> _getOperationStrings() {
    return widget.operations.map((op) {
      switch (op) {
        case Operation.addition:
          return 'addition';
        case Operation.subtraction:
          return 'subtraction';
        case Operation.multiplication:
          return 'multiplication';
        case Operation.division:
          return 'division';
      }
    }).toList();
  }

  Future<bool> _handleJourneyCompletion() async {
    if (!widget.isJourneyMode) return false;

    final state = ref.watch(questionNotifierProvider);
    final answeredQuestions =
        state['answeredQuestions'] as Map<int, QuestionResponse>;
    final questions = state['questions'];

    final correctAnswers =
        answeredQuestions.values.where((response) => response.isCorrect).length;
    final accuracy = (correctAnswers / questions.length) * 100;

    // If accuracy is 90% or higher, record the journey step completion
    if (accuracy >= 90.0) {
      try {
        // Get the current journey to find the active step
        final journey = await JourneyService.getCurrentJourney();
        final currentStep = journey.steps[journey.currentStepIndex];

        // Only complete the step if it matches current difficulty and operation
        if (currentStep.difficulty.code == widget.range &&
            currentStep.operation.name == widget.operations.first.name) {
          await JourneyService.completeStep(currentStep);

          // Check if the step is actually completed by getting updated journey
          final updatedJourney = await JourneyService.getCurrentJourney();
          final updatedStep =
              updatedJourney.steps[updatedJourney.currentStepIndex];
          return updatedStep.isCompleted;
        }
      } catch (e) {
        print('Error completing journey step: $e');
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(questionNotifierProvider);
    final questions = state['questions'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () =>
              context.go(widget.isJourneyMode ? '/journey' : '/home'),
        ),
        title: Text(
          widget.isJourneyMode ? 'Math Journey' : 'Practice Session',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (_wasEverStarted)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _resetQuiz,
              tooltip: 'Restart Quiz',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress and Timer Section
            Container(
              margin: EdgeInsets.all(AppDimensions.spacingM),
              padding: EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppDimensions.containerRadius),
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Progress indicators
                  Row(
                    children: [
                      Text(
                        '${_index + 1} of ${questions.length}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacingM),
                      ...List.generate(
                        questions.length,
                        (index) => Container(
                          margin:
                              EdgeInsets.only(right: AppDimensions.spacingXS),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getIndicatorColor(index),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Timer
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingM,
                      vertical: AppDimensions.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: _timeLeft <= 10
                          ? AppColors.errorColor.withOpacity(0.1)
                          : AppColors.primaryAccent,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.chipRadius),
                      border: Border.all(
                        color: _timeLeft <= 10
                            ? AppColors.errorColor
                            : AppColors.primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_rounded,
                          size: 16,
                          color: _timeLeft <= 10
                              ? AppColors.errorColor
                              : AppColors.primaryColor,
                        ),
                        SizedBox(width: AppDimensions.spacingXS),
                        Text(
                          _formatTime(_timeLeft),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _timeLeft <= 10
                                ? AppColors.errorColor
                                : AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Questions Section
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: questions.length,
                physics: (_hasStarted || _wasEverStarted)
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _index = index;
                  });
                },
                itemBuilder: (context, index) {
                  double delta = index - _currentPage;
                  double visibility = 1 - delta.abs().clamp(0.0, 1.0);
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingS,
                    ),
                    child: QuestionCard(
                      questions[index],
                      visibility: visibility,
                      onAnswerSelected: _handleAnswerSelected,
                      isQuizEnded: _quizEnded,
                      range: widget.range, // Pass the range parameter
                      operations:
                          _getOperationStrings(), // Pass operations as strings
                      isJourneyMode: widget.isJourneyMode,
                    ),
                  );
                },
              ),
            ),

            // Instructions or Status - Modified to act as placeholder
            Container(
              margin: EdgeInsets.all(AppDimensions.spacingM),
              padding: EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: (!_hasStarted && !_wasEverStarted)
                    ? AppColors.primaryAccent
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppDimensions.containerRadius),
                border: (!_hasStarted && !_wasEverStarted)
                    ? Border.all(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        width: 1,
                      )
                    : null,
              ),
              child: (!_hasStarted && !_wasEverStarted)
                  ? Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: AppDimensions.spacingM),
                        Expanded(
                          child: Text(
                            'Tap any answer to start the timer and begin your practice session',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(
                      height:
                          45, // Approximate height to match the original content
                    ),
            ),

            SizedBox(height: AppDimensions.spacingM),
          ],
        ),
      ),
    );
  }
}
