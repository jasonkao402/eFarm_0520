import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'radar_simulation.dart';
// import 'dart:math';

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
