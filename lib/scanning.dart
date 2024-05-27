import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'util.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  double _ballX = 20.0;
  double _ballY = 20.0;
  double _velocityX = 10.0;
  double _velocityY = 5.0;
  double _angle = 0.0;

  final double _csize = 300;
  final double _ballRadius = 10.0,
      gravity = 0.3,
      damping = 0.99,
      angspeed = 0.05;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('田地掃描通報系統'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  child: CustomPaint(
                    foregroundPainter: SweepScannerPainter(_angle),
                    painter: BallPainter(_ballX, _ballY, _ballRadius, _angle),
                    child: SizedBox(
                      width: _csize,
                      height: _csize,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(children: [
                Expanded(
                  child: Container(
                    height: 200,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ToggleButton()
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ToggleButton()
                  ),
                ),
              ]),
            ))
          ],
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
