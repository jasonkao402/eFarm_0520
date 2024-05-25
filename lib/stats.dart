import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'randomPlot.dart';
import 'schedule.dart';
import 'util.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  static List<CropEnum> schedule = [
    CropEnum.millet,
    CropEnum.corn,
    CropEnum.wheat,
    CropEnum.rice,
  ];

  @override
  Widget build(BuildContext context) {
    List<List<Text>> weatherReport = genRandWeatherReport();
    return Scaffold(
      appBar: AppBar(
        title: Text('作物種植排程'),
        actions: [
          TextButton(
            child: Text('AI 建議'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('AI 建議'),
                    content: const Text(
                      '根據天氣預報，山區日間有強烈日曬，須注意午後雷陣雨。\n\n根莖類作物注意排水以及水土保持，葉菜類作物建議架設遮陽棚。',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('關閉'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('阿傑的蔬菜田'),
                background: Image.asset(
                  'assets/myfarm.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        '名稱 : 阿傑的蔬菜田\n'
                        '地點 : 高雄市鼓山區\n'
                        '時間 : ${DateFormat('yyyy/MM/dd kk:mm:ss').format(DateTime.now())}\n'
                        '更新頻率 : 1 分鐘',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(flex: 1, child: Text('')),
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        child: SizedBox(
                          height: 200,
                          // width: 800,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: schedule[index] == CropEnum.empty
                                      ? Colors.grey
                                      : defCrops[schedule[index].index].color,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                alignment: Alignment.center,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                      '區域 ${index + 1} : ${defCrops[schedule[index].index].displayName}',
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.black)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '天氣預報\n'
                            '日出 : 05:23 | 日落 : 18:13',
                            style: TextStyle(fontSize: 18),
                          ),
                          FittedBox(
                            alignment: Alignment.center,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var item in weatherReport)
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: item,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            RandomNumberPlotScreen(),
          ],
        ),
      ),
    );
  }
}
