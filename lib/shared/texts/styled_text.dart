import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/theme.dart';

class StyledSmallText extends StatelessWidget {
  const StyledSmallText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class StyledLargeText extends StatelessWidget {
  const StyledLargeText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

class StyledOptionsText extends StatelessWidget {
  const StyledOptionsText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 43,
              fontWeight: FontWeight.w600,
              color: AppColors.black)),
    );
  }
}
