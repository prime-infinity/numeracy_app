import 'package:flutter/material.dart';
import 'package:numeracy_app/screens/categories/category.dart';
import 'package:numeracy_app/screens/questions/question.dart';
import 'package:numeracy_app/theme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: PageView(
        children: const [Category(), Question()],
      ),
    );
  }
}
