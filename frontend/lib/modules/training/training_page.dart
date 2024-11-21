import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'training_logic.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TrainingLogic());
    final logic = Get.find<TrainingLogic>();
    final state = Get.find<TrainingLogic>().state;

    // 初始化蓝牙
    // FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

    // // 获取已配对的设备列表
    // Future<void> getBondedDevices() async {
    //   List<BluetoothDevice> bondedDevices = await bluetooth.getBondedDevices();
    //   print('Bonded Devices: $bondedDevices');
    // }

    // // 开始蓝牙扫描
    // void startDiscovery() {
    //   bluetooth.startDiscovery().listen((device) {
    //     print('Discovered Device: $device');
    //   });
    // }

    // // 连接到蓝牙设备
    // Future<void> connectToDevice(BluetoothDevice device) async {
    //   BluetoothConnection connection =
    //       await BluetoothConnection.toAddress(device.address);
    //   print('Connected to Device: $device');
    //   // 在这里可以实现数据的发送和接收逻辑
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("训练室"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          // 训练计划卡片
          TrainingCard(
            title: '训练计划',
            thumbnail: Icons.calendar_today,
            description:
                '今日计划：划船器训练 - 40 min，力量训练 - 卧拉\n本周剩余计划：划船器训练*3、力量训练*2、水上训练*1',
            onTap: () {
              Get.toNamed('/training/training_plan');
            },
          ),
          TrainingCard(
            title: '训练数据分析',
            thumbnail: Icons.show_chart,
            description: '详细信息待定',
            onTap: () {
              // 跳转到训练数据分析详情页面
              Get.toNamed('/training/data_analysis');
            },
          ),
          TrainingCard(
            title: '连接C2实时训练',
            thumbnail: Icons.link,
            description: '连接Performance Monitor(PM5)',
            onTap: () {
              // 跳转到连接C2实时训练详情页面
              Get.toNamed('/training/c2');
            },
          ),
          TrainingCard(
            title: '姿态实时分析训练',
            thumbnail: Icons.accessibility_new,
            description: '科技元素的图标+“开始训练！”',
            onTap: () {
              // 跳转到姿态实时分析训练详情页面
              Get.toNamed('/training/gesture_analysis');
            },
          ),
        ],
      ),
    );
  }
}

class TrainingCard extends StatelessWidget {
  final String title;
  final IconData thumbnail;
  final String description;
  final VoidCallback onTap;

  const TrainingCard({
    Key? key,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(thumbnail,
                  size: 48.0, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8.0),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8.0),
              Flexible(
                child: FittedBox(
                  fit: BoxFit
                      .scaleDown, // Use scaleDown to fit the text inside the box
                  child: Text(description,
                      style: Theme.of(context).textTheme.titleSmall),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
