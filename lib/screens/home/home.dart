import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numeracy_app/screens/home/multi_selectable_tabs.dart';
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
            padding: const EdgeInsets.all(12.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.go('/questions');
                  },
                  child: Container(
                    height: 124.37,
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.cardRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                                    "Randomize questions from different categories",
                                    AppColors.black)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 120), // Add some spacing
                //question options, tab view
                const MultiSelectableTabs(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
