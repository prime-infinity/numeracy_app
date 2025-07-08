import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/providers/question_provider.dart';
import 'package:numeracy_app/services/stats_service.dart';
import 'package:numeracy_app/theme.dart';

class QuestionCard extends ConsumerStatefulWidget {
  const QuestionCard(
    this.question, {
    required this.visibility,
    required this.onAnswerSelected,
    required this.isQuizEnded,
    required this.range, // Add range parameter
    required this.operations, // Add operations parameter
    required this.isJourneyMode,
    super.key,
  });

  final Question question;
  final double visibility;
  final void Function() onAnswerSelected;
  final bool isQuizEnded;
  final String range; // Range parameter for difficulty tracking
  final List<String> operations; // Operations for determining current operation
  final bool isJourneyMode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<QuestionCard>
    with TickerProviderStateMixin {
  void _handleOptionSelection(String optionId, int answerValue) async {
    if (widget.isQuizEnded) return;

    final questionNumber = widget.question.questionNumber;
    final questionNotifier = ref.read(questionNotifierProvider.notifier);

    if (questionNotifier.isQuestionAnswered(questionNumber)) {
      return;
    }

    final isCorrect = widget.question.isCorrect(answerValue);

    setState(() {});

    // Record the answer in the provider
    questionNotifier.recordAnswer(questionNumber, isCorrect, optionId);

    // Determine the operation from the question text
    String operation =
        _determineOperationFromQuestion(widget.question.questionText);

    // Record the attempt in Hive for stats
    await StatsService.recordAttempt(
      operation: operation,
      difficulty: widget.range,
      isCorrect: isCorrect,
      isJourneyMode: widget.isJourneyMode,
    );

    // Delay to show the selection feedback
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onAnswerSelected();
    });
  }

  // Helper method to determine operation from question text
  String _determineOperationFromQuestion(String questionText) {
    if (questionText.contains('+')) {
      return 'addition';
    } else if (questionText.contains('−') || questionText.contains('-')) {
      return 'subtraction';
    } else if (questionText.contains('×') || questionText.contains('*')) {
      return 'multiplication';
    } else if (questionText.contains('÷') || questionText.contains('/')) {
      return 'division';
    }

    // Fallback: if we have operations passed, use the first one
    if (widget.operations.isNotEmpty) {
      return widget.operations.first;
    }

    // Final fallback
    return 'addition';
  }

  Color _getOptionColor(int questionNumber, String optionId) {
    final questionNotifier = ref.watch(questionNotifierProvider.notifier);

    if (!questionNotifier.isQuestionAnswered(questionNumber)) {
      return AppColors.surface;
    }

    if (questionNotifier.isQuestionAnswered(questionNumber)) {
      final questionRes = questionNotifier.getQuestionResponse(questionNumber);
      final correctOption = widget.question.getCorrectOptionId();

      if (questionRes!.isCorrect) {
        if (optionId == questionRes.selectedOption) {
          return AppColors.successColor;
        }
      } else {
        if (optionId == questionRes.selectedOption) {
          return AppColors.errorColor;
        }
        if (optionId == correctOption) {
          return AppColors.successColor;
        }
      }
    }

    return AppColors.surface;
  }

  Color _getOptionTextColor(int questionNumber, String optionId) {
    final questionNotifier = ref.watch(questionNotifierProvider.notifier);

    if (!questionNotifier.isQuestionAnswered(questionNumber)) {
      return AppColors.textPrimary;
    }

    if (questionNotifier.isQuestionAnswered(questionNumber)) {
      final questionRes = questionNotifier.getQuestionResponse(questionNumber);
      final correctOption = widget.question.getCorrectOptionId();

      if (questionRes!.isCorrect) {
        if (optionId == questionRes.selectedOption) {
          return Colors.white;
        }
      } else {
        if (optionId == questionRes.selectedOption ||
            optionId == correctOption) {
          return Colors.white;
        }
      }
    }

    return AppColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.height * 0.65;
    final cardWidth = screenSize.width * 0.9;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Question Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.spacingL),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.cardRadius),
                topRight: Radius.circular(AppDimensions.cardRadius),
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.question.questionText,
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryAccent,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Answer Options
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacingL),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.question.options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final option = widget.question.options[index];
                  final optionId = option.keys.first;
                  final optionValue = option.values.first;

                  return GestureDetector(
                    onTap: () => _handleOptionSelection(optionId, optionValue),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _getOptionColor(
                            widget.question.questionNumber, optionId),
                        borderRadius: BorderRadius.circular(
                            AppDimensions.containerRadius),
                        border: Border.all(
                          color: _getOptionColor(widget.question.questionNumber,
                                      optionId) ==
                                  AppColors.surface
                              ? AppColors.borderColor
                              : _getOptionColor(
                                  widget.question.questionNumber, optionId),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              optionValue.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _getOptionTextColor(
                                    widget.question.questionNumber, optionId),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
