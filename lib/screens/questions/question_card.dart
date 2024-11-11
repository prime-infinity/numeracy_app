import 'package:flutter/material.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard(this.question, {required this.visibility, super.key});

  final Question question;
  final double visibility;

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
    //widget.onAnswerSelected(isCorrect!);
  }

  Color _getOptionColor(String optionId) {
    if (selectedOptionId == null) return AppColors.white;

    if (selectedOptionId == optionId) {
      return isCorrect!
          ? AppColors.successColor // You'll need to add this to your theme
          : AppColors.failureColor; // You'll need to add this to your theme
    }

    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    // Interpolate between the two colors based on visibility
    Color cardColor = Color.lerp(
      AppColors.primaryAccent,
      AppColors.primaryColor,
      widget.visibility,
    )!;

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: 382,
        constraints: const BoxConstraints(maxWidth: 382),
        decoration: BoxDecoration(
          color: cardColor, // Purple background like in the image
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 36),
            // Question number
            StyledSmallText(
                'Question ${widget.question.questionNumber}', AppColors.white),
            // // Question text using the formatted question string
            StyledLargeText(widget.question.questionText, AppColors.white),
            // Grid of options
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 27.97, vertical: 40),
              child: GridView.builder(
                itemCount: widget.question.options.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.23,
                  crossAxisSpacing: 10.23,
                ),
                itemBuilder: (context, index) {
                  final option = widget.question.options[index];
                  final optionId = option.keys.first;
                  final optionValue = option.values.first;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: selectedOptionId == null
                          ? () => _handleOptionSelection(optionId, optionValue)
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getOptionColor(optionId),
                          borderRadius: BorderRadius.circular(20),
                          border: selectedOptionId == optionId
                              ? Border.all(
                                  color: isCorrect!
                                      ? AppColors.successBorder // Add to theme
                                      : AppColors.failureBorder, // Add to theme
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
          ],
        ),
      );
    });
  }
}
