import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'training_plan_logic.dart';

class Training_planPage extends StatelessWidget {
  const Training_planPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(Training_planLogic());
    final state = Get.find<Training_planLogic>().state;

    return Container();
  }
}
