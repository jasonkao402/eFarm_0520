import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'scanPainter.dart';
import 'package:intl/intl.dart';
// import 'util.dart';
class imgInfo {
  final String title;
  final String method;
  final String imgPath;
  DateTime time = DateTime(2024);
  imgInfo(this.title, this.imgPath, this.method);
}

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  static double bsize = 10.0, blife = 1.0;
  List<Ball> balls = [];
  List<imgInfo> imgInfos = [
    imgInfo('鹿', 'assets/thermal1.jpg', '熱影像'),
    imgInfo('豬', 'assets/thermal2.jpg', '熱影像'),
    imgInfo('豬', 'assets/thermal3.jpg', '震動'),
    imgInfo('鹿', 'assets/thermal4.jpg', '熱影像'),
    imgInfo('豬', 'assets/thermal5.jpg', '熱影像'),
  ];
  double _angle = 0;
  bool _isOn = true;
  final double _csize = 300;
  final double _angspeed = 0.025;
  late DateTime fakeTime;
  late Timer _timer;
  // final ToggleButton _toggleButton = ToggleButton(childT: Text('暫停掃描系統', style:
  //   TextStyle(color: Colors.white, fontSize: 24.0), ), childF: Text('重啟掃描系統', style:
  //   TextStyle(color: Colors.white, fontSize: 24.0), ));
  @override
  void initState() {
    super.initState();
    fakeTime = DateTime.now();
    fakeTime = DateTime(2024, fakeTime.month, fakeTime.day-Random().nextInt(10), Random().nextInt(24), Random().nextInt(60));
    for (int i = 0; i < 5; i++) {
      imgInfos[i].time = fakeTime.subtract(Duration(seconds: Random().nextInt(3600)+i*3600));
    }
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
      for (var ball in balls) {
        // chect detection using atan2 and angle
        if (ball.detected && ball.life > 0) {
          ball.life -= 0.04;
        }
        
        if ((atan2(-ball.y + _csize / 2, -ball.x + _csize / 2) + pi - _angle).abs() < 0.125) {
          ball.detected = true;
          ball.spawnTime = DateTime.now();
        }
      }
      balls.removeWhere((ball) => DateTime.now().difference(ball.spawnTime).inSeconds > blife && ball.detected == true);
      _angle = (_angle + (_isOn ? _angspeed : 0)) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('田地掃描通報系統'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            balls.add(Ball(Random().nextDouble() * _csize, Random().nextDouble() * _csize, bsize, blife, DateTime.now(), false));
          });
        },
        child: const Icon(Icons.add),
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
                    size: Size(_csize, _csize),
                    painter: BallPainter(balls, _angle),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isOn = !_isOn;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: _isOn ? Colors.red : Colors.green,
                  ),
                  child: _isOn
                      ? Text('暫停掃描系統',
                          style: TextStyle(color: Colors.white, fontSize: 24.0))
                      : Text('重啟掃描系統',
                          style:
                              TextStyle(color: Colors.white, fontSize: 24.0)),
                ),
              ),
            ),
            SliverList.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                          title: Text('生物偵測通報'),
                          subtitle: Text('時間 : ${DateFormat('yyyy-MM-dd HH:mm').format(imgInfos[index].time)}, 生物 : ${imgInfos[index].title}, 方式 : ${imgInfos[index].method}'),
                          leading: Image.asset(
                            'assets/thermal${index + 1}.jpg',
                            height: 100,
                          ),
                          onTap: () => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('生物偵測通報'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/thermal${index + 1}.jpg',
                                          height: 300,
                                        ),
                                        Text('時間 : ${DateFormat('yyyy-MM-dd HH:mm:ss').format(imgInfos[index].time)}'),
                                        Text('生物 : ${imgInfos[index].title}'),
                                        Text('位置 : 高雄市鼓山區'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('確定'))
                                    ],
                                  );
                                },
                              )));
                }),
          ],
        ),
      ),
    );
  }
}
