import 'dart:math';

import 'package:air_rowing/modules/club/attendance/attendance_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../club_logic.dart';
import '../club_routes.dart';
import '../club_state.dart';
import '../clubDrawer/drawer_page.dart';
import 'package:fl_chart/fl_chart.dart';

class AttendancePage extends StatelessWidget {
  AttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubLogic());
    final logic = Get.find<ClubLogic>();
    final state = logic.state;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0, // 调整需要的高度
          title: Text(
            "个人出勤", // Add your title text here
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true, // Center the title
          actions: [
            IconButton(
              onPressed: () {

              },
              icon: CircleAvatar(
                backgroundColor: Colors.white, // 设置背景色为白色
                backgroundImage: AssetImage(state.clubInfo.value.clubSrc),
              ),
            ),
          ],
        ),


        body: AttendanceRecord(),
      ),
    );
  }
}


class AttendanceRecord extends StatelessWidget {
  const AttendanceRecord({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(AttendanceLogic());
    final state = Get.find<AttendanceLogic>().state;


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          automaticallyImplyLeading: false, // Remove the back arrow
          title: Center(
            child: Container(
              width: 250,
              child: TabBar(
                tabs: [
                  Tab(text: '已参与训练'),
                  Tab(text: '出勤统计图'),
                ],
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (state.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            children: [
              MyTrainingList(),
              LineChartWidget(),
            ],
          );
        }),
      ),
    );
  }


}



class MyTrainingList extends StatelessWidget {
  const MyTrainingList({super.key});

  @override
  Widget build(BuildContext context) {

    final logic = Get.put(AttendanceLogic());
    final state = Get.find<AttendanceLogic>().state;


    if (state.isLoading.value) {
      return Center(child: CircularProgressIndicator());
    } else if (state.myTrainingList.isEmpty) {
      return Center(child: Text('暂无参训记录'));
    }else{
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: state.myTrainingList.length,
              itemBuilder: (context, index) {
                final myTrainingList = state.myTrainingList[index];
                return TrainingThumbnail(
                  training: myTrainingList,
                );
              },
            ),
          ),
        ],
      );
    }

  }
}


class TrainingThumbnail extends StatelessWidget {
  final Training training;

  const TrainingThumbnail({required this.training, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // 调整内部填充,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.blue, width: 2.0), // 添加边框
          //   borderRadius: BorderRadius.circular(8.0), // 可选：使边框圆角
          // ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0), // 可选：使图片圆角与边框协调
            child: Image.asset(
              training.url,
              fit: BoxFit.cover,

            ),
          ),
        ),
        title: Text(
          training.title,
          style: TextStyle(
            fontWeight: FontWeight.bold, // 设置加粗
          ),
        ),
        subtitle: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '参与人数',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  '${training.memberCount}',
                  style:TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ) ,
                )
              ],
            ),
            SizedBox(height: 2,),
            Text(
              '${training.location} - ${training.date}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
        trailing: Column(
          children: [
            TextButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text(
                '查看详情',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),

          ],
        ),
        onTap: () {
          // Handle tap event if needed
        },
      ),
    );
  }
}


class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:16.0,right: 16.0),
            child: SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        switch (value.toInt()) {
                          case 1:
                            return 'Jan';
                          case 2:
                            return 'Feb';
                          case 3:
                            return 'Mar';
                          case 4:
                            return 'Apr';
                          case 5:
                            return 'May';
                          case 6:
                            return 'June';
                          case 7:
                            return 'July';
                          case 8:
                            return 'Aug';
                          case 9:
                            return 'Sept';
                          case 10:
                            return 'Oct';
                          case 11:
                            return 'Nov';
                          case 12:
                            return 'Dec';
                        // Add more months if needed
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(1, 5), // 第一个点的坐标（月份，训练次数）
                        FlSpot(2, 8), // 第二个点的坐标
                        FlSpot(3, 6), // 第三个点的坐标
                        FlSpot(4, 8),
                        FlSpot(5, 3),
                        FlSpot(6, 5),
                        FlSpot(7, 1),
                        FlSpot(8, 4),
                        FlSpot(9, 6),
                        FlSpot(10, 3),
                        FlSpot(11, 1),
                        FlSpot(12, 7),

                        // 添加更多的点坐标
                      ],
                      isCurved: true, // 是否绘制圆滑曲线
                      colors: [Colors.blue], // 折线颜色
                      barWidth: 2, // 折线宽度
                      isStrokeCapRound: true, // 是否圆角
                      belowBarData: BarAreaData(show: false), // 以下区域颜色
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "出勤最多队员",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        //   这里展示出勤最多的人
        Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/club/logo.png"),
              radius: 25,
            ),
            title: Text(
              "zwc",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text("软件学院"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 4),
                Text(
                  "2023-01-01",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        )
        ]
      );
  }
}

