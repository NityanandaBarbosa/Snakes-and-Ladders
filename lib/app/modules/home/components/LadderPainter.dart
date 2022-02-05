import 'package:flutter/material.dart';

class LadderPainter extends CustomPainter {
  final Offset top;
  final Offset bottom;

  LadderPainter({this.top, this.bottom});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.9)
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
