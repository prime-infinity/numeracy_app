import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/screens/home/animated_tab_button.dart';
import 'package:numeracy_app/theme.dart';
import 'package:go_router/go_router.dart';

class MultiSelectableTabs extends StatefulWidget {
  final Function(bool) onOperationSelected;
  final VoidCallback onDifficultySelected;
  final VoidCallback onStartPractice;

  const MultiSelectableTabs({
    super.key,
    required this.onOperationSelected,
    required this.onDifficultySelected,
    required this.onStartPractice,
  });

  @override
  MultiSelectableTabsState createState() => MultiSelectableTabsState();
}

class MultiSelectableTabsState extends State<MultiSelectableTabs> {
  // Track selected tabs
  final List<bool> _selectedTabs = [false, false, false, false];
  String _selectedRange = ''; // Start with no selection
  bool _isStarting = false; // Track if we're in the starting animation

  // Tab data with corresponding operations
  final List<Map<String, dynamic>> _tabs = [
    {'icon': '+', 'operation': Operation.addition},
    {'icon': '−', 'operation': Operation.subtraction},
    {'icon': '×', 'operation': Operation.multiplication},
    {'icon': '÷', 'operation': Operation.division},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Operations Selection - Horizontal Scrollable
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: AppDimensions.spacingM),
            itemBuilder: (context, index) => _buildTab(index),
          ),
        ),
        SizedBox(height: AppDimensions.spacingL),

        // Difficulty Range Section
        _buildDifficultySection(),
        SizedBox(height: AppDimensions.spacingL),

        // Start Button
        _buildStartButton(),
      ],
    );
  }

  Widget _buildTab(int index) {
    return AnimatedTabButton(
      isSelected: _selectedTabs[index],
      icon: _tabs[index]['icon'] ?? '',
      label: _tabs[index]['label'] ?? '',
      onTap: () => _handleTabPress(index),
    );
  }

  Widget _buildDifficultySection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Difficulty Range',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Choose your number range',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingM),

          // Difficulty Options
          Row(
            children: [
              Expanded(
                child: _buildDifficultyChip(
                  label: '1-10',
                  value: 'a',
                  subtitle: 'Easy',
                  color: AppColors.successColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: _buildDifficultyChip(
                  label: '1-100',
                  value: 'b',
                  subtitle: 'Medium',
                  color: AppColors.warningColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: _buildDifficultyChip(
                  label: '1-1000',
                  value: 'c',
                  subtitle: 'Hard',
                  color: AppColors.errorColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip({
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    final isSelected = _selectedRange == value;

    return GestureDetector(
      onTap: () => _handleDifficultySelection(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.spacingS,
          horizontal: AppDimensions.spacingXS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.spacingS),
          border: Border.all(
            color: isSelected ? color : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppDimensions.spacingXS / 2),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    final canBegin = _canBegin();

    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: (canBegin && !_isStarting) ? _handleBegin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canBegin
              ? (_isStarting ? AppColors.successColor : AppColors.primaryColor)
              : AppColors.textTertiary,
          foregroundColor: Colors.white,
          elevation: canBegin ? 4 : 0,
          shadowColor: canBegin
              ? AppColors.primaryColor.withOpacity(0.3)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
          ),
          disabledBackgroundColor: AppColors.textTertiary,
          disabledForegroundColor: Colors.white.withOpacity(0.7),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isStarting
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spacingS),
                    Text(
                      'Starting...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Row(
                  key: const ValueKey('start'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      size: 20,
                      color: canBegin
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(width: AppDimensions.spacingS),
                    Text(
                      'Start Custom Practice',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  bool _canBegin() {
    // Check if at least one operation is selected AND a difficulty range is selected
    return _selectedTabs.contains(true) && _selectedRange.isNotEmpty;
  }

  void _handleDifficultySelection(String value) {
    setState(() {
      _selectedRange = value;
    });

    // Only call the callback if we have operations selected too
    if (_selectedTabs.contains(true)) {
      widget.onDifficultySelected();
    }
  }

  Future<void> _handleBegin() async {
    if (!_canBegin() || _isStarting) return;

    // Start the loading animation and trigger step 3
    setState(() {
      _isStarting = true;
    });

    widget.onStartPractice();

    // Add a delay before navigation
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Build a list of selected operation names.
    final selectedOps = <String>[];
    for (int i = 0; i < _selectedTabs.length; i++) {
      if (_selectedTabs[i]) {
        final operation = _tabs[i]['operation'] as Operation;
        // Use the extension to get a clean string (e.g., "addition")
        selectedOps.add(operation.name);
      }
    }
    final operationsQuery = selectedOps.join(',');

    // Navigate to the questions route with query parameters for range and operations.
    if (mounted) {
      context
          .go('/questions?range=$_selectedRange&operations=$operationsQuery');
    }
  }

  void _handleTabPress(int index) {
    setState(() {
      _selectedTabs[index] = !_selectedTabs[index];
    });

    // Check if any operations are selected
    final hasOperations = _selectedTabs.contains(true);
    widget.onOperationSelected(hasOperations);

    // If difficulty is also selected, update step 2
    if (hasOperations && _selectedRange.isNotEmpty) {
      widget.onDifficultySelected();
    }
  }
}
