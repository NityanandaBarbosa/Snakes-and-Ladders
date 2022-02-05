import 'package:flutter/material.dart';

class SnakePainter extends CustomPainter {
  final Offset top;
  final Offset bottom;

  SnakePainter({this.top, this.bottom});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    canvas.drawLine(
      top,
      bottom,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
