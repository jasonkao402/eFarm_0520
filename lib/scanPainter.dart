import 'package:flutter/material.dart';
import 'dart:math';

class Ball {
  double x;
  double y;
  double radius;
  double life;
  DateTime spawnTime;
  bool detected;

  Ball(this.x, this.y, this.radius, this.life, this.spawnTime, this.detected);
  // void updateBallPosition() {}
}

class BallPainter extends CustomPainter {
  final List<Ball> balls;
  final double angle;
  static const int grad = 10;
  static const double angleStep = -0.04;
  static const Color baseColor = Colors.green;
  BallPainter(this.balls, this.angle);

  final Paint sidePaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  final Paint detectPaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke;

  final Paint ballPaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2.0
    ..style = PaintingStyle.fill;

  final scanPaint = Paint()
    ..color = baseColor
    ..strokeWidth = 10.0
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) * 1.41421;

    for (var ball in balls) {
      if (ball.detected) {
        ballPaint.color = Colors.red.withOpacity(max(0, ball.life));

        Paint effectPaint = Paint()
          ..color = Colors.green.withOpacity(max(0, ball.life))
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(Offset(ball.x, ball.y), 80*(1.01-ball.life), effectPaint);
      } else {
        ballPaint.color = Colors.blue;
      }
      canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, ballPaint);
    }

    for (int i = 0; i < grad; i++) {
      scanPaint.color = baseColor.withOpacity(1 - i / grad);
      Offset endPoint = Offset(
        (center.dx + radius * cos(angle + angleStep * i)).clamp(0, size.width),
        (center.dy + radius * sin(angle + angleStep * i)).clamp(0, size.height),
      );
      canvas.drawLine(center, endPoint, scanPaint);
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sidePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
