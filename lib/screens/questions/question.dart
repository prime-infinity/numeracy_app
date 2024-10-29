import 'package:flutter/material.dart';
import 'package:numeracy_app/models/question.dart';
import 'package:numeracy_app/screens/questions/question_card.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("questions"),
      ),
      body: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  // Constrain the size of the card
                  width: 382,
                  height: 543,
                  child: QuestionCard(questions[index]),
                ),
              ),
            );
          }),
    );
  }
}
