import 'package:get/get.dart';

class EventState {
  EventState() {
    ///Initialize variables
  }

  var trainingDetailList = <TrainingDetail>[].obs;
}



class TrainingDetail {
  final String userSRC;
  final String userName;
  final int type;

  TrainingDetail({
    required this.userSRC,
    required this.userName,
    required this.type,
  });
}


