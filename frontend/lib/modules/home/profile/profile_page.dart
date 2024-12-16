
import 'package:air_rowing/main_frame.dart';
import 'package:air_rowing/modules/home/home_page.dart';
import 'package:air_rowing/modules/home/profile/profile_state.dart';
import 'package:air_rowing/modules/login/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:air_rowing/modules/home/home_routes.dart';
import 'package:air_rowing/request_client.dart';
import 'package:get_storage/get_storage.dart';
import '../training_record/training_record_page.dart';
import 'profile_logic.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final ProfileLogic profileLogic = Get.find<ProfileLogic>();
  //final Map<String, dynamic> arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    //final int userId = arguments['userId'];
    //profileLogic.fetchUser(userId);
    print("holyfuckingshit");
    UserProfileData userProfileData = profileLogic.state.userProfileData.value;
    // 实例化 ProfileLogic 并获取用户信息
    var screenSize = MediaQuery.of(context).size; // 获取屏幕尺寸
    double width = screenSize.width; // 获取宽度
    double height = screenSize.height; // 获取高度
    return Scaffold(

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white, // 开始颜色
                Colors.grey, // 结束颜色
              ],
            ),
          ),
          child: Column(
            children: [
              buildProfileTop(width, height, userProfileData),
              buildProfileDetails(width, height, userProfileData),
            ],
          ),
        ),
    );
  }
  Widget buildProfileTop(double widthContext, double heightContext,
      UserProfileData userProfileData) {
    return Container(
          height: heightContext/5,
          padding: const EdgeInsets.only(top: 30),
          child: Stack(
              children: [
                Positioned(
                  top: 52,
                  left: 28,
                  child: Container(
                    child: const CircleAvatar(
                      radius: 35, // 头像半径
                      backgroundImage: AssetImage('assets/home/profile/profile_avatar.png'), // 头像图片
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 110,
                  child: Text(userProfileData.nickname,
                      style: TextStyle(color: Colors.black,
                      fontSize: 17, fontFamily: 'PingFang SC')),
                ),
                Positioned(
                  top: 80,
                  left: 110,
                  child: Text(userProfileData.signature,
                      style: TextStyle(color: Color(0xFF666666), fontSize: 14)),
                ),
                Positioned(
                  top:50,
                    right:25,
                    child: Text('上次训练时间：天前',style: TextStyle(color:Color(0xFF666666), fontSize: 12),)
                ),
                Positioned(
                  right: 25,
                    top: 90,
                    child: Container(
                      height: 24,
                      width: 64,
                  decoration: BoxDecoration(
                    color: Colors.white, // 容器的填充色
                    borderRadius: BorderRadius.circular(15.0), // 圆角的大小
                    boxShadow: [ // 可选，如果你需要阴影效果
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '个人主页',
                      style: TextStyle(fontSize: 12, color:Color(0xFF666666)),
                    ),
                  ),
                )
                )

              ],
            ),
        // 其他信息...
    );
  }

  Widget buildStatItem(String title, String count) {
    return SizedBox(
      width: 50, // 指定宽度
      child: Column(
        mainAxisSize: MainAxisSize.min, // 让 Column 只占用必要的空间
        children: [
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }


  Widget buildDivider() {
    return Container(
      height: 50, // 根据需要调整高度
      width: 1.5, // 宽度设置为1显示为线
      color: const Color(0xFFE6E6E6), // 设置颜色，可以使用主题或其他颜色
      margin: const EdgeInsets.symmetric(horizontal: 1), // 左右添加间距
    );
  }


  Widget buildProfileDetails(double width, double height,
      UserProfileData userProfileData) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(top:18.0),
        children: [
          buildDetailAndTraining(width, height, userProfileData),
          SizedBox(height: 13),
          buildMedalWall(width, height, userProfileData),
          // 你可以添加更多的卡片和记录...
        ],
      ),
    );
  }

  Widget buildDetailAndTraining(double widthContext, double heightContext,
      UserProfileData userProfileData) {
      final List<BoatTrainingEntity> trainingData = Get.find<ProfileLogic>().state.boatTrainingEntity;
      for (BoatTrainingEntity boatTrainingEntity in trainingData) {
        print(boatTrainingEntity.heartRate);
      }
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
            alignment: Alignment.topCenter,
            width: widthContext * 0.92,
            height: heightContext * 0.45,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // 设置圆角半径为15
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '个人数据',
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontFamily: 'PingFang SC',
                        fontSize: 12,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.toNamed(HomeRoutes.TRAINING_RECORD, arguments: trainingData); // 使用Get.to()进行页面跳转
                        },
                        child: Row(
                          children: [
                            Text(
                                '查看全部数据',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                  fontFamily: 'PingFang SC',
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
                SizedBox(height: 0),
                Column(
                    children: <Widget>[
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ProfileStatCard(label: '身高', value: '${userProfileData.height}cm'),
                          buildDivider(),
                          ProfileStatCard(label: '体重', value: '${userProfileData.weight}kg'),
                          buildDivider(),
                          ProfileStatCard(label: '训练次数', value: '27次'),
                          buildDivider(),
                          ProfileStatCard(label: '训练时长', value: '32.0h'),
                        ],
                      ),
                    ]
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '训练历史',
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontFamily: 'PingFang SC',
                        fontSize: 12,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '本月一共进行了n次训练',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 12,
                        color: Color(0xFF666666),
                        fontFamily: 'PingFang SC',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                RecordList()
              ],
              //buildTrainingRecord(widthContext, heightContext)
            )
        )
      );
  }

  Widget buildMedalWall(double widthContext, double heightContext,
      UserProfileData userProfileData) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: widthContext * 0.92,
        height: heightContext * 0.20,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // 设置圆角半径为15
          ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '勋章墙',
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.black,
                    fontFamily: 'PingFang SC',
                    fontSize: 12,

                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                    onTap: () {
                      Get.toNamed(HomeRoutes.MEDAL_WALL); // 使用Get.to()进行页面跳转
                    },
                    child: Row(
                      children: [
                        Text(
                            '更多勋章',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                              fontFamily: 'PingFang SC',
                            )
                        ),
                      ],
                    )
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MedalInfo(imageUrl: 'assets/home/profile/medal/blue_rowing_life.png', info: 'RowingLife'),
                MedalInfo(imageUrl: 'assets/home/profile/medal/gold_530.png', info: '530'),
                MedalInfo(imageUrl: 'assets/home/profile/medal/green_7min.png', info: '7min!'),
              ],
            )
          ],
        )
      )
    );
  }
}

class MedalInfo extends StatelessWidget {
  final String imageUrl;
  final String info;
  const MedalInfo({super.key, required this.imageUrl, required this.info});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
            imageUrl,
          height: 90,
          width: 90,
        ),
        SizedBox(
            width: 90,
            child:Text(
              info,
              style: TextStyle(
                color: Color(0xFF919191),
                fontFamily: 'inter',
                fontSize: 12,
              ),
          ),
        )
      ],
    );
  }
}

class ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  Map<String, String> separateLettersAndNumbers(String input) {
    String letters = input.replaceAll(RegExp('[^a-zA-Z]'), '');
    String numbers = input.replaceAll(RegExp('[^0-9.:]'), '');
    return {'letters': letters, 'numbers': numbers};
  }

  const ProfileStatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    Map<String, String> separatedValues = separateLettersAndNumbers(value);
    // MediaQuery.of(context).size.width可以获取屏幕宽度
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
        child: Column(
          //mainAxisSize: MainAxisSize.min, // Column占用最小空间
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  separatedValues['numbers'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 2),
                Text(
                  separatedValues['letters'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              ]
            )

          ],
        ),
      ),
    );
  }
}
class RecordList extends StatelessWidget {
  ProfileLogic profileLogic = Get.put(ProfileLogic());
  @override
  Widget build(BuildContext context) {
    List<BoatTrainingEntity> trainingData = Get.find<ProfileLogic>().state.boatTrainingEntity;
    // 假设的数据数组
    final List<Map<String, dynamic>> records = [
      {'date': '23/10/01', 'distance': '1000m', 'time': '42:49.5'},
      {'date': '23/10/01', 'distance': '1000m', 'time': '42:49.5'},
      {'date': '23/10/01', 'distance': '1000m', 'time': '42:49.5'},
      {'date': '23/10/01', 'distance': '1000m', 'time': '42:49.5'},
      {'date': '23/10/01', 'distance': '1000m', 'time': '42:49.5'},
    ];
    final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0); // 设置初始滚动偏移量为200.0
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: records.length, // 数据数组长度
        itemBuilder: (context, index) {
          return buildRecordItem(records[index], index);
        },
      ),
    );
  }
  Widget buildRecordItem(Map<String, dynamic> record, int index) {
    List<Widget> images = [];
    if (index == 0) {
      images.add(
          Image.asset(
            'assets/home/profile/training_record/erg_activated.png',
            width: 32,
            height: 32,
          )
      );
    } else {
      images.add(
          Image.asset(
            'assets/home/profile/training_record/erg_deactivated.png',
            width: 32,
            height: 32,
          )
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10.0),
      child: Row(
        children: [
          images[0],
          SizedBox(width: 16.0), // 为图标和文本之间提供一些空间
          Expanded(
            child: Text(
              record['date'],
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PingFang SC',
              ),
            ),
          ),
          Expanded(
            child: Text(
              record['distance'],
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PingFang SC',
              ),
              textAlign: TextAlign.center, // 使文本居中
            ),
          ),
          Expanded(
            child: Text(
              record['time'],
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PingFang SC',
              ),
              textAlign: TextAlign.right, // 使文本靠右对齐
            ),
          ),
        ],
      ),
    );
  }

}

class IconTextStat extends StatelessWidget {
  final IconData iconData;
  final String stat;

  const IconTextStat({Key? key, required this.iconData, required this.stat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: Colors.white), // 图标颜色
            const SizedBox(width: 0.5), // 图标和文字之间的间距
            Text(stat, style: const TextStyle(color: Colors.white)),
          ],
        )
    );
  }
}



