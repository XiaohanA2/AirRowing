import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'training_detail_logic.dart';
import 'package:air_rowing/modules/home/profile/profile_state.dart';

class TrainingDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 获取传递的参数
    final BoatTrainingEntity trainingRecord = Get.arguments as BoatTrainingEntity;
    // 格式化时间
    String formattedTime = formatTime(trainingRecord.totalTime);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('20:06 划船器', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // 分享操作
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('24/01/15', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Divider(),
                      buildStatRow('时间', formattedTime),
                      Divider(),
                      buildStatRow('距离', '${trainingRecord.totalDistance} 米'),
                      Divider(),
                      buildStatRow('平均步速', '${trainingRecord.strokeRate}'),
                      Divider(),
                      buildStatRow('目标步速', 'N/A'), // 如果有目标步速数据，可以替换N/A
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('锻炼数据分析', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text('步速 /500米', style: TextStyle(fontSize: 14)),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            // 配置LineChartData...
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('划手频率 次划水/分钟', style: TextStyle(fontSize: 14)),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            // 配置LineChartData...
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('心率 每分钟心跳次数', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            // 配置LineChartData...
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildHeartRateStat('平均心率', '181', '每分钟心跳次数'),
                          buildHeartRateStat('最大心率', '194', '每分钟心跳次数'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildHeartRateStat('目标区间', '-', ''),
                          buildHeartRateStat('处于目标区间的时间', '-', ''),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildHeartRateStat(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              TextSpan(text: unit, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  String formatTime(Map<String, dynamic> time) {
    int hours = time['hour'] ?? 0;
    int minutes = time['minute'] ?? 0;
    int seconds = time['second'] ?? 0;
    int nanos = time['nano'] ?? 0;

    String formattedTime = '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}:'
        '${nanos.toString().padLeft(2, '0')}';

    return formattedTime;
  }
}

