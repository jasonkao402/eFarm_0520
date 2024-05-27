import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'randomPlot.dart';
import 'util.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  static final List<CropEnum> _schedule = [
    CropEnum.millet,
    CropEnum.corn,
    CropEnum.wheat,
    CropEnum.rice,
  ];
  static final List<CropWarningItem> _warning = [
    CropWarningItem(CropEnum.corn, '偵測到來自午後雷陣雨的大量降雨，玉米須避免積水，建議檢查排水系統是否正常運作。'),
    CropWarningItem(
        CropEnum.rice, '現在為夏季，夏季高溫高濕易爆發稻瘟病、稻飛虱等病蟲害。定期檢查田間，及時施用對症的農藥。'),
    CropWarningItem(CropEnum.empty, '距離上次施肥過久，建議施用適量的有機肥料，以維持土壤肥力。'),
  ];

  @override
  Widget build(BuildContext context) {
    List<List<Text>> weatherReport = genRandWeatherReport();
    return Scaffold(
      appBar: AppBar(
        title: Text('作物種植排程'),
        // actions: [
        //   TextButton(
        //     child: Text('AI 建議'),
        //     onPressed: () {
        //       showDialog(
        //         context: context,
        //         builder: (context) {
        //           return AlertDialog(
        //             title: const Text('AI 建議'),
        //             content: const Text(
        //               '根據天氣預報，山區日間有強烈日曬，須注意午後雷陣雨。\n\n根莖類作物注意排水以及水土保持，葉菜類作物建議架設遮陽棚。',
        //             ),
        //             actions: [
        //               TextButton(
        //                 onPressed: () {
        //                   Navigator.of(context).pop();
        //                 },
        //                 child: const Text('關閉'),
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ],
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
                centerTitle: false,
                background: Image.asset(
                  'assets/myFarm.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                // height: 400,
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          // '名稱 : \n阿傑的蔬菜田\n'
                          '地點 : \n高雄市鼓山區\n'
                          '時間 : \n${DateFormat('yyyy/MM/dd kk:mm:ss').format(DateTime.now())}\n'
                          '資料更新頻率 : \n1 分鐘\n'
                          '資料來源 : \n鼓山氣象站\n高雄燈塔氣象站\n',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    // Expanded(flex: 1, child: Text('')),
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          // height: 200,
                          width: 300,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            // scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: _schedule[index] == CropEnum.empty
                                      ? Colors.grey
                                      : defCrops[_schedule[index].index].color,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                alignment: Alignment.center,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                      '區域 ${index + 1} : ${defCrops[_schedule[index].index].displayName}',
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
            SliverList.builder(
              itemCount: _warning.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: _warning[index]
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: _warning,
                  // ),
                );
              },
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
