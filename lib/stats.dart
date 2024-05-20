// random_number_plot_screen.dart
import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fast_noise/fast_noise.dart';

class RandomNumberPlotScreen extends StatefulWidget {
  const RandomNumberPlotScreen({super.key});

  @override
  State<RandomNumberPlotScreen> createState() => _RandomNumberPlotScreenState();
}

class RandData {
  static const int _maxNumbers = 30;
  final String title;
  final double mean, stdDev;
  final PerlinFractalNoise _rng;
  final List<double> _numbers = List.empty(growable: true);
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

  RandData(this.title, this.mean, this.stdDev, this._rng);
}

class _RandomNumberPlotScreenState extends State<RandomNumberPlotScreen> {
  late Timer timer;

  static const int updatePeriod = 1000;
  final List<RandData> randData = [
    RandData(
        '溫度',
        23,
        8,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond, frequency: 2, octaves: 5)),
    RandData(
        '濕度',
        50,
        10,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond * 2, frequency: 5, octaves: 4)),
    RandData(
        '光照',
        75,
        5,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond * 3, frequency: 3, octaves: 3)),
    RandData(
        '肥沃度',
        50,
        10,
        PerlinFractalNoise(
            seed: DateTime.now().millisecond * 4, frequency: 1, octaves: 6)),
  ];

  @override
  void initState() {
    super.initState();
    for (var data in randData) {
      data.init();
    }
    timer = Timer.periodic(Duration(milliseconds: updatePeriod), (timer) {
      setState(() {
        for (var data in randData) {
          data.update();
        }
      });
    });
  }

  LineChart _buildChart(int index) {
    Color curColor = Colors.primaries[index % Colors.primaries.length];
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: randData[index]
                .numbers
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: curColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: curColor.withOpacity(.25),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('溫度濕度感測'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('田地「東南方丘陵」- 即時感測數據', style: TextStyle(fontSize: 32)),
              Text('更新頻率：${updatePeriod / 1000} 分鐘', style: TextStyle(fontSize: 16)),
              Text('時間：${DateTime.now().toString()}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text('eFarm AI 分析：溫度適中，濕度適中，光照適中，肥沃度適中', style: TextStyle(fontSize: 16)),
              Text('AI 建議：注意山區午後強降雨，注意防曬', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: randData.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 180,
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle,
                                  color: Colors
                                      .primaries[index % Colors.primaries.length]),
                              SizedBox(
                                width: 160,
                                child: Text(
                                    ' ${randData[index].title} : ${randData[index].latest.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 20)),
                              )
                            ],
                          ),
                          title: _buildChart(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
