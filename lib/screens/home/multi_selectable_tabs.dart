import 'package:flutter/material.dart';
import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/screens/home/animated_tab_button.dart';
import 'package:numeracy_app/shared/buttons/styled_button.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class MultiSelectableTabs extends StatefulWidget {
  final Function(List<Operation>, String) onBegin;

  const MultiSelectableTabs({super.key, required this.onBegin});

  @override
  MultiSelectableTabsState createState() => MultiSelectableTabsState();
}

class MultiSelectableTabsState extends State<MultiSelectableTabs> {
  // Track selected tabs
  final List<bool> _selectedTabs = [false, false, false, false];
  final List<double> _animationProgress = [1.0, 0.0, 0.0, 0.0];
  String _selectedRange = 'b'; // Default to 1-100

  // Tab data with corresponding operations
  final List<Map<String, dynamic>> _tabs = [
    {'icon': '+', 'operation': Operation.addition},
    {'icon': '−', 'operation': Operation.subtraction},
    {'icon': '×', 'operation': Operation.multiplication},
    {'icon': '/', 'operation': Operation.division},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          // Tab row
          Padding(
            padding: const EdgeInsets.only(bottom: 23.0),
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
            color: AppColors.white, // Background color of the container
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
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledSmallText("2: Select difficulty level", AppColors.black),
                //difficulty slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                        onPressed: () => setState(() => _selectedRange = 'a'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            _selectedRange == 'a'
                                ? AppColors.black
                                : Colors.transparent,
                          ),
                        ),
                        child: StyledSmallText(
                          "1-10",
                          _selectedRange == 'a'
                              ? Colors.white
                              : AppColors.black,
                        )),
                    OutlinedButton(
                        onPressed: () => setState(() => _selectedRange = 'b'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            _selectedRange == 'b'
                                ? AppColors.black
                                : Colors.transparent,
                          ),
                        ),
                        child: StyledSmallText(
                          "1-100",
                          _selectedRange == 'b'
                              ? Colors.white
                              : AppColors.black,
                        )),
                    OutlinedButton(
                        onPressed: () => setState(() => _selectedRange = 'c'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            _selectedRange == 'c'
                                ? AppColors.black
                                : Colors.transparent,
                          ),
                        ),
                        child: StyledSmallText(
                          "1-1000",
                          _selectedRange == 'c'
                              ? Colors.white
                              : AppColors.black,
                        ))
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                    child: StyledButton(
                  text: "Begin",
                  onPressed: _handleBegin,
                  backgroundColor:
                      _canBegin() ? AppColors.black : AppColors.cardGrey,
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _canBegin() {
    // Check if at least one operation is selected
    return _selectedTabs.contains(true);
  }

  void _handleBegin() {
    if (!_canBegin()) return;

    // Get selected operations
    final selectedOperations = <Operation>[];
    for (int i = 0; i < _selectedTabs.length; i++) {
      if (_selectedTabs[i]) {
        selectedOperations.add(_tabs[i]['operation']);
      }
    }

    // Call the callback with selected operations and range
    widget.onBegin(selectedOperations, _selectedRange);
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
