import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:numeracy_app/shared/buttons/styled_button.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class CompletionModal extends StatelessWidget {
  const CompletionModal({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.onTryAgain,
    required this.onClose,
    this.isJourneyMode = false,
    this.isJourneyStepCompleted = false,
  });

  final int correctAnswers;
  final int totalQuestions;
  final VoidCallback onTryAgain;
  final VoidCallback onClose;
  final bool isJourneyMode;
  final bool isJourneyStepCompleted;

  @override
  Widget build(BuildContext context) {
    final double accuracy = (correctAnswers / totalQuestions) * 100;
    final bool isPerfectScore = correctAnswers == totalQuestions;
    final bool isGoodScore = accuracy >= 80;
    final bool isJourneyCompleted = isJourneyMode && isJourneyStepCompleted;
    //final bool isGoodJourneyProgress =
    //    isJourneyMode && accuracy >= 90.0 && !isJourneyStepCompleted;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(AppDimensions.spacingL),
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            padding: EdgeInsets.all(AppDimensions.spacingXL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon and Header
                _buildHeader(isPerfectScore, isGoodScore, isJourneyCompleted),
                SizedBox(height: AppDimensions.spacingL),

                // Score Display
                _buildScoreSection(accuracy),
                SizedBox(height: AppDimensions.spacingL),

                // Journey Completion Badge (if applicable)
                if (isJourneyCompleted) ...[
                  _buildJourneyCompletionBadge(),
                  SizedBox(height: AppDimensions.spacingL),
                ],

                // Performance Message
                _buildPerformanceMessage(
                    isPerfectScore, isGoodScore, accuracy, isJourneyCompleted),
                SizedBox(height: AppDimensions.spacingXL),

                // Action Buttons
                _buildActionButtons(isJourneyCompleted, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      bool isPerfectScore, bool isGoodScore, bool isJourneyCompleted) {
    IconData iconData;
    Color iconColor;
    String title;

    if (isJourneyCompleted) {
      iconData = Icons.star_rounded;
      iconColor = AppColors.warningColor;
      title = 'Journey Step Completed!';
    } else if (isPerfectScore) {
      iconData = Icons.emoji_events_rounded;
      iconColor = AppColors.warningColor;
      title = 'Perfect Score!';
    } else if (isGoodScore) {
      iconData = Icons.check_circle_rounded;
      iconColor = AppColors.successColor;
      title = 'Great Job!';
    } else {
      iconData = Icons.trending_up_rounded;
      iconColor = AppColors.primaryColor;
      title = 'Keep Practicing!';
    }

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            iconData,
            size: 40,
            color: iconColor,
          ),
        ),
        SizedBox(height: AppDimensions.spacingM),
        StyledHeadlineText(
          title,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScoreSection(double accuracy) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.primaryAccent,
        borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Main Score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                correctAnswers.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  height: 1.0,
                ),
              ),
              Text(
                '/$totalQuestions',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingS),

          // Accuracy Percentage
          Text(
            '${accuracy.toStringAsFixed(0)}% Accuracy',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCompletionBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
        vertical: AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warningColor.withOpacity(0.1),
            AppColors.successColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
        border: Border.all(
          color: AppColors.warningColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.military_tech_rounded,
            color: AppColors.warningColor,
            size: 24,
          ),
          SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Journey Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warningColor,
                  ),
                ),
                Text(
                  'You\'ve unlocked the next challenge!',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMessage(bool isPerfectScore, bool isGoodScore,
      double accuracy, bool isJourneyCompleted) {
    String message;

    if (isJourneyCompleted) {
      message =
          'Congratulations! You\'ve completed this journey step with 90%+ accuracy and enough practice attempts. Ready for the next challenge?';
    } else if (isJourneyMode && accuracy >= 90.0) {
      message =
          'Great job! You scored 90%+ accuracy. Keep practicing to build consistency and complete this journey step!';
    } else if (isPerfectScore) {
      message =
          'Outstanding! You got every question right. Your math skills are on fire! 🔥';
    } else if (isGoodScore) {
      message =
          'Excellent work! You\'re showing great improvement in your math skills.';
    } else if (accuracy >= 60) {
      message = isJourneyMode
          ? 'Good effort! You need 90% accuracy with consistent practice to complete this journey step. Keep going!'
          : 'Good effort! With more practice, you\'ll master these concepts.';
    } else {
      message = isJourneyMode
          ? 'Don\'t give up! Practice more to reach 90% accuracy and complete this journey step.'
          : 'Don\'t give up! Every practice session makes you stronger. Keep going!';
    }

    return StyledMediumText(
      message,
      textAlign: TextAlign.center,
      color: AppColors.textSecondary,
    );
  }

  Widget _buildActionButtons(bool isJourneyCompleted, BuildContext context) {
    return Column(
      children: [
        // Primary Action - Try Again or Continue Journey
        StyledButton(
          text: isJourneyMode && isJourneyCompleted
              ? 'Continue Journey'
              : 'Practice Again',
          onPressed: isJourneyMode && isJourneyCompleted
              ? () => context.go('/journey')
              : onTryAgain,
          width: double.infinity,
          icon: isJourneyMode
              ? Icons.arrow_forward_rounded
              : Icons.refresh_rounded,
        ),

        // Secondary Action - Review or End Session (only show if NOT a completed journey)
        if (!isJourneyCompleted) ...[
          SizedBox(height: AppDimensions.spacingM),
          StyledButton(
            text: 'Review Answers',
            onPressed: onClose,
            width: double.infinity,
            icon: Icons.remove_red_eye,
          ),
        ],
      ],
    );
  }
}
