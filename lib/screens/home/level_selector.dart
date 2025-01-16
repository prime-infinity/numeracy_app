import 'package:flutter/material.dart';
import 'package:numeracy_app/theme.dart';

class LevelInfo {
  final String range;
  final String description;

  const LevelInfo({required this.range, required this.description});
}

class LevelSelector extends StatelessWidget {
  final int selectedLevel;
  final Function(int) onLevelSelected;
  final double circleSize;
  final double lineWidth;
  final double spacing;

  final Map<int, LevelInfo> levelDescriptions = const {
    1: LevelInfo(range: "1-10", description: "even numbers"),
    2: LevelInfo(range: "1-40", description: "even numbers"),
    3: LevelInfo(range: "1-50", description: "odd and numbers"),
    4: LevelInfo(range: "1-100", description: "odd and numbers"),
  };

  const LevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
    this.circleSize = 19.0,
    this.lineWidth = 72.0,
    this.spacing = 5.0,
  });

  double get totalWidth => 4 * circleSize + 3 * (lineWidth + 2 * spacing);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalWidth,
      child: Column(
        children: [
          // Level selector row
          Row(
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
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  if (index < 3)
                    Container(
                      width: lineWidth,
                      height: 4,
                      margin: EdgeInsets.symmetric(horizontal: spacing),
                      decoration: BoxDecoration(
                        color: level < selectedLevel
                            ? AppColors.primaryColor
                            : Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      transform:
                          Matrix4.translationValues(0, -(spacing + 7), 0),
                    ),
                ],
              );
            }),
          ),

          const SizedBox(height: 16),

          // Description container with tooltip
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Main description container
              Container(
                width: totalWidth,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(0),
                      topRight: const Radius.circular(0),
                      bottomLeft: Radius.circular(AppDimensions.cardRadius - 8),
                      bottomRight:
                          Radius.circular(AppDimensions.cardRadius - 8)),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    '${levelDescriptions[selectedLevel]?.range}, ${levelDescriptions[selectedLevel]?.description}',
                    key: ValueKey(selectedLevel),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Tooltip triangle
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: -10,
                left: (selectedLevel - 1) *
                        (circleSize + lineWidth + 2 * spacing) +
                    (circleSize / 2) -
                    10,
                child: CustomPaint(
                  size: const Size(20, 10),
                  painter: TooltipTrianglePainter(AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TooltipTrianglePainter extends CustomPainter {
  final Color color;

  TooltipTrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
