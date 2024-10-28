import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/theme.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.backgroundColor,
    this.textColor,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Full width by default
      height: AppDimensions.buttonHeight, // Fixed height for consistency
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.black,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Fully rounded corners
          ),
          elevation: 0, // No shadow
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20)),
              ),
      ),
    );
  }
}
