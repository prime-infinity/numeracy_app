import 'package:flutter/material.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
//import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

class DailyStreak extends StatelessWidget {
  const DailyStreak({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> days = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];
    final List<bool> isCompleted = [
      true,
      false,
      false,
      true,
      false,
      true,
      true
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledMediumText("Daily Streak", AppColors.black, true),
          const SizedBox(height: 14),
          SizedBox(
            height:
                75, // Increased height to accommodate circle + text + padding
            child: CustomPaint(
              painter: StreakLinePainter(isCompleted: isCompleted),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) => Column(
                    mainAxisSize:
                        MainAxisSize.min, // Added to prevent column expansion
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted[index]
                              ? AppColors.primaryAccent
                              : AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8), // Increased spacing
                      Text(
                        days[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StreakLinePainter extends CustomPainter {
  final List<bool> isCompleted;

  StreakLinePainter({required this.isCompleted});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryAccent
      ..strokeWidth = 42
      ..strokeCap = StrokeCap.round;

    const circleWidth = 40.0;
    final spacing = (size.width - (circleWidth * 7)) / 6;
    const centerY = 22.0; // Half of circle height (40/2)

    for (int i = 0; i < isCompleted.length - 1; i++) {
      if (isCompleted[i] && isCompleted[i + 1]) {
        final startX = (circleWidth * (i + 0.5)) + (spacing * i);
        final endX = (circleWidth * (i + 1.5)) + (spacing * (i + 1));

        canvas.drawLine(
          Offset(startX, centerY),
          Offset(endX, centerY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
