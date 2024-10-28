import 'package:flutter/material.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.options,
  }) : assert(options.length == 4);

  final String questionNumber;
  final String question;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 382,
          height: 543,
          //padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:
                AppColors.primaryColor, // Purple background like in the image
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Question number
              StyledSmallText('Question $questionNumber'),
              const SizedBox(height: 8),

              // Question text
              StyledLargeText(question),
              const SizedBox(height: 20),

              // Grid of options
            ],
          ),
        ),
      ),
    );
  }
}
