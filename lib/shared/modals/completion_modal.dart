import 'package:flutter/material.dart';
import 'package:numeracy_app/shared/buttons/styled_button.dart';

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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: screenHeight * 0.8,
        width: screenWidth * 0.9,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '5/10',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Soften your surroundings with the round embrace and classic look of...',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            StyledButton(
              onPressed: onTryAgain,
              text: 'Start Again',
            ),
            const SizedBox(height: 16.0),
            StyledButton(
              onPressed: onClose,
              text: 'End',
            ),
          ],
        ),
      ),
    );
  }
}
