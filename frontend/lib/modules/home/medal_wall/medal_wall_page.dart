import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'medal_wall_logic.dart';

class MedalWallPage extends StatelessWidget {
  const MedalWallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(MedalWallLogic());
    final state = Get.find<MedalWallLogic>().state;
    var screenSize = MediaQuery.of(context).size;
    double widthContext = screenSize.width; // 获取宽度
    double heightContext = screenSize.height; // 获取高度
    List<Achievement> achievements = [
      Achievement(title: '亦可赛艇', date: '2023.09.30', achieved: true,
          image_url: 'assets/home/profile/medal/blue_rowing_life.png',
          description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"
      ),
      Achievement(title: '530Keeper', date: '2023.12.30', achieved: true, image_url: 'assets/home/profile/medal/gold_530.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '破七分', date: '2024.01.01', achieved: true, image_url: 'assets/home/profile/medal/green_7min.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      // ...其他成就数据
    ];
    int achievementLength = achievements.length;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: heightContext * 0.3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight, // 渐变开始位置
                end: Alignment.bottomLeft, // 渐变结束位置
                colors: [
                  Color(0xFF1939AF), // 渐变起始颜色
                  Color(0xFF1D47B5),
                  Color(0xFF3D60BB),
                  Color(0xFF5F7AC1),
                  Color(0xFFD9D9D9)// 渐变结束颜色
                ],
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top:20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft, // 将按钮对齐到左上角
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                        ),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop(); // 返回到前一个屏幕
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFE0EDFF),
                          borderRadius: BorderRadius.all(Radius.circular(13.0)
                          )
                        ),
                        child: Text(
                          '总成就${achievements.length}枚'
                          //toString(achievementLength)
                        ),
                      )
                    )
                  ],
                ),
                Text(
                  '最近获得的成就',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'inter',
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      achievements[0].image_url,
                      width: 74,
                      height: 74,
                    ),
                    Column(

                      children: [

                        Image.asset(
                          achievements[1].image_url,
                          width: 108,
                          height: 108,
                        ),
                        Text(
                            achievements[1].title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      achievements[2].image_url,
                      width: 74,
                      height: 74,
                    ),
                  ],
                )
              ],
            )
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.7, // 初始时占屏幕比例
            minChildSize: 0.1, // 最小时占屏幕比例
            maxChildSize: 1.0, // 最大时占屏幕比例
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F9FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                    children: <Widget>[
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 3,
                          children: achievements.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var achievement = entry.value;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => AchievementDetailPage(initialPage: idx),
                                ));
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 43,
                                    backgroundImage: AssetImage(achievement.image_url),
                                  ),
                                  Text(achievement.title),
                                  Text(achievement.date),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}

class AchievementDetailPage extends StatelessWidget {
  final int initialPage;


  final PageController _pageController = PageController(viewportFraction: 0.6);
  AchievementDetailPage({Key? key, required this.initialPage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Achievement> achievements = [
      Achievement(title: '亦可赛艇', date: '2023.09.30', achieved: true,
          image_url: 'assets/home/profile/medal/blue_rowing_life.png',
          description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"
      ),
      Achievement(title: '530Keeper', date: '2023.12.30', achieved: true, image_url: 'assets/home/profile/medal/gold_530.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '破七分', date: '2024.01.01', achieved: true, image_url: 'assets/home/profile/medal/green_7min.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      Achievement(title: '大有铭气', date: '---', achieved: false, image_url: 'assets/home/profile/medal/locked_fame.png', description: "你见过嘉定五点半的太阳吗",
          achieveCondition: "达成条件：连续一个月，每周都参加至少两次水上训练"),
      // ...其他成就数据
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF349FEC), // 渐变结束颜色
              Color(0xFF73AEF5), // 渐变开始颜色
              Color(0xFF61A4F1), // 渐变中间颜色
              Color(0xFFFFFFFF)
              // 可以根据您的设计添加更多颜色
            ],
            stops: [0.1, 0.4, 0.7, 1.0], // 颜色渐变的位置
          ),
        ),
        child:Center(
          child: SizedBox(
            // 限制视图的高度
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView.builder(
              controller: _pageController,
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double pageOffset = 0;
                    if (_pageController.position.haveDimensions) {
                      pageOffset = index - _pageController.page!;
                    }

                    double scale = 1 - (pageOffset.abs() * 0.3).clamp(0.0, 1.0);
                    double opacity = scale.clamp(0.5, 1.0);

                    return Center(
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2), // 为图片添加边距
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            achievements[index].description, // 这里放你的上方文字
                            style: TextStyle(
                              color: Colors.white, // 文字颜色
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // 文字大小
                              fontFamily: 'PingFang SC'
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Image.asset(
                            achievements[index].image_url,
                            fit: BoxFit.contain,
                            width: 160,
                            height: 160,
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, -70.0, 0.0), // 负的Y轴值会向上移动图片
                          child: Image.asset(
                            'assets/home/profile/medal/rice_medal.png',
                            width: 350,
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, -80.0, 0.0), // 负的Y轴值会向上移动图片
                          child: Text(
                            achievements[index].title,
                            style: TextStyle(
                                color: Colors.white, // 文字颜色
                                fontWeight: FontWeight.bold,
                                fontSize: 18, // 文字大小
                                fontFamily: 'PingFang SC'
                            ),
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, -80.0, 0.0), // 负的Y轴值会向上移动图片
                          child: Text(
                            achievements[index].date,
                            style: TextStyle(
                                color: Color(0xFF006399), // 文字颜色
                                fontWeight: FontWeight.bold,
                                fontSize: 12, // 文字大小
                                fontFamily: 'PingFang SC'
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            achievements[index].achieveCondition,// 这里放你的上方文字
                            style: TextStyle(
                                color: Colors.white, // 文字颜色
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // 文字大小
                                fontFamily: 'PingFang SC'
                            ),
                          ),
                        ),
                      ],
                    )
                    /*
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            achievements[index].image_url,
                          ),
                          fit: BoxFit.contain
                      ),
                    ),*/
                  ),
                );
              },
            ),
          ),
        ),
      ),

    );
  }

  @override
  void dispose() {
    _pageController.dispose();
  }
}

class Achievement {
  final String title;
  final String date;
  final bool achieved;
  final String image_url;
  final String description;
  final String achieveCondition;
  Achievement({required this.title, required this.date, required this.achieved,
  required this.image_url, required this.description, required this.achieveCondition});
}



class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // 页面最上方的导航: 关注 俱乐部 发现
        children: <Widget>[
          TextButton(
            onPressed: () {
              // 信息页逻辑
            },
            child: Text('运动人生', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              // 发现页逻辑
            },
            child: Text('限时挑战', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              // 发现页逻辑
            },
            child: Text('个人最佳', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100); // 这里设置你的TopBar高度
}


