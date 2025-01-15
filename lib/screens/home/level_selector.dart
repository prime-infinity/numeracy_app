import 'package:flutter/material.dart';
import 'package:numeracy_app/theme.dart';

class LevelSelector extends StatelessWidget {
  final int selectedLevel;
  final Function(int) onLevelSelected;
  final double circleSize;
  final double lineWidth;
  final double spacing;

  const LevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
    this.circleSize = 19.0,
    this.lineWidth = 65.0,
    this.spacing = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final level = index + 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => onLevelSelected(level),
                      child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: level <= selectedLevel
                              ? AppColors.primaryColor
                              : Colors.black,
                        ),
                        child: Center(
                          child: Container(
                            width: circleSize * 0.4,
                            height: circleSize * 0.4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: level <= selectedLevel
                                  ? AppColors.primaryAccent
                                  : AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(
                      '$level',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black),
                    ),
                  ],
                ),
                if (index < 3)
                  Container(
                    width: lineWidth,
                    height: 6,
                    margin: EdgeInsets.symmetric(horizontal: spacing + 3),
                    decoration: BoxDecoration(
                      color: level < selectedLevel
                          ? AppColors.primaryColor
                          : Colors.black,
                      borderRadius: BorderRadius.circular(
                          10), // Half of the height to make it pill-shaped
                    ),
                    transform: Matrix4.translationValues(0, -(spacing + 7), 0),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
