// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'stats.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eFarming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class funcPage {
  final String title;
  final Widget page;
  final BottomNavigationBarItem item;
  funcPage(this.title, this.page, this.item);
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<funcPage> pages = [
    funcPage('Stats', RandomNumberPlotScreen(), BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Stats')),
    funcPage('Schedule', Text('Schedule'), BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule')),
    funcPage('Radar', Text('Radar'), BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'Radar')),
  ];
  int _currentIndex = 0;
  List<Widget> _screens = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _screens = pages.map((e) => e.page).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        iconSize: 32,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: pages.map((e) => e.item).toList(),
      ),
    );
  }
}