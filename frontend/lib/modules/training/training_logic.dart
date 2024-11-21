import 'package:get/get.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'training_state.dart';
import 'training_routes.dart';

class TrainingLogic extends GetxController {
  final state = TrainingState().obs;

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

  // // 选择蓝牙设备
  // void selectDevice(BluetoothDevice device) {
  //   state.value.selectedDevice.value = device;
  // }
}
