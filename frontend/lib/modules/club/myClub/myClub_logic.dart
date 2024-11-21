
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../request_client.dart';
import '../club_logic.dart';
import 'myClub_state.dart';

class MyClubLogic extends GetxController {
  final MyClubState state = MyClubState();
  late RequestClient _requestClient;



  @override
  void onInit() {
    super.onInit();
    _requestClient = RequestClient();
    // 获取 ClubLogic 实例

    fetchInitialData();  // 初始化时获取数据
  }

  // 初始化时获取数据
  Future<void> fetchInitialData() async {
    await Future.wait([getClubMember(), getAttendanceRank()]);
  }

  // 获取俱乐部成员列表
  Future<void> getClubMember() async {
    final ClubLogic clubLogic = Get.find<ClubLogic>();

    // 在此处可以访问 clubLogic.state.clubId.value 来获取 clubId
    int? clubId = clubLogic.state.clubId.value;
    final response = await _requestClient.request<List<dynamic>>(
      '/app-api/club/member-info/get-member-list',
      queryParameters: {
        'clubId': clubId,
      },
    );
    print("The member response is ${response.data}");
    // 确保响应数据不为空
    if (response.data != null) {
      // 将响应数据转换为Training对象列表
      List<Member> memberList = (response.data as List).map((item) {
        Member member = Member(
            avatar: "assets/club/club_avatar.jpg",
            name: item["userName"],
            department: "软件学院",
            enterDate: DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(item['joinTime'])),
            role: item["role"]=="队长"?false:true
        );
        return member;
      }).toList();
      state.memberList.value = memberList;
    }

  }

  // 获取俱乐部出勤排行列表
  Future<void> getAttendanceRank() async {
    final response = await _requestClient.request<List<dynamic>>(
      '/app-api/club/training-member/get-ranking-list',
      queryParameters: {
        'clubId': 1,
      },
    );
    print("The rank response is ${response.data}");
    // 确保响应数据不为空
    if (response.data != null) {
      // 将响应数据转换为Training对象列表
      List<AttendanceMember> attendanceMember= (response.data as List).map((item) {
        AttendanceMember attendanceMember = AttendanceMember(
            avatar: "assets/club/club_avatar.jpg",
            name: item["userName"],
            attendanceCount: item["trainingCount"]
        );
        return attendanceMember;
      }).toList();
      state.attendanceMemberList.value = attendanceMember;
    }

  }

}
