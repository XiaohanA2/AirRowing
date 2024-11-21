import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_logic.dart';
import 'home_state.dart';
import 'home_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeLogic());
    final logic = Get.find<HomeLogic>();
    final state = Get.find<HomeLogic>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 其他Home页面内容...
            ElevatedButton(
              child: const Text('View Profile'),
              onPressed: () {
                // 使用Getx导航到Profile页面
                Get.toNamed(HomeRoutes.PROFILE);
              },
            ),
          ],
        ),
      ),
    );
  }
}
