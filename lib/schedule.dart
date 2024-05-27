import 'package:flutter/material.dart';
import 'dart:math';
import 'util.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class CropType {
  String idName;
  String displayName;
  int growTime;
  Color color;

  CropType(this.idName, this.displayName, this.growTime, this.color);
}

final List<CropType> defCrops = [
  CropType('empty', '空地', 1, Colors.grey),
  CropType('millet', '小米', 6, Colors.amber.shade200),
  CropType('corn', '玉米', 6, Colors.yellow),
  CropType('wheat', '小麥', 6, Colors.amber),
  CropType('rice', '稻米', 6, Colors.amber.shade100),
  CropType('bean', '豆子', 3, Colors.green),
  CropType('carrot', '胡蘿蔔', 2, Colors.orange),
  CropType('potato', '樹薯', 3, Colors.brown),
  CropType('radish', '甜菜根', 2, Colors.red),
  CropType('cabbage', '高麗菜', 3, Colors.green.shade200),
  CropType('sorghum', '高粱', 4, Colors.red.shade200),
];

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<CropEnum> grid = List.generate(4, (_) => CropEnum.empty);
  List<CropEnum> schedule = List.filled(200, CropEnum.empty, growable: true);
  int curindex = 0;
  DateTime topdate = DateTime.now();
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 200; i++) {
      schedule[i] = CropEnum.empty;
    }
    for (int i = 0; i < 4; i++) {
      setPlant(i, 0, CropEnum.values[i + 1]);
      setPlant(i, Random().nextInt(5) + 6,
          CropEnum.values[Random().nextInt(defCrops.length - 1) + 1]);
      setPlant(i, Random().nextInt(5) + 17,
          CropEnum.values[Random().nextInt(defCrops.length - 1) + 1]);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool checkPlant(int idx, int start, CropEnum crop) {
    // check if the land is empty
    if (crop != CropEnum.empty) {
      for (int i = 0; i < defCrops[crop.index].growTime; i++) {
        if (schedule[idx + (i + start) * 4] != CropEnum.empty) {
          return false;
        }
      }
    }
    return true;
  }

  void setPlant(int idx, int start, CropEnum crop) {
    int j = 0;
    setState(() {
      if (crop == CropEnum.empty) {
        j = defCrops[schedule[idx + start * 4].index].growTime;
        while (start > 0 &&
            schedule[idx + (start - 1) * 4] == schedule[idx + start * 4]) {
          start--;
        }
        for (int i = 0; i < j; i++) {
          schedule[idx + (i + start) * 4] = crop;
        }
      } else {
        j = defCrops[crop.index].growTime;
        for (int i = 0; i < j; i++) {
          schedule[idx + (i + start) * 4] = crop;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作物種植排程 ${topdate.year} 年 ${topdate.month} 月'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 12,
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
                            '區域 ${index + 1} : ${defCrops[schedule[curindex * 4 + index].index].displayName}',
                            style:
                                TextStyle(fontSize: 32, color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 8,
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
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      setState(() {
                        curindex = index ~/ 4;
                        topdate =
                            DateTime.now().add(Duration(days: curindex * 30));
                      });
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  '選擇作物 - 區域 : ${index % 4 + 1} - ${date.year} 年 ${date.month} 月'),
                              content: Column(
                                children: [
                                  for (int i = 0; i < defCrops.length; i++)
                                    TextButton(
                                        onPressed: () {
                                          if (checkPlant(index % 4, index ~/ 4,
                                              CropEnum.values[i])) {
                                            setPlant(index % 4, index ~/ 4,
                                                CropEnum.values[i]);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(i == 0
                                                  ? '已移除規劃'
                                                  : '已規劃於 ${date.year} 年 ${date.month} 月種植 ${defCrops[i].displayName}'),
                                            ));
                                            Navigator.of(context).pop();
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('無法種植'),
                                                  content: Text('該地已經有作物種植了'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('確定'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
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
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: Text('${date.year}/${date.month}',
                                style: TextStyle(
                                    fontSize: 9, color: Colors.black),softWrap: false,
                                    ),
                                    )
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
