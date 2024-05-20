import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'radar_simulation.dart';
import 'dart:math';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: RadarScreen(),
      home: Text('Radar Simulation'),
    );
  }
}

class RadarProvider extends ChangeNotifier {
  final List<Offset> points = [];
  double radarAngle = 0;

  RadarProvider() {
    _generateRandomPoints();
  }

  void _generateRandomPoints() {
    final random = Random();
    for (int i = 0; i < 20; i++) {
      double x = random.nextDouble() * 300 - 150;
      double y = random.nextDouble() * 300 - 150;
      points.add(Offset(x, y));
    }
    notifyListeners();
  }

  void updateRadarAngle(double delta) {
    radarAngle = (radarAngle + delta) % 360;
    notifyListeners();
  }
}
