import 'package:flutter/material.dart';
import 'package:numeracy_app/shared/buttons/styled_button.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class CompletionModal extends StatelessWidget {
  const CompletionModal({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.onTryAgain,
    required this.onClose,
  });

  final int correctAnswers;
  final int totalQuestions;
  final VoidCallback onTryAgain;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: screenHeight * 0.65,
          width: screenWidth * 0.94,
          //margin: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          padding: const EdgeInsets.all(70.0),
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledLargeText(
                  "$correctAnswers/$totalQuestions", AppColors.black),
              const SizedBox(height: 36.0),
              StyledButton(
                onPressed: onClose,
                text: 'End',
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
              ),
              const SizedBox(height: 25.0),
              StyledButton(
                onPressed: onTryAgain,
                text: 'Start Again',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
