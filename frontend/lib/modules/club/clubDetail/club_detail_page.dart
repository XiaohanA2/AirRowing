import 'package:air_rowing/modules/club/clubDetail/club_detail_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../club_logic.dart';
import '../club_state.dart';
import '../myClub/myClub_logic.dart';

class ClubDetailPage extends StatelessWidget {
  final int clubId;
  final ClubDetail club;

  const ClubDetailPage({super.key, required this.club, required this.clubId});

  @override
  Widget build(BuildContext context) {

    Get.put(ClubDetailLogic());
    final logic = Get.find<ClubDetailLogic>();
    final state = logic.state;

    return Scaffold(
      body: FutureBuilder(
        future: logic.initializeData(clubId),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('加载数据时出错'));
          }else{
            return Stack(
              children: <Widget>[
                Container(
                  height: 380, // 背景图片的高度
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/club/club_background.png"), // 替换为你的图片路径
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 在这里添加你的新控件
                Positioned(

                  top: 30,
                  left: MediaQuery.of(context).size.width * 0.05,  // 将左边距设置为屏幕宽度的20%
                  right: MediaQuery.of(context).size.width * 0.05, // 将右边距设置为屏幕宽度的20%

                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,  // 控制宽度为屏幕宽度的85%
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(club.clubSrc), // 替换为你的图片URL
                            ),
                            SizedBox(height: 15,),
                            Text(
                              '${club.name}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              "${club.description}",
                              textAlign: TextAlign.center,  // 添加此行以确保文字居中对齐
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),

                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Divider(color: Colors.white.withOpacity(0.7), thickness: 1),  // 添加横线


                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        // decoration: BoxDecoration(
                        //   color: Colors.white.withOpacity(0.1),
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage("${club.coachSrc}"), // 替换为指导老师的图片URL
                            ),
                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    '指导老师：${club.coachName}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18,

                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${club.coachDes}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                DraggableScrollableSheet(
                  initialChildSize: 0.48, // 初始时，拖动面板占滑动视图总高度的40%
                  minChildSize: 0.48,  // 最小高度为视图高度的30%
                  maxChildSize: 0.9,  // 最大高度为视图高度的90%
                  builder: (BuildContext context, ScrollController scrollController) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Container(
                        color: Colors.white,

                        child: ListView(
                          padding: EdgeInsets.zero,
                          controller: scrollController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '最近活动',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Add your onPressed code here!
                                        },
                                        child: Text(
                                          '查看详情',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('沈阳赛艇公开赛'),

                                        Text(
                                          '2023/5/13-5/19 沈阳',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        )
                                      ],

                                    ),

                                  ),

                                  SizedBox(height: 5),
                                  Text(
                                    '现役队员',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Wrap(
                                    spacing: 20,
                                    runSpacing: 10,
                                    children: List.generate(state.memberList.length, (index) {
                                      var member = state.memberList[index];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 27,
                                            backgroundImage: AssetImage("${member.avatar}"), // 替换为队员的图片URL
                                          ),
                                          SizedBox(height: 5),
                                          Text('${member.name}'),
                                        ],
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        }

      )

    );
  }
}