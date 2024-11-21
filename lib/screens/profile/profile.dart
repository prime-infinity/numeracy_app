import 'package:flutter/material.dart';
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
