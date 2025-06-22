import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/providers/question_provider.dart';
import 'package:numeracy_app/theme.dart';

class QuestionCard extends ConsumerStatefulWidget {
  const QuestionCard(
    this.question, {
    required this.visibility,
    required this.onAnswerSelected,
    required this.isQuizEnded,
    super.key,
  });

  final Question question;
  final double visibility;
  final void Function() onAnswerSelected;
  final bool isQuizEnded;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<QuestionCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  String? _selectedOptionId;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleOptionSelection(String optionId, int answerValue) {
    if (widget.isQuizEnded) return;

    final questionNumber = widget.question.questionNumber;
    final questionNotifier = ref.read(questionNotifierProvider.notifier);

    if (questionNotifier.isQuestionAnswered(questionNumber)) {
      return;
    }

    setState(() {
      _selectedOptionId = optionId;
    });

    // Trigger pulse animation
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });

    // Record the answer in the provider
    questionNotifier.recordAnswer(
        questionNumber, widget.question.isCorrect(answerValue), optionId);

    // Delay to show the selection feedback
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onAnswerSelected();
    });
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

  IconData? _getOptionIcon(int questionNumber, String optionId) {
    final questionNotifier = ref.watch(questionNotifierProvider.notifier);

    if (!questionNotifier.isQuestionAnswered(questionNumber)) {
      return null;
    }

    if (questionNotifier.isQuestionAnswered(questionNumber)) {
      final questionRes = questionNotifier.getQuestionResponse(questionNumber);
      final correctOption = widget.question.getCorrectOptionId();

      if (questionRes!.isCorrect && optionId == questionRes.selectedOption) {
        return Icons.check_rounded;
      } else if (!questionRes.isCorrect) {
        if (optionId == questionRes.selectedOption) {
          return Icons.close_rounded;
        }
        if (optionId == correctOption) {
          return Icons.check_rounded;
        }
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.height * 0.65;
    final cardWidth = screenSize.width * 0.9;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _selectedOptionId != null ? _pulseAnimation.value : 1.0,
          child: Container(
            width: cardWidth,
            height: cardHeight,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
            decoration: BoxDecoration(
              color: AppColors.surface,
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                          onTap: () =>
                              _handleOptionSelection(optionId, optionValue),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: _getOptionColor(
                                  widget.question.questionNumber, optionId),
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.containerRadius),
                              border: Border.all(
                                color: _getOptionColor(
                                            widget.question.questionNumber,
                                            optionId) ==
                                        AppColors.surface
                                    ? AppColors.borderColor
                                    : _getOptionColor(
                                        widget.question.questionNumber,
                                        optionId),
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
                                          widget.question.questionNumber,
                                          optionId),
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

                // Instructions at bottom
                if (!ref
                        .watch(questionNotifierProvider.notifier)
                        .isQuestionAnswered(widget.question.questionNumber) &&
                    !widget.isQuizEnded)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppDimensions.spacingM),
                    child: Text(
                      'Tap your answer',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: AppDimensions.spacingS),
              ],
            ),
          ),
        );
      },
    );
  }
}
