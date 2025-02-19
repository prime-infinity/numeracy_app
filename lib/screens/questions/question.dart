import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/models/question_response.dart';
import 'package:numeracy_app/providers/question_provider.dart';
import 'package:numeracy_app/screens/questions/question_card.dart';
import 'package:numeracy_app/services/question_generator.dart';
import 'package:numeracy_app/shared/modals/completion_modal.dart';
import 'package:numeracy_app/theme.dart';

class Question extends ConsumerStatefulWidget {
  final String range;
  final List<Operation> operations;

  const Question(
      {super.key, this.range = 'b', this.operations = Operation.values});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionState();
}

class _QuestionState extends ConsumerState<Question> {
  final _pageController = PageController(
    viewportFraction: 0.95,
  );

  double _currentPage = 0;
  int _index = 0;
  bool _hasStarted = false; // Flag to track if timer should start
  bool _wasEverStarted = false; // Track if quiz was ever completed
  bool _quizEnded = false; // Track if the quiz has ended
  bool _modalVisible = false; // Track if the completion modal is visible

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
    // Delay provider modification until after the first frame.
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
    // Cancel existing timer
    _timer?.cancel();
    _timer = null;

    // Generate new questions using the provider
    ref.read(questionNotifierProvider.notifier).replaceQuestions(
        generateQuestions(range: widget.range, operations: widget.operations));

    // Reset all state variables
    setState(() {
      _hasStarted = false;
      _currentPage = 0;
      _index = 0;
      _quizEnded = false;
      _modalVisible = false;
      _wasEverStarted = false;
      _initializeTimer();
    });

    // Animate back to first question
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
    if (_timer != null || _hasStarted || _quizEnded)
      return; // Don't start if already running or ended

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
    if (_modalVisible) return; // Prevent showing modal if it's already visible

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

  // Get color for the indicator based on answer status
  Color _getIndicatorColor(int index) {
    final state = ref.watch(questionNotifierProvider);
    final questions = state['questions'];
    final answeredQuestions = state['answeredQuestions'];

    final currentQuestion = questions[index];

    // Check if the question has been answered
    if (!answeredQuestions.containsKey(currentQuestion.questionNumber)) {
      return _index == index ? AppColors.primaryColor : AppColors.white;
    }

    return answeredQuestions[currentQuestion.questionNumber]!.isCorrect
        ? AppColors.successColor // Green for correct
        : AppColors.failureColor; // Red for incorrect
  }

  // Handle answer selection
  void _handleAnswerSelected() {
    if (_quizEnded) return; // Don't process answers if quiz has ended

    final state = ref.watch(questionNotifierProvider);
    final questions = state['questions'];
    final answeredQuestions =
        state['answeredQuestions'] as Map<int, QuestionResponse>;

    // Start timer on first attempt if not already started
    if (!_hasStarted) {
      _startTimer();
    }

    // Check if all questions have been answered
    bool allQuestionsAnswered = questions.every(
        (question) => answeredQuestions.containsKey(question.questionNumber));

    // Wait a moment to show the answer feedback before scrolling
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_index < questions.length - 1 && !_quizEnded) {
        _pageController.animateToPage(
          _index + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }

      // Only show completion dialog if all questions are answered and no modal is visible
      if (allQuestionsAnswered && !_modalVisible) {
        _endQuiz();
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    if (_modalVisible) return; // Prevent multiple modals

    setState(() {
      _modalVisible = true;
    });

    final state = ref.watch(questionNotifierProvider);
    final questions = state['questions'];
    final answeredQuestions =
        state['answeredQuestions'] as Map<int, QuestionResponse>;

    // Calculate score
    int correctAnswers =
        answeredQuestions.values.where((response) => response.isCorrect).length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CompletionModal(
          correctAnswers: correctAnswers,
          totalQuestions: questions.length,
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
              // Keep _quizEnded as true to prevent further interaction
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the questions from the provider
    final state = ref.watch(questionNotifierProvider);
    final questions = state['questions'];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("questions"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2), // Top spacing
            SizedBox(
              height: 543,
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
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: QuestionCard(
                      questions[index],
                      visibility: visibility,
                      onAnswerSelected: _handleAnswerSelected,
                      isQuizEnded: _quizEnded, // Pass quiz ended state to card
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                    color: AppColors.cardGrey,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.cardRadius)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        questions.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getIndicatorColor(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.cardRadius)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_timeLeft',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 3), // Bottom spacing
          ],
        ),
      ),
    );
  }
}
