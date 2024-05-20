import 'package:flutter/material.dart';
// import 'dart:math';

class scheduleApp extends StatefulWidget {
  const scheduleApp({super.key});

  @override
  State<scheduleApp> createState() => _scheduleAppState();
}
enum CropEnum{
  empty,
  corn,
  wheat,
  rice,
  bean,
  carrot,
  potato
}
class CropType{
  final CropEnum crop;
  final String name;
  final int growTime;
  // final int growCost;
  // final int sellPrice;
  CropType(this.crop, this.name, this.growTime);
}
class _scheduleAppState extends State<scheduleApp> {
  final List<CropType> crops = [
    CropType(CropEnum.corn, 'Corn', 5),
    CropType(CropEnum.wheat, 'Wheat', 3),
    CropType(CropEnum.rice, 'Rice', 4),
    CropType(CropEnum.bean, 'Bean', 2),
    CropType(CropEnum.carrot, 'Carrot', 3),
    CropType(CropEnum.potato, 'Potato', 4),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: ListView.builder(
        itemCount: crops.length,
        itemBuilder: (context, index) {
          final crop = crops[index];
          return ListTile(
            title: Text(crop.name),
            subtitle: Text('Grow time: ${crop.growTime} days'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CropDetailScreen(crop: crop),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}