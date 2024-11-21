
import 'package:air_rowing/modules/club/allClub/all_club_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../club_logic.dart';
import '../club_routes.dart';
import '../club_state.dart';
import '../clubDrawer/drawer_page.dart';
import 'all_club_logic.dart';
import 'all_club_state.dart';
import 'all_club_detail_page.dart';

class AllClubPage extends StatelessWidget {
  AllClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubLogic());
    final logic = Get.find<ClubLogic>();
    final state = logic.state;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.0,
          title: Text(
            "俱乐部列表",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          actions: [
            Obx(() => IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(state.clubInfo.value.clubSrc),
              ),
            )),
          ],
        ),
        body: ClubList(),
      ),
    );
  }
}

class ClubList extends StatelessWidget {
  const ClubList({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AllClubLogic());
    final AllClubLogic logic = Get.find<AllClubLogic>();
    final AllClubState state = logic.state;

    return Obx(() {
      if (state.clubList.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 40.0,
              child: TextField(
                decoration: InputDecoration(
                  labelText: '搜索',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onChanged: (value) {
                  // You can implement filtering logic here
                  // For example, you can update a list of filtered items
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.clubList.length,
              itemBuilder: (context, index) {
                final club = state.clubList[index];
                return ClubThumbnail(club: club);
              },
            ),
          ),
        ],
      );
    });
  }
}

class ClubThumbnail extends StatelessWidget {
  final Club club;

  const ClubThumbnail({required this.club, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubLogic());
    final logic = Get.find<ClubLogic>();
    final state = logic.state;

    Get.put(AllClubLogic());
    final allClubLogic = Get.find<AllClubLogic>();
    return GetBuilder<AllClubLogic>(
      builder:(allClubLogic){
        Color buttonColor;
        String buttonText;

        if (club.enterState == 0) {
          buttonColor = Colors.blue;
          buttonText = '申请加入';
        } else if (club.enterState == 1) {
          buttonColor = Colors.grey;
          buttonText = '已加入';
        } else {
          buttonColor = Colors.blue;
          buttonText = '审核中';
        }

        return GestureDetector(
          onTap: () {
            print("跳转拉");
            Get.to(AllClubDetailPage(club: state.clubInfo.value,clubId: club.clubID,)); // 导航到 AllClubDetailPage，并传递俱乐部信息
          },
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(
                    club.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                club.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '总人数',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${club.memberCount}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${club.address}    成立于${club.foundingDate}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: club.enterState == 0 ? () {
                  allClubLogic.enterClub(club.clubID);//这里还没有测试

                } : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );



  }
}




