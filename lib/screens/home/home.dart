import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numeracy_app/screens/home/daily_streak.dart';
import 'package:numeracy_app/screens/home/multi_selectable_tabs.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StyledMediumText("Hi", AppColors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledTitleMediumText(
                            "Let's Begin Solving", AppColors.black),
                        Image.asset(
                          'assets/icons/profileimg.png',
                          width: 38,
                          height: 38,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),

                const DailyStreak(),
                const SizedBox(height: 20),
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
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                color: AppColors.black,
                                borderRadius: BorderRadius.circular(16)),
                            child: Icon(
                              Icons.shuffle,
                              size: 24,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StyledMediumText(
                                    "Quick Practice", AppColors.black,
                                    isBold: true),
                                StyledSmallText(
                                    "Quicky practice random questions",
                                    AppColors.black)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Add some spacing

                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 22),
                    decoration: BoxDecoration(
                        color: AppColors.cardGrey,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.cardRadius)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledMediumText("Custom Practice", AppColors.black,
                            isBold: true),
                        StyledSmallText("Boost your skills with a custom quiz",
                            AppColors.black),
                        const SizedBox(height: 30),
                        StyledSmallText("1: Select Category", AppColors.black),
                        const SizedBox(height: 5),
                        const MultiSelectableTabs(),
                      ],
                    )),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
