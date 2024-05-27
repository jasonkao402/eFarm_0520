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

class CropType {
  String idName;
  String displayName;
  int growTime; // 生長時長 (以月計)
  Color color;
  int startMonth; // 當令產季開始月份
  int endMonth;   // 當令產季結束月份

  CropType(
    this.idName,
    this.displayName,
    this.growTime,
    this.color,
    this.startMonth,
    this.endMonth,
  );
}

final List<CropType> defCrops = [
  CropType('empty', '空地', 1, Colors.grey, 1, 12),
  CropType('millet', '小米', 4, Colors.amber.shade200, 5, 9), // 生長時長: 4個月, 當令產季: 5月至9月
  CropType('corn', '玉米', 3, Colors.yellow, 6, 9),          // 生長時長: 3個月, 當令產季: 6月至9月
  CropType('wheat', '小麥', 7, Colors.amber, 10, 6),          // 生長時長: 7個月, 當令產季: 10月至次年6月
  CropType('rice', '稻米', 5, Colors.amber.shade100, 5, 10), // 生長時長: 5個月, 當令產季: 5月至10月
  CropType('bean', '豆子', 3, Colors.green, 5, 8),           // 生長時長: 3個月, 當令產季: 5月至8月
  CropType('carrot', '胡蘿蔔', 3, Colors.orange, 3, 6),       // 生長時長: 3個月, 當令產季: 3月至6月
  CropType('potato', '樹薯', 4, Colors.brown.shade400, 4, 8), // 生長時長: 4個月, 當令產季: 4月至8月
  CropType('radish', '甜菜根', 2, Colors.red, 9, 11),         // 生長時長: 2個月, 當令產季: 9月至11月
  CropType('cabbage', '高麗菜', 3, Colors.green.shade200, 9, 12), // 生長時長: 3個月, 當令產季: 9月至12月
  CropType('sorghum', '高粱', 4, Colors.red.shade200, 6, 9),  // 生長時長: 4個月, 當令產季: 6月至9月
];

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
  final Widget? child;
  const ToggleButton({super.key, required this.child});

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
    return ElevatedButton(
      onPressed: _toggleButton,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor:
            _isOn ? Colors.green : Colors.red, // Set button color
      ),
      child: widget.child,
    );
  }
}

class CropWarningItem extends StatelessWidget {
  final CropEnum crop;
  final String warning;

  const CropWarningItem(this.crop, this.warning, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.warning, size: 32, color: defCrops[crop.index].color),
      title: Text(
          crop == CropEnum.empty ? '所有作物' : defCrops[crop.index].displayName,
          style: TextStyle(fontSize: 20)),
      subtitle: Text(warning, style: TextStyle(fontSize: 16)),
    );
  }
}
