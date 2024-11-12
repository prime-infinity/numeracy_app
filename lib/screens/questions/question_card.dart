import 'package:flutter/material.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard(this.question,
      {required this.visibility, required this.onAnswerSelected, super.key});

  final Question question;
  final double visibility;
  final void Function(bool isCorrect) onAnswerSelected;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selectedOptionId;
  bool? isCorrect;

  void _handleOptionSelection(String optionId, int answerValue) {
    setState(() {
      selectedOptionId = optionId;
      isCorrect = widget.question.isCorrect(answerValue);
    });
    widget.onAnswerSelected(isCorrect!);
  }

  Color _getOptionColor(String optionId) {
    if (selectedOptionId == null) return AppColors.white;

    if (selectedOptionId == optionId) {
      return isCorrect! ? AppColors.successColor : AppColors.failureColor;
    }

    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final verticalPadding = screenSize.height * 0.07; // 9% of screen height

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
                          onTap: selectedOptionId == null
                              ? () =>
                                  _handleOptionSelection(optionId, optionValue)
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getOptionColor(optionId),
                              borderRadius: BorderRadius.circular(20),
                              border: selectedOptionId == optionId
                                  ? Border.all(
                                      color: isCorrect!
                                          ? AppColors.successBorder
                                          : AppColors.failureBorder,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: StyledOptionsText(
                              optionValue.toString(),
                              selectedOptionId == optionId
                                  ? AppColors.white
                                  : AppColors.black,
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
