import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/theme.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Your Stats',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Stats Section
                _buildOverallStatsSection(),
                SizedBox(height: AppDimensions.spacingL),

                // Performance by Operation Section
                _buildOperationStatsSection(),
                SizedBox(height: AppDimensions.spacingL),

                // Achievement Section
                _buildAchievementSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStatsSection() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Performance',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Questions Answered',
                  value: '247',
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildStatCard(
                  title: 'Overall Accuracy',
                  value: '84%',
                  color: AppColors.successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Practice Sessions',
                  value: '32',
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildStatCard(
                  title: 'Duration Practiced',
                  value: '4h 23m',
                  color: AppColors.warningColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOperationStatsSection() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance by Operation',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.spacingM),
          _buildOperationStat(
            operation: 'Addition (+)',
            correct: 68,
            incorrect: 12,
            accuracy: 85,
          ),
          SizedBox(height: AppDimensions.spacingM),
          _buildOperationStat(
            operation: 'Subtraction (-)',
            correct: 52,
            incorrect: 18,
            accuracy: 74,
          ),
          SizedBox(height: AppDimensions.spacingM),
          _buildOperationStat(
            operation: 'Multiplication (×)',
            correct: 45,
            incorrect: 8,
            accuracy: 85,
          ),
          SizedBox(height: AppDimensions.spacingM),
          _buildOperationStat(
            operation: 'Division (÷)',
            correct: 38,
            incorrect: 14,
            accuracy: 73,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildAchievementBadge(
                  title: 'Perfect Score',
                  subtitle: 'Got 100% in a session',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.warningColor,
                  earned: true,
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildAchievementBadge(
                  title: 'Speed Master',
                  subtitle: 'Answer 10 questions in 1 minute',
                  icon: Icons.flash_on_rounded,
                  color: AppColors.secondaryColor,
                  earned: true,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildAchievementBadge(
                  title: 'Consistency',
                  subtitle: 'Practice 7 days in a row',
                  icon: Icons.calendar_today_rounded,
                  color: AppColors.successColor,
                  earned: false,
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildAchievementBadge(
                  title: 'Math Wizard',
                  subtitle: 'Answer 500 questions correctly',
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.primaryColor,
                  earned: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationStat({
    required String operation,
    required int correct,
    required int incorrect,
    required int accuracy,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              operation,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$accuracy%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: accuracy >= 80
                    ? AppColors.successColor
                    : accuracy >= 60
                        ? AppColors.warningColor
                        : AppColors.errorColor,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spacingXS),
        Row(
          children: [
            Text(
              'Correct: $correct',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.successColor,
              ),
            ),
            SizedBox(width: AppDimensions.spacingM),
            Text(
              'Incorrect: $incorrect',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.errorColor,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spacingS),
        LinearProgressIndicator(
          value: accuracy / 100,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(
            accuracy >= 80
                ? AppColors.successColor
                : accuracy >= 60
                    ? AppColors.warningColor
                    : AppColors.errorColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required int accuracy,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.psychology_rounded,
            size: 20,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$accuracy%',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: accuracy >= 80
                    ? AppColors.successColor
                    : AppColors.warningColor,
              ),
            ),
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementBadge({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool earned,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: earned
            ? color.withOpacity(0.1)
            : AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
        border: Border.all(
          color: earned ? color.withOpacity(0.3) : AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: earned ? color : AppColors.textTertiary,
          ),
          SizedBox(height: AppDimensions.spacingS),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: earned ? AppColors.textPrimary : AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: earned ? AppColors.textSecondary : AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
