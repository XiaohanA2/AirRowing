import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'gesture_analysis_logic.dart';

class Gesture_analysisPage extends StatelessWidget {
  const Gesture_analysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(Gesture_analysisLogic());
    final state = Get.find<Gesture_analysisLogic>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture Analysis'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            // 在这里定义点击事件，比如页面导航
            Get.toNamed('training/gesture_analysis/pose_detector');
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.android, size: 48.0, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  '开启实时姿态分析！',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}