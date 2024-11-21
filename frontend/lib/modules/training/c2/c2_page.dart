import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'c2_logic.dart';

class C2Page extends StatelessWidget {
  const C2Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(C2Logic());
    final state = Get.find<C2Logic>().state;

    final connectedDevice = state.connectedDevice.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Example'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => logic.requestLocationPermission(),
            child: Text('Scan for Devices'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.devices.length,
              itemBuilder: (context, index) {
                final device = state.devices[index];
                return ListTile(
                  title: Text(device.platformName ?? "Unknown Device"),
                  subtitle: Text(device.remoteId.toString()),
                  onTap: () => logic.connectToDevice(device),
                );
              },
            ),
          ),
          state.connectedDevice.value != null
              ? Column(
                  children: [
                    Text('Connected to: ${state.connectedDevice.value}'),
                    ElevatedButton(
                      onPressed: () => logic.disconnectDevice(),
                      child: Text('Disconnect'),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
