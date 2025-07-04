import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:numeracy_app/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late PageController _pageController;
  int _currentPage = 0;

  final List<FeatureData> _features = [
    FeatureData(
      icon: Icons.flash_on_rounded,
      title: 'Quick Practice',
      description: 'Jump into random math problems for instant brain training',
      color: AppColors.primaryColor,
    ),
    FeatureData(
      icon: Icons.tune_rounded,
      title: 'Custom Workouts',
      description:
          'Tailor your practice with specific operations and difficulty levels',
      color: AppColors.secondaryColor,
    ),
    FeatureData(
      icon: Icons.route_rounded,
      title: 'Math Journey',
      description:
          'Embark on a structured path to master all mathematical operations',
      color: AppColors.primaryColor.withOpacity(0.8),
    ),
    FeatureData(
      icon: Icons.trending_up_rounded,
      title: 'Track Progress',
      description: 'Monitor your improvement and build mathematical confidence',
      color: AppColors.successColor,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _features.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            children: [
              // Header - App Logo and Name
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.calculate_rounded,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingL),
                      Text(
                        'Numeracy',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingXS),
                      Text(
                        'Master Mental Math',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.spacingXL),

              // Feature Cards Carousel
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Feature Card
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: _features.length,
                          itemBuilder: (context, index) {
                            return _buildFeatureCard(_features[index]);
                          },
                        ),
                      ),

                      SizedBox(height: AppDimensions.spacingL),

                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _features.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingXS / 2,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? AppColors.primaryColor
                                  : AppColors.primaryColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.spacingXL),

              // Navigation Buttons
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Row(
                    children: [
                      // Previous Button
                      if (_currentPage > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousPage,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryColor,
                              side: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.containerRadius,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimensions.spacingM,
                              ),
                            ),
                            child: Text(
                              'Previous',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                      if (_currentPage > 0)
                        SizedBox(width: AppDimensions.spacingM),

                      // Next/Get Started Button
                      Expanded(
                        flex: _currentPage == 0 ? 1 : 1,
                        child: ElevatedButton(
                          onPressed: _currentPage < _features.length - 1
                              ? _nextPage
                              : () => context.go('/home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor:
                                AppColors.primaryColor.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.containerRadius,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimensions.spacingM,
                            ),
                          ),
                          child: Text(
                            _currentPage < _features.length - 1
                                ? 'Next'
                                : 'Get Started',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.spacingM),

              // Skip Button
              if (_currentPage < _features.length - 1)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: TextButton(
                    onPressed: () => context.go('/home'),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(FeatureData feature) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Feature Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              feature.icon,
              color: feature.color,
              size: 40,
            ),
          ),

          SizedBox(height: AppDimensions.spacingL),

          // Feature Title
          Text(
            feature.title,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.spacingM),

          // Feature Description
          Text(
            feature.description,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
