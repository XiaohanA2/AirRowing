import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';


class C2State {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  final List<BluetoothDevice> devices = [];
  final Rx<BluetoothDevice?> connectedDevice = Rx<BluetoothDevice?>(null);
  final RxString pace = '0.0'.obs;
  final RxString elapsedTime = '0:00'.obs;
  final RxString distance = '0'.obs;
  final RxList<int> forceCurve = <int>[].obs;

  C2State() {
    initBluetooth();
  }

  void initBluetooth() {
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!devices.contains(r.device)) {
          devices.add(r.device);
        }
      }
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    connectedDevice.value = device;

    // Discover services
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            // Handle value updates here
            parseForceCurveData(value);
          });
        }
      }
    }
  }

  void parseForceCurveData(List<int> data) {
    if (data.isEmpty) return;

    // 高半字节是特性数量，低半字节是字的数量
    int msNib = (data[0] >> 4) & 0x0F;
    int lsNib = data[0] & 0x0F;

    // 解析数据内容
    List<int> parsedData = [];
    for (int i = 1; i < data.length; i += 2) {
      if (i + 1 < data.length) {
        int value = (data[i] & 0xFF) | ((data[i + 1] & 0xFF) << 8);
        parsedData.add(value);
      }
    }

    forceCurve.value = parsedData;
  }

  void disconnectDevice() async {
    if (connectedDevice.value != null) {
      await connectedDevice.value!.disconnect();
      connectedDevice.value = null;
    }
  }
}

