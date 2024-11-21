import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../clubDrawer/drawer_page.dart';
import '../club_logic.dart';
import '../club_state.dart';
import '../club_routes.dart';
import 'myClub_logic.dart';
import 'myClub_state.dart';
import '../clubDetail/club_detail_page.dart';

class MyClubPage extends StatelessWidget {
  const MyClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ClubLogic());
    final logic = Get.find<ClubLogic>();
    final state = logic.state;


    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          title: Row(
            children: [
              Flexible(
                child: TabBar(
                  tabs: [
                    Tab(text: '俱乐部'),
                    Tab(text: '成员'),
                    Tab(text: '出勤'),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Obx(() => CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(state.clubInfo.value.clubSrc),
                )),
              ),
            ],
          ),
        ),
        body: Obx(() {
          if (state.myClubIsLoading.value == true) {
            return Center(child: CircularProgressIndicator());
          }else if(state.clubInfo.value.name == ""){
            return TabBarView(
              children: [
                Text("暂未加入俱乐部"),
                Text("暂未加入俱乐部"),
                Text("暂未加入俱乐部"),
              ],
            );
          }else {
            return TabBarView(
              children: [
                ClubDetailPage(
                  club: state.clubInfo.value, clubId: state.clubId.value,),
                MemberList(),
                AttendanceRank(),
              ],
            );
          }
        }),
      ),
    );
  }
}

class MemberList extends StatelessWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MyClubLogic());
    final MyClubLogic logic = Get.find<MyClubLogic>();
    final MyClubState state = logic.state;

    return Obx(() {
      if (state.memberList.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: state.memberList.length,
        itemBuilder: (context, index) {
          final member = state.memberList[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundImage: AssetImage(member.avatar),
                radius: 25,
              ),
              title: Text(
                member.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(member.department),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!member.role)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '队长',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  SizedBox(height: 4),
                  Text(
                    member.enterDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class AttendanceRank extends StatelessWidget {
  const AttendanceRank({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyClubLogic());
    final MyClubLogic logic = Get.find<MyClubLogic>();
    final MyClubState state = logic.state;

    return Obx(() {
      if (state.attendanceMemberList.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60.0,
            automaticallyImplyLeading: false,
            title: Center(
              child: Container(
                width: 250,
                child: TabBar(
                  tabs: [
                    Tab(text: '总榜'),
                    Tab(text: '学期榜'),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              buildAttendanceList(state.attendanceMemberList),
              Text('学期榜'),
            ],
          ),
        ),
      );
    });
  }

  Widget buildAttendanceList(List<AttendanceMember> attendanceMemberList) {
    return ListView.builder(
      itemCount: attendanceMemberList.length,
      itemBuilder: (context, index) {
        final member = attendanceMemberList[index];
        return ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${index + 1}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 15),
              CircleAvatar(
                backgroundImage: AssetImage(member.avatar),
              ),
            ],
          ),
          title: Text(
            member.name,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '出勤次数',
                  style: TextStyle(color: Colors.black45, fontSize: 14),
                ),
                SizedBox(width: 10),
                Text(
                  '${member.attendanceCount}',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
