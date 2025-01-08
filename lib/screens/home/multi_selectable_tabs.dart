import 'package:flutter/material.dart';
import 'package:numeracy_app/screens/home/concave_extension_painter.dart';
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
  final List<bool> _selectedTabs = [true, false, false, false];

  // Tab data
  final List<Map<String, String>> _tabs = [
    {'icon': '+'},
    {'icon': '−'},
    {'icon': '×'},
    {'icon': '−'},
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                _tabs.length,
                (index) => _selectedTabs[index]
                    ? CustomPaint(
                        painter: ConcaveExtensionPainter(
                          curveLeft: index > 0,
                          curveRight: index < _tabs.length - 1,
                          color: AppColors.cardGrey,
                        ),
                        child: const SizedBox(
                          width: 87.5,
                          height: 15.0,
                        ),
                      )
                    : Container(width: 87.5),
              ),
            ),
          ),
        ]),
        // Difficulty level section
        Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledTitleMediumText("Difficulty Level", AppColors.black),
                const SizedBox(height: 8),
                StyledSmallText("Select a difficulty level", Colors.grey[600]!),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //_buildDifficultyChip('1 - 10'),
                    const SizedBox(width: 8),
                    _buildDifficultyChip('10 - 100'),
                    const SizedBox(width: 8),
                    _buildDifficultyChip('100 - 1000'),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                    child: StyledButton(
                        text: "Begin", width: 251, onPressed: () {}))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabs[index] = !_selectedTabs[index];
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedTabs[index] ? AppColors.cardGrey : AppColors.cardGrey,
          // Add connected effect when selected
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(22),
            bottom: Radius.circular(_selectedTabs[index] ? 0 : 22),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            width: 61.5,
            height: 61.5,
            decoration: BoxDecoration(
                color: _selectedTabs[index]
                    ? AppColors.primaryAccent
                    : AppColors.cardGrey,
                borderRadius: BorderRadius.circular(18)),
            child: Center(
              child: Text(
                _tabs[index]['icon'] ?? '',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label),
    );
  }
}
