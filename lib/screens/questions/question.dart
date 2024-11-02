import 'package:flutter/material.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/screens/questions/question_card.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final _pageController = PageController(
    viewportFraction: 0.95,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("questions"),
      ),
      body: Center(
        child: SizedBox(
          height: 543,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5.0), // Add spacing between cards
                child: QuestionCard(questions[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
