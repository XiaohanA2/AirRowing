import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../request_client.dart';
import '../../login/login_logic.dart';
import '../club_logic.dart';
import '../club_state.dart';
import 'attendance_state.dart';


class AttendanceLogic extends GetxController {
  final AttendanceState state = AttendanceState();

  late RequestClient _requestClient;
  late UserController userController = Get.find();

  @override
  void onInit() {
    super.onInit();
    // Mock data, replace with actual data fetching logic


    _requestClient = RequestClient();
    getMyTrainingList();

  }




  Future<void> getMyTrainingList() async {

    Get.put(ClubLogic());
    final clubLogic = Get.find<ClubLogic>();
    final clubState = clubLogic.state;


    state.isLoading.value = true;

    //int userId = userController.userId();
    int userId = 6101;
    print("msg里面的userid是：${userId}");

    final response = await _requestClient.request<List<dynamic>>(
      '/app-api/club/training-record/personal-training',
      queryParameters: {
        'userId': userId,
      },
    );
    // print("The training response is ${response.data}");
    // 确保响应数据不为空
    if (response.data != null) {
      // 将响应数据转换为Training对象列表
      List<Training> trainingList = (response.data as List).map((item) {
        Training training = Training(
          trainingId: item['id'],
          url: "assets/club/logo.png",
          title: item['name'],
          location: item['location'],
          date: DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(item['time'])),
          endDate: DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(item['time'])),
          memberCount: item['number'],
          isDdl: item['isOverdue'],
          isSignin: item['isApplied'],
        );
        return training;
      }).toList();
      // 将转换后的列表赋值给state的trainingList

      if(clubState.clubId.value!=0){
        print("我参与的训练有${state.myTrainingList.value}");
        state.myTrainingList.value = trainingList;
      }

    }

    state.isLoading.value = false;
  }



}

