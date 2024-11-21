import 'package:air_rowing/modules/home/home_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../profile/profile_page.dart';

// TrainingRecordPage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:air_rowing/modules/home/home_routes.dart';
import 'package:air_rowing/modules/home/profile/profile_state.dart';

class TrainingRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 获取从 ProfilePage 传递过来的参数
    final List<BoatTrainingEntity> trainingData = Get.arguments as List<BoatTrainingEntity>;

    return Scaffold(
      appBar: AppBar(
        title: Text('训练记录'),
      ),
      body: ListView.builder(
        itemCount: trainingData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('训练记录 ${index + 1}'),
            onTap: () {
              Get.toNamed(
                HomeRoutes.TRAINING_DETAIL,
                arguments: trainingData[index], // 传递单个训练记录数据
              );
            },
          );
        },
      ),
    );
  }
}

