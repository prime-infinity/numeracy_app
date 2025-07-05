// screens/journey/journey_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/models/journey.dart';
import 'package:numeracy_app/services/journey_service.dart';
import 'package:numeracy_app/theme.dart';

final journeyProvider = FutureProvider<Journey>((ref) async {
  return await JourneyService.getCurrentJourney();
});

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyAsync = ref.watch(journeyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Math Journey',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(journeyProvider);
            },
            tooltip: 'Refresh Progress',
          ),
        ],
      ),
      body: journeyAsync.when(
        data: (journey) => _buildJourneyContent(context, journey),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.errorColor,
              ),
              SizedBox(height: AppDimensions.spacingM),
              Text(
                'Failed to load journey',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppDimensions.spacingS),
              Text(
                'Please try again',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJourneyContent(BuildContext context, Journey journey) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Journey Progress Header
            _buildProgressHeader(journey),
            SizedBox(height: AppDimensions.spacingL),

            // Journey Steps
            _buildJourneySteps(context, journey),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(Journey journey) {
    final completedSteps =
        journey.steps.where((step) => step.isCompleted).length;
    final progress = completedSteps / journey.totalSteps;

    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Journey Progress',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.chipRadius),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingM),
          Text(
            '$completedSteps of ${journey.totalSteps} steps completed',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: AppDimensions.spacingM),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneySteps(BuildContext context, Journey journey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Journey',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.spacingM),
        ...journey.steps.map((step) => _buildStepCard(context, step)),
      ],
    );
  }

  Widget _buildStepCard(BuildContext context, JourneyStep step) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: GestureDetector(
        onTap: step.isUnlocked ? () => _navigateToStep(context, step) : null,
        child: Container(
          padding: EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color:
                step.isUnlocked ? AppColors.surface : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(
              color: step.isCompleted
                  ? AppColors.successColor
                  : step.isUnlocked
                      ? AppColors.primaryColor.withOpacity(0.3)
                      : AppColors.borderColor,
              width: step.isCompleted ? 2 : 1,
            ),
            boxShadow: step.isUnlocked
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Step Number/Status Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: step.isCompleted
                      ? AppColors.successColor
                      : step.isUnlocked
                          ? AppColors.primaryColor
                          : AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: step.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 24,
                        )
                      : step.isUnlocked
                          ? Text(
                              step.stepNumber.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),

              // Step Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: step.isUnlocked
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingXS),
                    Text(
                      step.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (step.accuracy != null &&
                        step.totalAttempts != null) ...[
                      SizedBox(height: AppDimensions.spacingXS),
                      Text(
                        'Accuracy: ${step.accuracy!.toStringAsFixed(1)}% (${step.totalAttempts} attempts)',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: step.accuracy! >= 90.0
                              ? AppColors.successColor
                              : AppColors.warningColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow or Progress Indicator
              if (step.isUnlocked) ...[
                if (step.isCompleted)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingS,
                      vertical: AppDimensions.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.chipRadius),
                    ),
                    child: Text(
                      'Completed',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.successColor,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primaryColor,
                    size: 16,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToStep(BuildContext context, JourneyStep step) {
    context.go(
        '/questions?range=${step.difficulty.code}&operations=${step.operation.name}&journey=true');
  }
}
