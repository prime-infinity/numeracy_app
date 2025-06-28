import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
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
  final Map<String, Map<String, dynamic>> _operationStats = {};

  // Difficulty stats
  final Map<String, Map<String, dynamic>> _difficultyStats = {};

  // NEW: Accuracy over time data
  List<AccuracyDataPoint> _accuracyData = [];
  String _selectedTimeRange = 'Last 7 Days'; // Default time range

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

    // Load difficulty-specific stats
    final difficulties = ['a', 'b', 'c']; // easy, medium, hard
    for (String difficulty in difficulties) {
      final attempts = StatsService.getAttemptsByDifficulty(difficulty);
      final correct = attempts.where((a) => a.result == 1).length;
      final incorrect = attempts.length - correct;
      final accuracy = StatsService.getAccuracyByDifficulty(difficulty);

      _difficultyStats[difficulty] = {
        'correct': correct,
        'incorrect': incorrect,
        'accuracy': accuracy,
        'total': attempts.length,
      };
    }

    // NEW: Load accuracy over time data
    _loadAccuracyData();

    setState(() {
      _isLoading = false;
    });
  }

  void _loadAccuracyData() {
    switch (_selectedTimeRange) {
      case 'Last 7 Days':
        _accuracyData = StatsService.getAccuracyOverTime(daysBack: 7);
        break;
      case 'Last 30 Days':
        _accuracyData = StatsService.getAccuracyOverTime(daysBack: 30);
        break;
      case 'Last 3 Months':
        _accuracyData = StatsService.getWeeklyAccuracyAverages(weeksBack: 12);
        break;
      case 'All Time':
        _accuracyData = StatsService.getWeeklyAccuracyAverages();
        break;
    }
  }

  void _onTimeRangeChanged(String? newRange) {
    if (newRange != null && newRange != _selectedTimeRange) {
      setState(() {
        _selectedTimeRange = newRange;
        _loadAccuracyData();
      });
    }
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

  String _getDifficultyDisplayName(String difficulty) {
    switch (difficulty) {
      case 'a':
        return 'Easy (A)';
      case 'b':
        return 'Medium (B)';
      case 'c':
        return 'Hard (C)';
      default:
        return difficulty.toUpperCase();
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

                      // NEW: Accuracy Graph Section
                      _buildAccuracyGraphSection(),
                      SizedBox(height: AppDimensions.spacingL),

                      // Performance by Operation Section
                      _buildOperationStatsSection(),
                      SizedBox(height: AppDimensions.spacingL),

                      // Performance by Difficulty Section
                      _buildDifficultyStatsSection(),
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

  // NEW: Build accuracy graph section
  Widget _buildAccuracyGraphSection() {
    if (_accuracyData.isEmpty) {
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
              Icons.show_chart_rounded,
              size: 48,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppDimensions.spacingM),
            Text(
              'No progress data yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Practice more to see your accuracy progress over time',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Accuracy Progress',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              DropdownButton<String>(
                value: _selectedTimeRange,
                onChanged: _onTimeRangeChanged,
                items: [
                  'Last 7 Days',
                  'Last 30 Days',
                  'Last 3 Months',
                  'All Time'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
                underline: Container(),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingM),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.borderColor.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _getBottomInterval(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _accuracyData.length) {
                          final date = _accuracyData[index].date;
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              _selectedTimeRange.contains('Days')
                                  ? '${date.day}/${date.month}'
                                  : '${date.day}/${date.month}',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                  ),
                ),
                minX: 0,
                maxX: (_accuracyData.length - 1).toDouble(),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: _accuracyData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.accuracy,
                      );
                    }).toList(),
                    isCurved: true,
                    color: AppColors.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primaryColor,
                          strokeWidth: 2,
                          strokeColor: AppColors.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final dataPoint = _accuracyData[barSpot.x.toInt()];
                        return LineTooltipItem(
                          '${dataPoint.accuracy.toStringAsFixed(1)}%\n'
                          '${dataPoint.correctAnswers}/${dataPoint.totalQuestions} correct\n'
                          '${dataPoint.date.day}/${dataPoint.date.month}',
                          GoogleFonts.poppins(
                            color: AppColors.surface,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacingM),
          if (_accuracyData.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGraphStat(
                  'Highest',
                  '${_accuracyData.map((d) => d.accuracy).reduce((a, b) => a > b ? a : b).toStringAsFixed(1)}%',
                  AppColors.successColor,
                ),
                _buildGraphStat(
                  'Average',
                  '${(_accuracyData.map((d) => d.accuracy).reduce((a, b) => a + b) / _accuracyData.length).toStringAsFixed(1)}%',
                  AppColors.primaryColor,
                ),
                _buildGraphStat(
                  'Latest',
                  '${_accuracyData.last.accuracy.toStringAsFixed(1)}%',
                  AppColors.secondaryColor,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  double _getBottomInterval() {
    if (_accuracyData.length <= 7) return 1;
    if (_accuracyData.length <= 14) return 2;
    if (_accuracyData.length <= 30) return 5;
    return (_accuracyData.length / 6).ceilToDouble();
  }

  Widget _buildGraphStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
      ],
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
          }),
        ],
      ),
    );
  }

  Widget _buildDifficultyStatsSection() {
    // Check if there are any difficulties with attempts
    bool hasData = _difficultyStats.values.any((stats) => stats['total'] > 0);

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
              Icons.trending_up_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppDimensions.spacingM),
            Text(
              'No difficulty data yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Start practicing to see your performance by difficulty level',
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
            'Performance by Difficulty',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.spacingM),
          ..._difficultyStats.entries.map((entry) {
            final difficulty = entry.key;
            final stats = entry.value;

            if (stats['total'] == 0) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
              child: _buildOperationStat(
                operation: _getDifficultyDisplayName(difficulty),
                correct: stats['correct'],
                incorrect: stats['incorrect'],
                accuracy: stats['accuracy'].round(),
              ),
            );
          }),
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
