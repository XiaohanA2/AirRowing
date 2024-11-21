import 'package:air_rowing/modules/club/club_state.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../request_client.dart';
import '../../login/login_logic.dart';
import 'all_club_state.dart';

class AllClubLogic extends GetxController{
  final AllClubState state = AllClubState();
  late RequestClient _requestClient;
  final UserController userController = Get.find();


  @override
  void onInit() {
    super.onInit();
    _requestClient = RequestClient();
    getAllClubList();  // 初始化时获取俱乐部列表


  }

  // 获取该俱乐部训练列表
  Future<void> getAllClubList() async {

    //int userId = userController.userId();
    int userId = 6101;
    print("clublist里面的userid是：${userId}");

    final response = await _requestClient.request<List<dynamic>>(
      '/app-api/club/detail-information/get-club-list',
      queryParameters: {

        "userId":userId
      },
    );
    // print("The training response is ${response.data}");
    // 确保响应数据不为空
    if (response.data != null) {
      List<Club> clubList = (response.data as List).map((item) {
        Club club = Club(
            clubID: item["id"],
            name: item["name"],
            avatar: "assets/club/club_avatar.jpg",
            address: item["address"],
            foundingDate: DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(item['foundedTime'])),
            memberCount: item["memberNumber"],
            enterState: item["enterStatus"]//目前只有一个俱乐部，显示已加入的
        );
        return club;
      }).toList();
      // 将转换后的列表赋值给state的trainingList
      state.clubList.value = clubList;
    }

  }

  Future<void> enterClub(int enterClubId) async {
    //int userId = userController.userId.value; // 目前登录用户的id
    int userId = 6101;
    print("enterClub里面的userId：${userId}");
    print("enterClub里面的clubId：${enterClubId}");


    final response = await _requestClient.request<dynamic>(
      '/app-api/club/member-info/apply-for-club',
      method: 'POST',
      data: {
        "clubId": enterClubId,
        "userId": userId,
        "joinTime": DateTime.now().toIso8601String()
      },
    );

    await (response);
    await getAllClubList(); // 重新获取俱乐部列表以更新状态
    update(); // 通知UI状态已更新

  }

}

