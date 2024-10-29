import 'package:flutter/material.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard(this.question, {super.key});

  final Question question;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 382,
      //height: 543,
      //padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor, // Purple background like in the image
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 35),
          // Question number
          StyledSmallText('Question ${widget.question.questionNumber}'),
          // Question text
          StyledLargeText(widget.question.question),
          // Grid of options
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 27.97, vertical: 39),
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
                return GestureDetector(
                  onTap: () {
                    // Handle option selection
                    print('Selected option: ${option['id']}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: StyledOptionsText(option['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
