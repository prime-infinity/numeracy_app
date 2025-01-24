import 'package:flutter/material.dart';
import 'package:numeracy_app/theme.dart';

class AnimatedTabButton extends StatefulWidget {
  final bool isSelected;
  final String icon;
  final VoidCallback onTap;
  final Function(double progress) onAnimationProgress;

  const AnimatedTabButton({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    required this.onAnimationProgress,
  });

  @override
  State<AnimatedTabButton> createState() => _AnimatedTabButtonState();
}

class _AnimatedTabButtonState extends State<AnimatedTabButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    )..addListener(() {
        // Start extension animation when radial spread is 70% complete
        if (_animation.value >= 0.1) {
          widget.onAnimationProgress(_animation.value);
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedTabButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.white : AppColors.primaryAccent,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(22),
            bottom: Radius.circular(widget.isSelected ? 0 : 22),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SizedBox(
            width: 53.77,
            height: 53.77,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  // Background container
                  Container(
                    color: AppColors.primaryAccent,
                  ),
                  // Animated radial spread
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(53.77, 53.77),
                        painter: RadialSpreadPainter(
                          animation: _animation.value,
                          primaryColor: AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                  // Icon
                  Center(
                    child: Text(
                      widget.icon,
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialSpreadPainter extends CustomPainter {
  final double animation;
  final Color primaryColor;

  RadialSpreadPainter({
    required this.animation,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        (size.width * 1.2) * animation; // Slightly larger than container

    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RadialSpreadPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

class AnimatedExtensionContainer extends StatelessWidget {
  final bool isSelected;
  final double animationProgress;

  const AnimatedExtensionContainer({
    super.key,
    required this.isSelected,
    required this.animationProgress,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the fill progress (0.0 to 1.0) based on the button's animation progress
    // Map the 0.7-1.0 range of button animation to 0.0-1.0 for extension
    double fillProgress =
        isSelected ? ((animationProgress - 0.7) / 0.3).clamp(0.0, 1.0) : 0.0;

    return CustomPaint(
      size: const Size(73.77, 25),
      painter: ExtensionPainter(
        progress: fillProgress,
        color: AppColors.white,
      ),
    );
  }
}

class ExtensionPainter extends CustomPainter {
  final double progress;
  final Color color;

  ExtensionPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw from top to bottom
    final rect = Rect.fromLTWH(
      0,
      0, // Start from top
      size.width,
      size.height * progress, // Height based on progress
    );

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(ExtensionPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
