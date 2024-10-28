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
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              // Question number
              StyledSmallText('Question $questionNumber'),
              // Question text
              StyledLargeText(question),
              // Grid of options
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 27.97),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10.23,
                  crossAxisSpacing: 10.23,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      child: const StyledOptionsText("15"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.successColor,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      child: const StyledOptionsText("9"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.failureColor,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      child: const StyledOptionsText("81"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      child: const StyledOptionsText("91"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
