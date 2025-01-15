import 'package:flutter/material.dart';
import 'package:numeracy_app/screens/home/animated_tab_button.dart';
import 'package:numeracy_app/screens/home/level_selector.dart';
import 'package:numeracy_app/shared/buttons/styled_button.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class MultiSelectableTabs extends StatefulWidget {
  const MultiSelectableTabs({super.key});

  @override
  MultiSelectableTabsState createState() => MultiSelectableTabsState();
}

class MultiSelectableTabsState extends State<MultiSelectableTabs> {
  // Track selected tabs
  final List<bool> _selectedTabs = [false, false, false, false];
  final List<double> _animationProgress = [1.0, 0.0, 0.0, 0.0];
  int _selectedLevel = 1;

  // Tab data
  final List<Map<String, String>> _tabs = [
    {'icon': '+'},
    {'icon': '−'},
    {'icon': '×'},
    {'icon': '/'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          // Tab row
          Padding(
            padding: const EdgeInsets.only(bottom: 13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                _tabs.length,
                (index) => _buildTab(index),
              ),
            ),
          ),
          // Extension containers for selected tabs
          _buildExtensionContainers(),
        ]),
        // Difficulty level section
        AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Animation duration
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: AppColors.cardGrey, // Background color of the container
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                  AppDimensions.cardRadius), // Adjust the radius as needed
              bottomRight: Radius.circular(AppDimensions.cardRadius),
              topRight: Radius.circular(_selectedTabs[_selectedTabs.length - 1]
                  ? 0
                  : AppDimensions.cardRadius),
              topLeft: Radius.circular(
                  _selectedTabs[0] ? 0 : AppDimensions.cardRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: StyledSmallText(
                        "Select a difficulty level", AppColors.black)),
                const SizedBox(height: 16),
                //difficulty slider
                Center(
                  child: LevelSelector(
                      selectedLevel: _selectedLevel,
                      onLevelSelected: (level) {
                        setState(() {
                          // Update your selected level
                          _selectedLevel = level;
                        });
                      }),
                ),
                const SizedBox(height: 16),
                Center(
                    child: StyledButton(
                  text: "Begin",
                  width: 251,
                  onPressed: () {},
                  backgroundColor: AppColors.black,
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleTabPress(int index) {
    setState(() {
      _selectedTabs[index] = !_selectedTabs[index];
      if (!_selectedTabs[index]) {
        _animationProgress[index] = 0.0;
      }
    });
  }

  void _handleAnimationProgress(int index, double progress) {
    setState(() {
      _animationProgress[index] = progress;
    });
  }

  // Usage example for _buildTab:
  Widget _buildTab(int index) {
    return AnimatedTabButton(
      isSelected: _selectedTabs[index],
      icon: _tabs[index]['icon'] ?? '',
      onTap: () => _handleTabPress(index),
      onAnimationProgress: (progress) =>
          _handleAnimationProgress(index, progress),
    );
  }

  Widget _buildExtensionContainers() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _tabs.length,
          (index) => AnimatedExtensionContainer(
            isSelected: _selectedTabs[index],
            animationProgress: _animationProgress[index],
          ),
        ),
      ),
    );
  }
}
