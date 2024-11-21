import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data_analysis_logic.dart';

class Data_analysisPage extends StatelessWidget {
  const Data_analysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(Data_analysisLogic());
    final state = Get.find<Data_analysisLogic>().state;

    return Container();
  }
}
