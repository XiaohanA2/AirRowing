import 'package:get/get.dart';

import 'training_record_logic.dart';

class TrainingRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingRecordLogic());
  }
}
