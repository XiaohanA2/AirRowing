//import 'package:air_rowing/boat_training_entity.dart';
import 'package:get/get.dart';
import 'package:air_rowing/request_client.dart';
import 'profile_state.dart';

class ProfileLogic extends GetxController {
  final ProfileState state = ProfileState();

  void fetchUser(int userId) async {
    var client = RequestClient();
    var response = await client.request(
      '/app-api/app/user/get', // 替换为您的API路径
      method: 'GET',
      queryParameters: {'id': userId},
      fromJsonT: (json) {
        return UserProfileData.fromJson(json['data']);
      },
    );
    if (response.statusCode == 200 && response.data != null) {
      print("Hi, it's me");
      state.userProfileData = response.data!.obs;
      print(state.userProfileData.value.nickname);
    } else {
      print('Error: ${response.message}');
    }
  }
  //final RequestClient _requestClient = RequestClient(baseUrl: 'http://127.0.0.1:4523/m1/3953493-0-default/app-api/training/boat-record/get');
  void fetchTrainings(int userId) async {
    var client = RequestClient();

    var response = await client.request<List<BoatTrainingEntity>>(
      '/app-api/training/boat-record/get',
      method: 'GET',
      queryParameters: {'id': userId},
      fromJsonT: (json) {
        var dataList = json['data']['list'] as List<dynamic>;
        return dataList.map((item) => BoatTrainingEntity.fromJson(item)).toList();
      },
    );
    if (response.statusCode == 200 && response.data != null) {
      List<BoatTrainingEntity> trainings = response.data!;
      state.boatTrainingEntity = trainings.obs;
      for (var training in trainings) {
        print('id: ${training.id}, heartRate: ${training.heartRate}');
      }
    } else {
      print('Error: ${response.message}');
    }
  }


  void fetchTrainingData() async {

  }
}
