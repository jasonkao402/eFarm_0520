// main.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class BouncingBallScreen extends StatefulWidget {
  const BouncingBallScreen({super.key});

  @override
   State<BouncingBallScreen> createState() => _BouncingBallScreenState();
}

class _BouncingBallScreenState extends State<BouncingBallScreen> {
  double _ballX = 20.0;
  double _ballY = 20.0;
  double _velocityX = 10.0;
  double _velocityY = 5.0;
  double _angle = 0.0;

  final double _csize = 400;
  final double _ballRadius = 10.0, gravity = 0.3, damping = 0.99, angspeed = 0.05;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 30), _updateBallPosition);
    // Timer.periodic(duration, (timer) { })
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateBallPosition(Timer timer) {
    setState(() {
      if (_ballX + _ballRadius > _csize || _ballX - _ballRadius < 0) {
        _ballX -= _velocityX;
        _velocityX *= -damping;
      }
      if (_ballY + _ballRadius > _csize || _ballY - _ballRadius < 0) {
        _ballY -= _velocityY;
        _velocityY *= -damping;
      }
      _ballX += _velocityX;
      _ballY += _velocityY;
      // _velocityY += gravity;
      _angle = (_angle + angspeed) % (2 * pi);
      // print('$_angle, ${atan2(_ballY-_csize/2, _ballX-_csize/2)}');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: _csize,
          height: _csize,
          child: CustomPaint(
            foregroundPainter: SweepScannerPainter(_angle),
            painter: BallPainter(_ballX, _ballY, _ballRadius, _angle),
            size: Size(_csize, _csize),
            // child: Container(),
          ),
        ),
      ),
    );
  }
}

class BallPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double ballRadius;
  final double angle;

  BallPainter(this.ballX, this.ballY, this.ballRadius, this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    double diff = (atan2(ballY - size.height / 2, ballX - size.width / 2) - angle).abs();
    diff = min(2 * pi - diff, diff);
    final paint = Paint()
      ..color = diff < 0.2 ? Colors.red : Colors.blue
      ..style = PaintingStyle.fill;

    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    // Draw the background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

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
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2)*2;

    final endPoint = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.black);
    canvas.drawLine(center, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}