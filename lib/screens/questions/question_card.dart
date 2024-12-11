import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/providers/question_provider.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class QuestionCard extends ConsumerStatefulWidget {
  const QuestionCard(this.question,
      {required this.visibility, required this.onAnswerSelected, super.key});

  final Question question;
  final double visibility;
  final void Function() onAnswerSelected;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<QuestionCard> {
  void _handleOptionSelection(String optionId, int answerValue) {
    // Check if the question has already been answered
    final questionNumber = widget.question.questionNumber;
    final questionNotifier = ref.read(questionNotifierProvider.notifier);

    if (questionNotifier.isQuestionAnswered(questionNumber)) {
      return;
    }

    //record the answer in the provider
    questionNotifier.recordAnswer(
        questionNumber, widget.question.isCorrect(answerValue), optionId);

    widget.onAnswerSelected();
  }

  Color _getOptionColor(int questionNumber, String optionId) {
    //check if this question has been answered at all.
    //i.e if the questionNumber exsist in QuestionResponse
    final questionNotifier = ref.watch(questionNotifierProvider.notifier);

    //if question not yet answered, then white
    if (!questionNotifier.isQuestionAnswered(questionNumber)) {
      return AppColors.white;
    }

    //if question answered, check if answered correctly
    if (questionNotifier.isQuestionAnswered(questionNumber)) {
      //get response of question
      final questionRes = questionNotifier.getQuestionResponse(questionNumber);
      final correctOption = widget.question.getCorrectOptionId();

      //if got it correct
      if (questionRes!.isCorrect) {
        //check if this optionid is the selected
        if (optionId == questionRes.selectedOption) {
          return AppColors.successColor;
        }
      }
      //if got wrong
      if (!questionRes.isCorrect) {
        if (optionId == questionRes.selectedOption) {
          return AppColors.failureColor;
        }
        // Color the correct option green
        if (optionId == correctOption) {
          return AppColors.successColor;
        }
      }
    }

    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final verticalPadding = screenSize.height * 0.07; // 7% of screen height

    Color cardColor = Color.lerp(
      AppColors.primaryAccent,
      AppColors.primaryColor,
      widget.visibility,
    )!;

    return Container(
      width: 382,
      height: 543,
      constraints: const BoxConstraints(maxWidth: 382),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: verticalPadding),

          // Question text

          StyledLargeText(widget.question.questionText, AppColors.white),

          // Use Expanded with a Container to center the grid vertically in remaining space
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28), // Equal padding on all sides
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: GridView.builder(
                    itemCount: widget.question.options.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final option = widget.question.options[index];
                      final optionId = option.keys.first;
                      final optionValue = option.values.first;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: () =>
                              _handleOptionSelection(optionId, optionValue),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getOptionColor(
                                  widget.question.questionNumber, optionId),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: StyledOptionsText(
                              optionValue.toString(),
                              AppColors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
