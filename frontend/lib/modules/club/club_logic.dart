import 'package:air_rowing/modules/club/allClub/all_club_logic.dart';
import 'package:air_rowing/modules/club/attendance/attendance_logic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../request_client.dart';
import 'club_state.dart';
import 'message/message_logic.dart';

class ClubLogic extends GetxController {
  final ClubState state = ClubState();


  late RequestClient _requestClient;


  @override
  void onInit() {
    super.onInit();
    // Mock data, replace with actual data fetching logic
    _requestClient = RequestClient();

  }

  Future<void> initializeData() async {
    Get.put(MessageLogic());
    final messageLogic = Get.find<MessageLogic>();

    Get.put(AttendanceLogic());
    final attendanceLogic = Get.find<AttendanceLogic>();

    Get.put(AllClubLogic());
    final allClubLogic = Get.find<AllClubLogic>();

    await getMyClubID(); // 获取clubId并存储

    await getMyClubDetail(); // 获取俱乐部详细资料
    await getMyTrainingList(); // 获取训练列表
    await getMyCompetitionList(); // 获取比赛列表
    await messageLogic.getMsg();
    await attendanceLogic.getMyTrainingList();
    await allClubLogic.getAllClubList();

  }

  // 获取我的clubid
  Future<void> getMyClubID() async {
    final Map<String, dynamic> arguments = Get.arguments;
    int userId = arguments['userId']; // 目前登录用户的id

    final response = await _requestClient.request<dynamic>(
      '/app-api/club/member-info/get-club-id',
      queryParameters: {
        'userId': userId,
      },
    );
    // print("The response is ${response.data}");
    // 确保响应数据不为空
    if (response.data != null) {

      int clubId = response.data;
      state.clubId.value = clubId; // 将clubId存储在state中
      print("The clubId is ${clubId}");

    }

  }

  // 获取俱乐部详细资料
  Future<void> getMyClubDetail() async {
    state.myClubIsLoading.value = true;
    int? clubId = state.clubId.value;

    final response = await _requestClient.request<dynamic>(
      '/app-api/club/detail-information/get',
      queryParameters: {
        'id': clubId,
      },
    );
    // print("The club response is ${response.data}");
    if(response.data!=null){
      ClubDetail clubDetail = ClubDetail(
          clubSrc: "assets/club/logo.png",
          name: response.data["name"],
          description: response.data["introduction"],
          coachSrc: "assets/club/logo.png",
          coachName: response.data["couch"],
          coachDes: "周易男，同济大学赛艇协会指导老师，拥有丰富的教学经验"
      );
      state.clubInfo.value = clubDetail;
      // print("The club response is ${state.clubInfo.value}");
    }
    state.myClubIsLoading.value = false;
  }

  // 获取我俱乐部的训练列表
  Future<void> getMyTrainingList() async {
    state.trainingIsLoading.value=true;
    final Map<String, dynamic> arguments = Get.arguments;
    int userId = arguments['userId']; // 目前登录用户的id



    int? clubId = state.clubId.value;
    if (clubId == null) {
      print("clubId is not set");
      return;
    }

    final response = await _requestClient.request<List<dynamic>>(
      '/app-api/club/training-record/training-list',
      queryParameters: {
        'clubId': clubId,
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
      state.trainingList.value = trainingList;
    }
    state.trainingIsLoading.value=false;

  }

  // 获取俱乐部比赛的训练列表
  Future<void> getMyCompetitionList() async {
    state.competitionIsLoading.value = true;
    final Map<String, dynamic> arguments = Get.arguments;
    int userId = arguments['userId']; // 目前登录用户的id



    int? clubId = state.clubId.value;
    if (clubId == null) {
      print("clubId is not set");
      return;
    }

    final response = await _requestClient.request<List<dynamic>>(
      '/app-api/club/competition-record/competition-list',
      queryParameters: {
        'clubId': clubId,
        'userId': userId,
      },
    );
    // print("The competition response is ${response.data}");
    // 确保响应数据不为空
    if (response.data != null) {
      // 将响应数据转换为Competition对象列表,这里其实是和training一样的
      List<Training> CompetitionList = (response.data as List).map((item) {
        Training training = Training(
          trainingId: item['id'],
          url: "assets/club/logo.png",
          title: item['title'],
          location: item['location'],
          date: DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(item['startDate'])),
          endDate: DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(item['endDate'])),
          memberCount: 10,//这里返回数据是空先写死
          isDdl: item['isOverdue'],
          isSignin: item['isApplied'],
        );
        return training;
      }).toList();
      state.competitionList.value = CompetitionList;
    }
    state.competitionIsLoading.value = false;



  }
}
