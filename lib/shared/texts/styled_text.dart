import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/theme.dart';

class StyledText extends StatelessWidget {
  const StyledText(
    this.text, {
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    super.key,
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.poppins(
        color: color ?? AppColors.textPrimary,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
    );
  }
}

class StyledSmallText extends StatelessWidget {
  const StyledSmallText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? AppColors.textSecondary,
      ),
    );
  }
}

class StyledMediumText extends StatelessWidget {
  const StyledMediumText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

class StyledLargeText extends StatelessWidget {
  const StyledLargeText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

class StyledTitleSmallText extends StatelessWidget {
  const StyledTitleSmallText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

class StyledTitleMediumText extends StatelessWidget {
  const StyledTitleMediumText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

class StyledTitleLargeText extends StatelessWidget {
  const StyledTitleLargeText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

class StyledHeadlineText extends StatelessWidget {
  const StyledHeadlineText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      ),
    );
  }
}

class StyledDisplayText extends StatelessWidget {
  const StyledDisplayText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? AppColors.textPrimary,
        height: 1.1,
      ),
    );
  }
}

class StyledOptionsText extends StatelessWidget {
  const StyledOptionsText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 43,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

// Utility text styles for specific use cases
class StyledCaptionText extends StatelessWidget {
  const StyledCaptionText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.textTertiary,
      ),
    );
  }
}

class StyledLabelText extends StatelessWidget {
  const StyledLabelText(
    this.text, {
    this.color,
    this.fontWeight,
    this.textAlign,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.5,
      ),
    );
  }
}
