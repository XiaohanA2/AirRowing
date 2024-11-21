import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'c2_state.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class C2Logic extends GetxController {
  final C2State state = C2State();
  Future<void> requestLocationPermission() async {
    // 请求定位权限
    var locationStatus = await Permission.location.request();
    // 请求蓝牙权限
    var bluetoothStatus = await Permission.bluetooth.request();

    // 检查权限状态
    if (locationStatus.isGranted && bluetoothStatus.isGranted) {
      // 权限已授予
      print("Location and Bluetooth permissions granted");
      startScan();
    } else if (locationStatus.isDenied || bluetoothStatus.isDenied) {
      // 用户拒绝了权限，您可以提示用户打开设置页面手动授权
      print("Location or Bluetooth permission denied");
    } else if (locationStatus.isPermanentlyDenied ||
        bluetoothStatus.isPermanentlyDenied) {
      // 用户永久拒绝了权限，您可以提示用户打开设置页面手动授权
      print("Location or Bluetooth permission permanently denied");
    }
  }

  void startScan() {
    // state.devices.clear();
    // FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
    // FlutterBluePlus.onScanResults.listen((results) {
    //   for (ScanResult r in results) {
    //     if (!state.devices.contains(r.device)) {
    //       state.devices.add(r.device);
    //     }
    //   }
    // });
    state.devices.clear();
    try {
      FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      FlutterBluePlus.onScanResults.listen((results) {
        for (ScanResult r in results) {
          if (!state.devices.contains(r.device)) {
            state.devices.add(r.device);
          }
        }
      });
      print('设备列表长度: ${state.devices.length}');
    } catch (e) {
      print('搜索异常');
      print(e);
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    if (device == null) return;
    try {
      await device.connect();
    } on Exception catch (e) {
      print('连接异常');
      print(e);
      return;
    }
    print('连接完成');
    state.connectedDevice.value = device;
  }

  void disconnectDevice() {
    state.connectedDevice.value?.disconnect();
    state.connectedDevice.value = null;
  }

  @override
  void onClose() {
    super.onClose();
    disconnectDevice();
  }
}
