import 'package:flutter/material.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class StyledPill extends StatelessWidget {
  const StyledPill({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(Object context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.primaryAccent,
          borderRadius: BorderRadius.circular(15)),
      child: StyledTitleSmallText(
        text,
        AppColors.primaryColor,
      ),
    );
  }
}
