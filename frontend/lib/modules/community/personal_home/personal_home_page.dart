import 'package:air_rowing/modules/community/personal_home/personal_home_logic.dart';
import 'package:air_rowing/modules/community/personal_home/personal_home_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../post_overview.dart';
import '../edit_info/edit_info_page.dart';

class PersonalHomePage extends StatelessWidget {
  const PersonalHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 初始化操作
    Get.put(PersonalHomeLogic());
    final logic = Get.find<PersonalHomeLogic>();

    // logic.getPersonalHonor();
    // logic.getSelfPosts();
    // logic.getFavoritedPosts();
    // logic.getLikedPosts();

    return Scaffold(
      body: PersonalHomeBody(),
    );
  }
}

class PersonalHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          PersonalHomeAppBar(),
        ];
      },
      body: PersonalHomeContent(),
    );
  }
}

class PersonalHomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 初始化操作
    Get.put(PersonalHomeLogic());
    final logic = Get.find<PersonalHomeLogic>();
    PersonalInfo personalInfo = logic.state.personalInfo;
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        // title: Text('Personal Home'),
        pinned: true,
        expandedHeight: 360.0, //这个地方规定了上面的高度，后面可以改成
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset(
            'assets/community/detailedPost1.jpg',
            fit: BoxFit.cover,
          ),
          // 个人主页中上方信息
          collapseMode: CollapseMode.pin,
          titlePadding: EdgeInsets.only(bottom: 16),
          title: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // 获取当前滚动偏移量
              double offset = constraints.biggest.height - kToolbarHeight;
              // print(offset);
              // 根据滚动偏移量调整样式，是头像还是原先样式
              if (offset < 20) {
                // 下拉后的效果，缩小为一个一个头像的样式
                return SingleChildScrollView(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Transform.translate(
                          offset: Offset(0, 15), // 向下移动 20 像素

                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(personalInfo.userAvatar),
                            radius: 20, // 半径调整为 30
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // 下拉前的效果
                return PersonalHomeInfoBeforeScroll();
              }
            },
          ),
        ),
      ),
    );
  }
}

class PersonalHomeInfoBeforeScroll extends StatelessWidget {
  Color dataBackground = Colors.black.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    // 初始化操作
    Get.put(PersonalHomeLogic());
    final logic = Get.find<PersonalHomeLogic>();
    PersonalInfo personalInfo = logic.state.personalInfo;

    // PersonalHomeLogic personalHomeLogic = Get.find<PersonalHomeLogic>();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // 将第一个Row中的内容放在最右边
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          onPressed: () {
                            // 在这里添加菜单按钮被点击时的操作
                            print("is pressed");
                            // communityLogic.viewEditInfoPage(0);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.email,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          onPressed: () {
                            // 在这里添加菜单按钮被点击时的操作
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          onPressed: () {
                            // 在这里添加菜单按钮被点击时的操作
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // 用户头像以及名称行
              Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(personalInfo.userAvatar),
                  radius: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        personalInfo.userNickname,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4), // 设置矩形的颜色
                              borderRadius:
                                  BorderRadius.circular(10), // 设置圆角的半径
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 4.0), // 添加8像素的内边距,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.male,
                                    size: 10,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    personalInfo.userAge.toString() + '岁',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            '  ' + personalInfo.userLocation + '  ' + '所属俱乐部',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 20,
                    child: OutlinedButton(
                      onPressed: () {
                        // 编辑资料按钮的点击事件处理逻辑
                        // 导航到编辑资料页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditInfoPage()),
                        );
                      },
                      child: Text(
                        '编辑资料',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white), // 白色边界
                        backgroundColor: Colors.transparent, // 内部透明
                        padding:
                            EdgeInsets.symmetric(horizontal: 5.0), // 调整按钮内部水平间距
                      ),
                    ),
                  ),
                ),
              ]),
              // 用户个性签名
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text(
                    personalInfo.userSignature,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(height: 5.0),
              // 用户成绩第一行
              Row(
                children: [
                  // 用户成绩第一行的第一个矩形
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: 100,
                      // 设置矩形的宽度
                      height: 50,
                      // 设置矩形的高度
                      decoration: BoxDecoration(
                        color: dataBackground, // 设置矩形的颜色
                        borderRadius: BorderRadius.circular(10), // 设置圆角的半径
                      ),
                      child: Column(
                        children: [
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '2000米最好成绩',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '07',
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold, // 设置粗体
                                        color:
                                            Color.fromRGBO(185, 195, 255, 1.0),
                                      ),
                                    ),
                                    TextSpan(text: '分'),
                                    TextSpan(
                                      text: '19',
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                          // 设置粗体
                                          color: Color.fromRGBO(
                                              185, 195, 255, 1.0)),
                                    ),
                                    TextSpan(text: '秒'),
                                  ],
                                ),
                              ),
                            ],
                          ))
                        ],
                      )),
                  // 中间留一点空格
                  SizedBox(
                    width: 5,
                  ),
                  // 用户成绩第一行的第二个矩形
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: 100,
                      // 设置矩形的宽度
                      height: 50,
                      // 设置矩形的高度
                      decoration: BoxDecoration(
                        color: dataBackground, // 设置矩形的颜色
                        borderRadius: BorderRadius.circular(10), // 设置圆角的半径
                      ),
                      child: Column(
                        children: [
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '1000米最好成绩',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '03',
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold, // 设置粗体
                                        color:
                                            Color.fromRGBO(185, 195, 255, 1.0),
                                      ),
                                    ),
                                    TextSpan(text: '分'),
                                    TextSpan(
                                      text: '22',
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                          // 设置粗体
                                          color: Color.fromRGBO(
                                              185, 195, 255, 1.0)),
                                    ),
                                    TextSpan(text: '秒'),
                                  ],
                                ),
                              ),
                            ],
                          ))
                        ],
                      )),
                ],
              ),
              // 中间进行一定的间隔
              SizedBox(
                height: 10,
              ),
              // 用户成绩第二行

              Container(
                width: double.infinity,
                // 设置矩形的宽度
                padding: EdgeInsets.all(5.0),
                height: 40,
                // 设置矩形的高度
                decoration: BoxDecoration(
                  color: dataBackground, // 设置矩形的颜色
                  borderRadius: BorderRadius.circular(10), // 设置圆角的半径
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      height: 100,
                      child: Text(
                        '2024全国陆上赛艇锦标赛·男子轻量级2000米项目',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    )),
                    SizedBox(width: 20.0),
                    Container(
                      height: 100,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(
                              text: '银牌',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold, // 设置粗体
                                color: Color.fromRGBO(185, 195, 255, 1.0),
                              ),
                            ),
                            TextSpan(text: '获得者'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

// 个人主页内容模块
class PersonalHomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 三个选项卡
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 80), // 设置空白SizedBox的高度
            TabBar(
              tabs: [
                Tab(text: '动态'),
                Tab(text: '赞过'),
                Tab(text: '收藏'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DynamicWidget(),
                  LikeWidget(),
                  BookmarkWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 动态
class DynamicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        var posts = Get.find<PersonalHomeLogic>().state.selfPosts;
        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(height: 10), // 设置空白SizedBox的高度
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final post = posts[index];
                  return PostWidget(post: post); // 单个帖子Widget
                },
                childCount: posts.length,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// 赞过
class LikeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        var posts = Get.find<PersonalHomeLogic>().state.likedPosts;
        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(height: 10), // 设置空白SizedBox的高度
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final post = posts[index];
                  return PostWidget(post: post); // 单个帖子Widget
                },
                childCount: posts.length,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// 收藏
class BookmarkWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        var posts = Get.find<PersonalHomeLogic>().state.likedPosts;
        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(height: 10), // 设置空白SizedBox的高度
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final post = posts[index];
                  return PostWidget(post: post); // 单个帖子Widget
                },
                childCount: posts.length,
              ),
            ),
          ],
        );
      }),
    );
  }
}
