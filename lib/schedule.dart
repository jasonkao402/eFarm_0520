// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'dart:math';

class ScheduleApp extends StatefulWidget {
  const ScheduleApp({super.key});

  @override
  State<ScheduleApp> createState() => _ScheduleAppState();
}

enum CropEnum {
  empty,
  corn,
  wheat,
  rice,
  bean,
  carrot,
  potato,
  radish,
  cabbage,
}

class CropType {
  String idName;
  String displayName;
  int growTime;
  Color color;

  CropType(this.idName, this.displayName, this.growTime, this.color);
}

class _ScheduleAppState extends State<ScheduleApp> {
  final List<CropType> defCrops = [
    CropType('empty', '空地', 1, Colors.grey),
    CropType('corn', '玉米', 4, Colors.yellow),
    CropType('wheat', '小麥', 4, Colors.amber),
    CropType('rice', '稻米', 4, Colors.brown.shade400),
    CropType('bean', '豆子', 3, Colors.green),
    CropType('carrot', '胡蘿蔔', 2, Colors.orange),
    CropType('potato', '馬鈴薯', 3, Colors.purple),
    CropType('radish', '甜菜根', 2, Colors.red),
    CropType('cabbage', '高麗菜', 3, Colors.green.shade200),
  ];
  List<CropEnum> grid = List.generate(4, (_) => CropEnum.empty);
  List<CropEnum> schedule = List.filled(200, CropEnum.empty, growable: true);
  // ScrollController controller = ScrollController();
  int curindex = 0;

  @override
  void initState() {
    super.initState();
    // controller.addListener(scrollListener);
    for (int i = 0; i < 200; i++) {
      schedule[i] = CropEnum.empty;
    }
    // plant(0, 0, CropEnum.wheat);
    for (int i = 0; i < 4; i++) {
      plant(i, 0, CropEnum.values[Random().nextInt(4) + 1]);
      plant(
          i, Random().nextInt(4) + 5, CropEnum.values[Random().nextInt(8) + 1]);
    }
  }

  // void scrollListener() {
  //   setState(() {
  //     index = (controller.offset/69.0).round() + 1;
  //   });
  // }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  bool plant(int idx, int start, CropEnum crop) {
    // check if the land is empty
    if (crop != CropEnum.empty) {
      for (int i = 0; i < defCrops[crop.index].growTime; i++) {
        if (schedule[idx + (i + start) * 4] != CropEnum.empty) {
          return false;
        }
      }
    }
    setState(() {
      for (int i = 0; i < defCrops[crop.index].growTime; i++) {
        schedule[idx + (i + start) * 4] = crop;
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作物種植排程'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: FittedBox(
              child: SizedBox(
                width: 800,
                child: GridView.builder(
                  // controller: controller,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: grid.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: schedule[curindex * 4 + index] == CropEnum.empty
                            ? Colors.grey
                            : defCrops[schedule[curindex * 4 + index].index]
                                .color,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: Colors.grey.shade700,
                          width: 8.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                            '農地 ${index + 1} : ${defCrops[schedule[curindex * 4 + index].index].displayName}',
                            style:
                                TextStyle(fontSize: 32, color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GridView.builder(
              // controller: controller,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                DateTime date =
                    DateTime.now().add(Duration(days: index ~/ 4 * 30));
                return Container(
                  decoration: BoxDecoration(
                    color: schedule[index] == CropEnum.empty
                        ? (index ~/ 4 % 2 == 0
                            ? Colors.grey.shade400
                            : Colors.grey.shade300)
                        : defCrops[schedule[index].index].color,
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1.0,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        curindex = index ~/ 4;
                      });
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  '選擇作物 - 農地 : ${index % 4 + 1} - ${date.year} 年 ${date.month} 月'),
                              content: Column(
                                children: [
                                  for (int i = 0; i < defCrops.length; i++)
                                    TextButton(
                                        onPressed: () {
                                          plant(index % 4, index ~/ 4,
                                              CropEnum.values[i]);
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.circle,
                                                color: defCrops[i].color,
                                                size: 20),
                                            Text(
                                                '${defCrops[i].displayName} (成長時間 : ${defCrops[i].growTime} 個月)'),
                                          ],
                                        )),
                                ],
                              ),
                            );
                          });
                    },
                    child: index % 4 == 0
                        ? DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text('${date.year}/${date.month}',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black)))
                        : Container(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
