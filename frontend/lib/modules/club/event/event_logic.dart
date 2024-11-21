import 'package:get/get.dart';

import '../../../request_client.dart';
import 'event_state.dart';

class EventLogic extends GetxController {
  final EventState state = EventState();

  late RequestClient _requestClient;

  @override
  void onInit() {
    super.onInit();
    // Mock data, replace with actual data fetching logic
    _requestClient = RequestClient();


  }

  Future<void> initializeData(int type,int ID) async {
    if(type==1){
      await getCompetitionDetail(ID);
    }else{
      await getTrainingDetail(ID);
    }
  }
  // 获取训练详情
  Future<void> getTrainingDetail(int ID) async {
    // 根据 trainingID 发送请求获取详情信息
    final response = await _requestClient.request<dynamic>(
      '/app-api/club/training-member/get-training-detail',
      queryParameters: {
        'trainingId': ID,
      },
    );

    // 确保响应数据不为空
    if (response.data != null) {
      List<TrainingDetail> trainingDetail = (response.data as List).map((item) {
        TrainingDetail detail = TrainingDetail(
            userSRC: "assets/club/club_avatar.jpg",
            userName: item["name"],
            type:3

        );
        return detail;
      }).toList();
      print("详情为：${state.trainingDetailList.value}");
      state.trainingDetailList.value = trainingDetail;
    }
  }

  // 获取训练详情
  Future<void> getCompetitionDetail(int ID) async {
    // 根据 trainingID 发送请求获取详情信息
    final response = await _requestClient.request<dynamic>(
      '/app-api/club/competition-member/get-competition-detail',
      queryParameters: {
        'competitionId': ID,
      },
    );

    // 确保响应数据不为空
    if (response.data != null) {
      List<TrainingDetail> competitionDetail = (response.data as List).map((item) {
        TrainingDetail detail = TrainingDetail(
            userSRC: "assets/club/club_avatar.jpg",
            userName: item["userName"],
            type:3

        );
        return detail;
      }).toList();
      print("详情为：${state.trainingDetailList.value}");
      state.trainingDetailList.value = competitionDetail;
    }
  }


}
