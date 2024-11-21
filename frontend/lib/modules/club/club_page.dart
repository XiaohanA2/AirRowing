import 'dart:math';

import 'package:air_rowing/modules/club/message/message_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'club_logic.dart';
import 'club_routes.dart';
import 'club_state.dart';
import 'clubDrawer/drawer_page.dart';
import 'event/event_page.dart';

class ClubPage extends StatelessWidget {
  ClubPage({Key? key}) : super(key: key);

  // 侧边选项卡
  void _showHalfScreenDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ClubLogic());
    final logic = Get.find<ClubLogic>();
    logic.getMyClubID().then((_) {
      logic.getMyClubDetail();
      logic.getMyTrainingList();
      logic.getMyCompetitionList();
    });
    final state = Get.find<ClubLogic>().state;


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.0, // 调整需要的高度
          title: Row(
            children: [
              Flexible(
                child: TabBar(
                  tabs: [
                    Tab(text: '训练列表'),
                    Tab(text: '比赛列表'),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showHalfScreenDrawer(context); // 点击头像打开侧边栏
                },
                icon: Obx(() => CircleAvatar(
                  backgroundColor: Colors.white, // 设置背景色为白色
                  backgroundImage: AssetImage(state.clubInfo.value.clubSrc),
                )),
              ),
            ],
          ),
        ),
        body: Obx(() {
          if (state.clubId.value == null) {
            return Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            children: [
              TrainingList(),
              MatchList(),
            ],
          );
        }),
        drawer: AppDrawer(),
      ),
    );
  }
}

class TrainingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ClubLogic logic = Get.find();
    final ClubState state = logic.state;

    return Obx(() {
      if(state.trainingIsLoading.value==true){
        return Center(child: CircularProgressIndicator());
      }else if (state.trainingList.isEmpty) {
        return Text("暂无训练记录");
      }else{
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
                itemCount: state.trainingList.length,
                itemBuilder: (context, index) {
                  final training = state.trainingList[index];
                  return TrainingThumbnail(
                    training: training,
                    type: 2,
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }
}

class MatchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ClubLogic logic = Get.find();
    final ClubState state = logic.state;

    return Obx(() {
      if(state.competitionIsLoading.value==true){
        return Center(child: CircularProgressIndicator());
      }else if (state.competitionList.isEmpty) {
        return Text("暂无比赛记录");
      }else {
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
                itemCount: state.competitionList.length,
                itemBuilder: (context, index) {
                  final competition = state.competitionList[index];
                  return TrainingThumbnail(
                    training: competition,
                    type: 1,
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }
}

class TrainingThumbnail extends StatelessWidget {
  final int type;
  final Training training;

  const TrainingThumbnail({required this.training, Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    String buttonText;

    if (!training.isSignin && !training.isDdl) {
      buttonColor = Colors.blue;
      buttonText = '点击报名';
    } else if (training.isSignin && !training.isDdl) {
      // 这里还未到截止时间，所以可以取消报名
      buttonColor = Colors.blue;
      buttonText = '取消报名';
    } else if (!training.isSignin && training.isDdl) {
      buttonColor = Colors.grey;
      buttonText = '报名截止';
    } else {
      // 这里是已经报名截止了，且已报名，
      buttonColor = Colors.grey;
      buttonText = '已报名';
    }

    return GestureDetector(
      onTap: () {
        Get.to(EventPage(training: training,type: type,)); // 导航到 EventPage，并传递训练信息
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        // 调整内部填充,
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.blue, width: 2.0), // 添加边框
            //   borderRadius: BorderRadius.circular(8.0), // 可选：使边框圆角
            // ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0), // 可选：使图片圆角与边框协调
              child: Image.asset(
                training.url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            training.title,
            style: TextStyle(
              fontWeight: FontWeight.bold, // 设置加粗
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '报名人数',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${training.memberCount}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '${training.location} - ${training.date}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () {
              // 在此处添加处理按钮点击的代码
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
            ),
            child: Text(
              '${buttonText}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
