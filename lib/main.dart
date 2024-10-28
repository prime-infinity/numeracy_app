import 'package:flutter/material.dart';
import 'package:numeracy_app/screens/questions/question_card.dart';
import 'package:numeracy_app/shared/buttons/styled_button.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

void main() {
  runApp(MaterialApp(
    theme: primaryTheme,
    home: QuestionCard(
      questionNumber: '14',
      question: '5+4',
      options: const ['15', '9', '81', '91'],
    ),
  ));
}

class Sandbox extends StatelessWidget {
  const Sandbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const StyledSmallText("normal text"),
            StyledButton(
                text: "save",
                onPressed: () {
                  print('Save button pressed');
                }),
            // With custom width and colors:
            StyledButton(
              text: "Delete",
              width: 200, // Specific width in pixels
              backgroundColor: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                print('Delete button pressed');
              },
            ),
            // With loading state:
            StyledButton(
              text: "Loading Example",
              isLoading: true, // Shows loading spinner instead of text
              onPressed: () {
                print('Button pressed');
              },
            ),
            StyledButton(
                text: "Primary button",
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  print("primary button clicked");
                }),
          ],
        ),
      ),
    );
  }
}
