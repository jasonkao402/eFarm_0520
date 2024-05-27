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
    l = 12 + Random().nextInt(6);
    h = l + 4 + Random().nextInt(4);
    time = DateTime.now().add(Duration(days: i));
    report.add([
      Text('${time.month}/${time.day}'),
      Text(defaultWeather[Random().nextInt(defaultWeather.length)],
          style: TextStyle(fontSize: 28.0)),
      Text('🔺 $h°C\n🔻 $l°C'),
    ]);
  }
  return report;
}

class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _isOn = false;

  void _toggleButton() {
    setState(() {
      _isOn = !_isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _toggleButton,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isOn ? Colors.green : Colors.red, // Set button color
        ),
        child: Text(
          _isOn ? 'ON' : 'OFF',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
