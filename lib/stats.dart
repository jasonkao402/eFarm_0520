// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fast_noise/fast_noise.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class RandomNumberPlotScreen extends StatefulWidget {
  const RandomNumberPlotScreen({super.key});

  @override
  State<RandomNumberPlotScreen> createState() => _RandomNumberPlotScreenState();
}

class RandData {
  static const int _maxNumbers = 30;
  final String title, unit;
  final double mean, stdDev;
  final PerlinFractalNoise _rng;
  final List<double> _numbers = List.empty(growable: true);
  final Color color;

  List<double> get numbers => List.unmodifiable(_numbers);
  double get latest => _numbers.last;
  double x = 0, frequency = 0.002;

  void init() {
    _numbers.clear();
    x = 0;
    while (_numbers.length < _maxNumbers) {
      _numbers.add(_rng.getNoise2(x, 0) * stdDev + mean);
      x += frequency;
    }
  }

  void update() {
    while (_numbers.length > _maxNumbers) {
      _numbers.removeAt(0);
    }
    x += frequency;
    _numbers.add(_rng.getNoise2(x, 0) * stdDev + mean);
  }

  RandData(
      this.title, this.unit, this.color, this.mean, this.stdDev, this._rng);
}

class _RandomNumberPlotScreenState extends State<RandomNumberPlotScreen> {
  late Timer timer;

  static const int updatePeriod = 15;
  final List<RandData> randData = [
    RandData(
        '溫度',
        '°C',
        Colors.red,
        23,
        8,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond, frequency: 1, octaves: 5)),
    RandData(
        '濕度',
        '%',
        Colors.blue,
        50,
        10,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond * 2, frequency: 0.5, octaves: 4)),
    RandData(
        '光照',
        'lux',
        Colors.yellow,
        75,
        5,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond * 3, frequency: 3, octaves: 3)),
    RandData(
        '肥沃度',
        'ppm',
        Colors.green,
        50,
        10,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond * 4, frequency: 0.25, octaves: 6)),
  ];
  List<List<Text>> weatherReport = [];

  @override
  void initState() {
    super.initState();
    for (var data in randData) {
      data.init();
    }
    weatherReport = genRandWeatherReport(7);
    timer = Timer.periodic(Duration(seconds: updatePeriod), (timer) {
      setState(() {
        for (var data in randData) {
          data.update();
        }
      });
    });
  }

  List<List<Text>> genRandWeatherReport(int numDays) {
    List<List<Text>> report = [];
    DateTime now = DateTime.now();
    const List<String> defaultWeather = [
      '☀️',
      '🌤️',
      '⛅',
      '🌥️',
      '🌦️',
      '☁️',
      '🌧️',
      '⛈️',
      '🌩️'
    ];

    for (int i = 0; i < numDays; i++) {
      report.add([
        Text('${now.month}/${now.day}'),
        Text(defaultWeather[Random().nextInt(defaultWeather.length)],
            style: TextStyle(fontSize: 24.0)),
        Text('${21 + Random().nextInt(6)}°C'),
      ]);
      now = now.add(Duration(days: 1));
    }
    return report;
  }

  List<Widget> buildStatChart() {
    return randData
        .map(
          (stats) => Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(16.0),
              // border: Border.all(color: stats.color),
            ),
            child: ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: stats.color),
                    Text(
                        ' ${stats.title} : ${stats.latest.toStringAsFixed(2)} ${stats.unit}',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
                subtitle: Container(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: stats.numbers
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                          isCurved: true,
                          color: stats.color,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: stats.color.withOpacity(.25),
                          ),
                        ),
                      ],
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey),
                      ),
                      gridData: FlGridData(show: false),
                    ),
                    duration: const Duration(),
                  ),
                )),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('田地即時感測數據'),
              actions: [
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('AI 建議'),
                              content: Text(
                                // 'AI 分析 : \n溫度適中，濕度適中，光照適中，肥沃度適中\n'
                                '根據天氣預報，山區日間有強烈日曬，須注意午後雷陣雨。\n\n根莖類作物注意排水以及水土保持，葉菜類作物建議架設遮陽棚。',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('關閉'),
                                ),
                              ],
                            );
                          });
                    },
                    child: Text('AI 建議')),
              ],
            ),
            SliverToBoxAdapter(
              child: Text(
                '名稱 : 阿傑的蔬菜田\n'
                '地點 : 高雄市鼓山區\n'
                '時間 : ${DateFormat('yyyy/MM/dd kk:mm').format(DateTime.now())}\n'
                '更新頻率 : 1 分鐘',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('天氣預報\n'
                          '日出 : 06:23 | 日落 : 17:49'),
                          FittedBox(
                            alignment: Alignment.center,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var item in weatherReport)
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: item,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverGrid(
              delegate: SliverChildListDelegate(buildStatChart()),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 4 / 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
