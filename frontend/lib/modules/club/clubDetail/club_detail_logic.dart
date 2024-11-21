import 'package:air_rowing/modules/club/clubDetail/club_detail_state.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../request_client.dart';
import '../club_state.dart';
import '../myClub/myClub_state.dart';


class ClubDetailLogic extends GetxController{
  final ClubDetailState state = ClubDetailState();
  late RequestClient _requestClient;
  @override
  void onInit() {
    super.onInit();
    _requestClient = RequestClient();


  }

  Future<void> initializeData(int cluId) async {
    await Future.wait([getClubDetail(cluId), getClubMember(cluId)]);
  }

  // 获取该俱乐部详细资料
  Future<void> getClubDetail(int clubId) async {

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
  }


  // 获取俱乐部成员列表
  Future<void> getClubMember(int clubId) async {
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
}