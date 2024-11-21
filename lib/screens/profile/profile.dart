import 'package:flutter/material.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 382,
              height: 185,
              decoration: BoxDecoration(
                  color: AppColors.cardGrey,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.cardRadius)),
              child: const Icon(
                Icons.account_circle_rounded,
                size: 150,
              ),
            ),
            const SizedBox(height: 30),
            StyledMediumText("Name?", AppColors.black),
            StyledMediumText("Username?", AppColors.black),
            StyledMediumText("Change Passsword?", AppColors.black),
            StyledMediumText("Joined January 2021", AppColors.black),
            const SizedBox(height: 30),
            Container(
              height: 81,
              width: 379,
              decoration: BoxDecoration(
                  color: AppColors.cardGrey,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.cardRadius)),
              alignment: Alignment.center,
              child: StyledMediumText(
                  "You have answered 175 questions !", AppColors.black),
            ),
            const SizedBox(height: 30),
            StyledTitleMediumText("Statistics", AppColors.black),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.cardGrey,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.cardRadius)),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.cardGrey,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.cardRadius)),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.cardGrey,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.cardRadius)),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.cardGrey,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.cardRadius)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
