import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/theme.dart';

enum ButtonStyle { primary, secondary, outline, text }

enum ButtonSize { small, medium, large }

class StyledButton extends StatelessWidget {
  const StyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.style = ButtonStyle.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final ButtonStyle style;
  final ButtonSize size;
  final IconData? icon;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? _getButtonHeight();
    final fontSize = _getFontSize();
    final padding = _getPadding();
    final borderRadius = _getBorderRadius();

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: (isLoading || isDisabled) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          disabledBackgroundColor: _getDisabledBackgroundColor(),
          disabledForegroundColor: _getDisabledForegroundColor(),
          elevation: _getElevation(),
          shadowColor: _getShadowColor(),
          side: _getBorderSide(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
        ),
        child: isLoading
            ? SizedBox(
                width: fontSize,
                height: fontSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(),
                  ),
                ),
              )
            : _buildButtonContent(fontSize),
      ),
    );
  }

  Widget _buildButtonContent(double fontSize) {
    if (icon == null) {
      return Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      );
    }

    final iconWidget = Icon(icon, size: fontSize + 2);
    final textWidget = Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconPosition == IconPosition.left
          ? [
              iconWidget,
              SizedBox(width: AppDimensions.spacingS),
              textWidget,
            ]
          : [
              textWidget,
              SizedBox(width: AppDimensions.spacingS),
              iconWidget,
            ],
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return AppDimensions.buttonHeight;
      case ButtonSize.large:
        return 64;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        );
      case ButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingM,
        );
      case ButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXL,
          vertical: AppDimensions.spacingM,
        );
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return 8;
      case ButtonSize.medium:
        return AppDimensions.containerRadius.toDouble();
      case ButtonSize.large:
        return 16;
    }
  }

  Color _getBackgroundColor() {
    switch (style) {
      case ButtonStyle.primary:
        return AppColors.primaryColor;
      case ButtonStyle.secondary:
        return AppColors.secondaryColor;
      case ButtonStyle.outline:
        return Colors.transparent;
      case ButtonStyle.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (style) {
      case ButtonStyle.primary:
      case ButtonStyle.secondary:
        return Colors.white;
      case ButtonStyle.outline:
        return AppColors.primaryColor;
      case ButtonStyle.text:
        return AppColors.primaryColor;
    }
  }

  Color _getDisabledBackgroundColor() {
    switch (style) {
      case ButtonStyle.primary:
      case ButtonStyle.secondary:
        return AppColors.surfaceVariant;
      case ButtonStyle.outline:
      case ButtonStyle.text:
        return Colors.transparent;
    }
  }

  Color _getDisabledForegroundColor() {
    return AppColors.textTertiary;
  }

  double _getElevation() {
    switch (style) {
      case ButtonStyle.primary:
      case ButtonStyle.secondary:
        return 0;
      case ButtonStyle.outline:
      case ButtonStyle.text:
        return 0;
    }
  }

  Color? _getShadowColor() {
    switch (style) {
      case ButtonStyle.primary:
        return AppColors.primaryColor.withOpacity(0.3);
      case ButtonStyle.secondary:
        return AppColors.secondaryColor.withOpacity(0.3);
      case ButtonStyle.outline:
      case ButtonStyle.text:
        return null;
    }
  }

  BorderSide? _getBorderSide() {
    switch (style) {
      case ButtonStyle.outline:
        return BorderSide(
          color: isDisabled ? AppColors.borderColor : AppColors.primaryColor,
          width: 1.5,
        );
      case ButtonStyle.primary:
      case ButtonStyle.secondary:
      case ButtonStyle.text:
        return null;
    }
  }
}

// Icon button variant
class StyledIconButton extends StatelessWidget {
  const StyledIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = ButtonSize.medium,
    this.style = ButtonStyle.primary,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonSize size;
  final ButtonStyle style;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final buttonSize = _getButtonSize();
    final iconSize = _getIconSize();

    final button = SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        onPressed: (isLoading || isDisabled) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          disabledBackgroundColor: AppColors.surfaceVariant,
          disabledForegroundColor: AppColors.textTertiary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonSize / 2),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: iconSize - 4,
                height: iconSize - 4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(),
                  ),
                ),
              )
            : Icon(icon, size: iconSize),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  double _getButtonSize() {
    switch (size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 48;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  Color _getBackgroundColor() {
    switch (style) {
      case ButtonStyle.primary:
        return AppColors.primaryColor;
      case ButtonStyle.secondary:
        return AppColors.secondaryColor;
      case ButtonStyle.outline:
        return AppColors.surface;
      case ButtonStyle.text:
        return AppColors.surfaceVariant;
    }
  }

  Color _getForegroundColor() {
    switch (style) {
      case ButtonStyle.primary:
      case ButtonStyle.secondary:
        return Colors.white;
      case ButtonStyle.outline:
      case ButtonStyle.text:
        return AppColors.primaryColor;
    }
  }
}

enum IconPosition { left, right }
