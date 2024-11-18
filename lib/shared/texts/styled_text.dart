import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledSmallText extends StatelessWidget {
  const StyledSmallText(this.text, this.color, {super.key});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodyMedium, color: color),
    );
  }
}

class StyledLargeText extends StatelessWidget {
  const StyledLargeText(this.text, this.color, {super.key});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodyLarge, color: color),
    );
  }
}

class StyledOptionsText extends StatelessWidget {
  const StyledOptionsText(this.text, this.color, {super.key});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 43, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
