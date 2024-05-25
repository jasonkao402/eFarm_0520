import 'package:flutter/material.dart';
import 'dart:math';

enum CropEnum {
  empty,
  millet,
  corn,
  wheat,
  rice,
  bean,
  carrot,
  potato,
  radish,
  cabbage,
  sorghum,
}

List<List<Text>> genRandWeatherReport() {
  List<List<Text>> report = [];
  DateTime time;
  int i = 0, h, l;

  const List<String> defaultWeather = [
    '☀️',
    '🌤️',
    '☀️',
    '🌤️',
    '⛅',
    '🌥️',
    '🌦️',
    '☁️',
    '🌧️',
    '☁️',
    '🌧️',
    '⛈️',
    '🌩️',
    '🌫️',
  ];

  for (; i < 7; i++) {
    l = 10 + Random().nextInt(6);
    h = l + 4 + Random().nextInt(4);
    time = DateTime.now().add(Duration(days: i));
    report.add([
      Text('${time.month}/${time.day}'),
      Text(defaultWeather[Random().nextInt(defaultWeather.length)],
          style: TextStyle(fontSize: 24.0)),
      Text('🔺 $h°C\n🔻 $l°C'),
    ]);
  }
  return report;
}
