import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'scanPainter.dart';
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
      angspeed = 0.025;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 40), _updateBallPosition);
    // Timer.periodic(duration, (timer) { })
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateBallPosition(Timer timer) {
    setState(() {
      // if (_ballX + _ballRadius > _csize || _ballX - _ballRadius < 0) {
      //   _ballX -= _velocityX;
      //   _velocityX *= -damping;
      // }
      // if (_ballY + _ballRadius > _csize || _ballY - _ballRadius < 0) {
      //   _ballY -= _velocityY;
      //   _velocityY *= -damping;
      // }
      // _ballX += _velocityX;
      // _ballY += _velocityY;
      _ballX = _velocityX * cos(_angle * 1.25) + _csize / 2;
      _ballY = _velocityY * sin(_angle * 1.25) + _csize / 2;
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
                padding: const EdgeInsets.all(8.0),
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
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ToggleButton(child: Text('雷達掃描')),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     height: 200,
                  //     margin: EdgeInsets.all(8.0),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.grey, width: 2.0),
                  //       borderRadius: BorderRadius.circular(16.0),
                  //     ),
                  //     child: ToggleButton(child: Text('自動掃描')),
                  //   ),
                  // ),
                ]),
              ),
            ),
            SliverList.builder(itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text('警告: 未知的天氣狀況'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
