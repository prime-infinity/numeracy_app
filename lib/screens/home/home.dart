import 'package:flutter/material.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      /*appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),*/
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 124.37,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.cardRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16)),
                          child: Icon(
                            Icons.shuffle,
                            size: 24,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledTitleSmallText(
                                  "Random Questions", AppColors.black),
                              StyledSmallText(
                                  "Enhance your mental agility and problem-solving skills throug",
                                  AppColors.black)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Add some spacing
                //question options, horizontal list
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCard(
                          title: 'Addition Questions',
                          description:
                              'Enhance your mental agility and problem-solving skills through addition exercises.',
                        ),
                        const SizedBox(width: 5),
                        _buildCard(
                          title: 'Subtraction Questions',
                          description:
                              'Enhance your mental agility and problem-solving skills through subtraction exercises.',
                        ),
                        const SizedBox(width: 5),
                        _buildCard(
                          title: 'Multiplication Questions',
                          description:
                              'Enhance your mental agility and problem-solving skills through multiplication exercises.',
                        ),
                        const SizedBox(width: 5),
                        _buildCard(
                          title: 'Division Questions',
                          description:
                              'Enhance your mental agility and problem-solving skills through division exercises.',
                        ),
                        const SizedBox(width: 5),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String description}) {
    return Container(
      width: 168,
      height: 168,
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.add,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
