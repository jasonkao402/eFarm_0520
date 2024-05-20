import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'radar_provider.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
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

class _RadarScreenState extends State<RadarScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(() {
        context.read<RadarProvider>().updateRadarAngle(1);
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radar Simulation'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(300, 300),
          painter: RadarPainter(),
        ),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radarProvider = Provider.of<RadarProvider>(canvas as BuildContext, listen: false);
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw radar background
    canvas.drawCircle(center, size.width / 2, paint);

    // Draw points
    for (var point in radarProvider.points) {
      final pointPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center + point, 4, pointPaint);
    }

    // Draw radar sweep
    final radarSweepPaint = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final radarAngle = radarProvider.radarAngle;
    final sweepPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: size.width / 2),
        radians(radarAngle - 25),
        radians(50),
        false,
      )
      ..close();
    canvas.drawPath(sweepPath, radarSweepPaint);
  }

  double radians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
