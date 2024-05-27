import 'package:flutter/material.dart';
import 'dart:math';

class BallPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double ballRadius;
  final double angle;

  BallPainter(this.ballX, this.ballY, this.ballRadius, this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    double diff =
        (atan2(ballY - size.height / 2, ballX - size.width / 2) - angle).abs();
    diff = min(2 * pi - diff, diff);
    final paint = Paint()
      ..color = diff < 0.2 ? Colors.red : Colors.blue
      ..style = PaintingStyle.fill;

    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    // Draw the background
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw the ball
    canvas.drawCircle(Offset(ballX, ballY), ballRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SweepScannerPainter extends CustomPainter {
  final double angle;

  SweepScannerPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    const int grad = 10;
    const double angleStep = -0.04;
    const Color baseColor = Colors.green;
    final paint = Paint()
      ..color = baseColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) * 1.41421;

    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.black);
    for (int i = 0; i < grad; i++) {
      paint.color = baseColor.withOpacity(1 - i / grad);
      Offset endPoint = Offset(
        (center.dx + radius * cos(angle + angleStep * i)).clamp(0, size.width),
        (center.dy + radius * sin(angle + angleStep * i)).clamp(0, size.height),
      );
      canvas.drawLine(center, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}