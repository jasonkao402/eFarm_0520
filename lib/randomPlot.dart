import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fast_noise/fast_noise.dart';

class RandomNumberPlotScreen extends StatefulWidget {
  const RandomNumberPlotScreen({super.key});

  @override
  State<RandomNumberPlotScreen> createState() => _RandomNumberPlotScreenState();
}

class RandData {
  static const int _maxNumbers = 60;
  final String title, unit;
  final double mean, stdDev;
  final PerlinFractalNoise _rng;
  final List<double> _numbers = List.empty(growable: true);
  final Color color;

  List<double> get numbers => List.unmodifiable(_numbers);
  double get latest => _numbers.last;
  double x = 0, frequency = 0.01;

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
        21,
        5,
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
            seed: DateTime.now().millisecond * 3, frequency: 2, octaves: 5)),
    RandData(
        '肥沃度',
        'ppm',
        Colors.green,
        50,
        6,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond * 5, frequency: 1, octaves: 2)),
  ];

  @override
  void initState() {
    super.initState();
    for (var data in randData) {
      data.init();
    }
    // weatherReport = genRandWeatherReport();
    timer = Timer.periodic(Duration(seconds: updatePeriod), (timer) {
      setState(() {
        for (var data in randData) {
          data.update();
        }
      });
    });
  }

  List<Widget> buildStatChart() {
    return randData
        .map(
          (stats) => Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Icon(Icons.circle, color: stats.color),
                  Text(
                      ' ${stats.title} : ${stats.latest.toStringAsFixed(3)} ${stats.unit}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            body: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: LineChart(
                LineChartData(
                  minY: stats.mean - stats.stdDev * 1,
                  maxY: stats.mean + stats.stdDev * 1,
                  baselineY: stats.mean,
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
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildListDelegate(buildStatChart()),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 600.0,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 4 / 3,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}