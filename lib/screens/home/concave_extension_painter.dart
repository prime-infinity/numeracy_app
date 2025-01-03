import 'package:flutter/material.dart';

class ConcaveExtensionPainter extends CustomPainter {
  final bool curveLeft;
  final bool curveRight;
  final Color color;

  ConcaveExtensionPainter({
    required this.curveLeft,
    required this.curveRight,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);

    // Top line
    path.lineTo(size.width, 0);

    // Right side
    if (curveRight) {
      /*path.quadraticBezierTo(
          size.width - 12, size.height / 2, size.width, size.height);*/
      path.lineTo(size.width, size.height);
    } else {
      path.lineTo(size.width, size.height);
    }

    // Bottom line
    path.lineTo(0, size.height);

    // Left side
    if (curveLeft) {
      //path.quadraticBezierTo(12, size.height / 2, 0, 0);
      path.lineTo(0, 0);
    } else {
      path.lineTo(0, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
