import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/services/stats_service.dart';
import 'package:numeracy_app/theme.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool _isLoading = true;

  // Stats data
  int _totalAttempts = 0;
  double _overallAccuracy = 0.0;
  int _totalCorrect = 0;
  int _currentStreak = 0;
  int _bestStreak = 0;

  // Operation stats
  Map<String, Map<String, dynamic>> _operationStats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    setState(() {
      _isLoading = true;
    });

    // Load overall stats
    _totalAttempts = StatsService.getTotalAttempts();
    _overallAccuracy = StatsService.getOverallAccuracy();
    _totalCorrect = StatsService.getTotalCorrect();
    _currentStreak = StatsService.getCurrentStreak();
    _bestStreak = StatsService.getBestStreak();

    // Load operation-specific stats
    final operations = [
      'addition',
      'subtraction',
      'multiplication',
      'division'
    ];
    for (String operation in operations) {
      final attempts = StatsService.getAttemptsByOperation(operation);
      final correct = attempts.where((a) => a.result == 1).length;
      final incorrect = attempts.length - correct;
      final accuracy = StatsService.getAccuracyByOperation(operation);

      _operationStats[operation] = {
        'correct': correct,
        'incorrect': incorrect,
        'accuracy': accuracy,
        'total': attempts.length,
      };
    }

    setState(() {
      _isLoading = false;
    });
  }

  String _formatDuration(int totalAttempts) {
    // Estimate: average 30 seconds per question
    final totalSeconds = totalAttempts * 30;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String _getOperationDisplayName(String operation) {
    switch (operation) {
      case 'addition':
        return 'Addition (+)';
      case 'subtraction':
        return 'Subtraction (−)';
      case 'multiplication':
        return 'Multiplication (×)';
      case 'division':
        return 'Division (÷)';
      default:
        return operation;
    }
  }

  // Simple achievement logic
  bool _hasAchievement(String achievement) {
    switch (achievement) {
      case 'perfect_score':
        // Check if user ever got 100% in a session (simplified)
        return _overallAccuracy >= 90; // Approximate check
      case 'speed_master':
        // If user has answered many questions, assume they've been fast
        return _totalAttempts >= 50;
      case 'consistency':
        // Check if user has practiced recently (simplified)
        final todayAttempts = StatsService.getTodayAttempts();
        final weekAttempts = StatsService.getWeekAttempts();
        return weekAttempts.length >= 20; // Approximation
      case 'math_wizard':
        return _totalCorrect >= 500;
      default:
        return false;
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadStats,
            tooltip: 'Refresh Stats',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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

                      // Streak Section
                      _buildStreakSection(),
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
                  value: _totalAttempts.toString(),
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildStatCard(
                  title: 'Overall Accuracy',
                  value: '${_overallAccuracy.toStringAsFixed(0)}%',
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
                  title: 'Correct Answers',
                  value: _totalCorrect.toString(),
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildStatCard(
                  title: 'Time Practiced',
                  value: _formatDuration(_totalAttempts),
                  color: AppColors.warningColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection() {
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
            'Streaks',
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
                  title: 'Current Streak',
                  value: _currentStreak.toString(),
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildStatCard(
                  title: 'Best Streak',
                  value: _bestStreak.toString(),
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
    // Check if there are any operations with attempts
    bool hasData = _operationStats.values.any((stats) => stats['total'] > 0);

    if (!hasData) {
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
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppDimensions.spacingM),
            Text(
              'No practice data yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Start practicing to see your performance by operation',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

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
          ..._operationStats.entries.map((entry) {
            final operation = entry.key;
            final stats = entry.value;

            if (stats['total'] == 0) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
              child: _buildOperationStat(
                operation: _getOperationDisplayName(operation),
                correct: stats['correct'],
                incorrect: stats['incorrect'],
                accuracy: stats['accuracy'].round(),
              ),
            );
          }).toList(),
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
                  subtitle: 'Get 90%+ accuracy',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.warningColor,
                  earned: _hasAchievement('perfect_score'),
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildAchievementBadge(
                  title: 'Speed Master',
                  subtitle: 'Answer 50+ questions',
                  icon: Icons.flash_on_rounded,
                  color: AppColors.secondaryColor,
                  earned: _hasAchievement('speed_master'),
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
                  subtitle: 'Practice regularly',
                  icon: Icons.calendar_today_rounded,
                  color: AppColors.successColor,
                  earned: _hasAchievement('consistency'),
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildAchievementBadge(
                  title: 'Math Wizard',
                  subtitle: 'Answer 500 questions correctly',
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.primaryColor,
                  earned: _hasAchievement('math_wizard'),
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
