import 'package:air_rowing/modules/community/detailed_post/detailed_post_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'post_overview.dart';
import 'search_post/search_post_page.dart'; // 导入自定义搜索委托
import 'community_logic.dart';
import 'community_state.dart';
import 'detailed_post/detailed_post_logic.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityLogic());
    final logic = Get.find<CommunityLogic>();

    logic.getFollowingPosts();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TopBar(),
        body: Stack(
          children: [
            TabBarView(
              children: [
                // 第一个选项卡的内容
                Center(
                  child: PostsPage(),
                ),
                // 第二个选项卡的内容
                Center(
                  child: Text('俱乐部内容'),
                ),
                // 第三个选项卡的内容
                Center(
                  child: Text('发现内容'),
                ),
              ],
            ),
            PostCreate(), // 这里添加你的PostCreate小部件
          ],
        )


      ),
    );
  }
}

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // 设置顶部导航栏高度
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 点击设置图标的处理逻辑
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context){

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('个人主页'),
                        onTap: () {
                          // 点击个人主页的处理逻辑
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.history),
                        title: Text('历史记录'),
                        onTap: () {
                          // 点击历史记录的处理逻辑
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add),
                        title: Text('添加好友'),
                        onTap: () {
                          // 点击个人主页的处理逻辑
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text('我的关注'),
                        onTap: () {
                          // 点击个人主页的处理逻辑

                        },
                      ),
                      // 添加更多选项...
                    ],
                  );
                }
              );
            },
          ),
          Expanded(
            child: TabBar(
              tabs: [
                Tab(text: '关注'),
                Tab(text: '俱乐部'),
                Tab(text: '发现'),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 点击设置图标的处理逻辑
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
    );
  }
}

// 所有帖子集合
class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        var posts = Get.find<CommunityLogic>().state.posts;
        // print(posts.length);
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostWidget(post: post); // 单个帖子Widget
          },
        );
      }),
    );
  }
}


// 发布帖子的icon
class PostCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CommunityLogic communityLogic = Get.find<CommunityLogic>();

    return Positioned(
      right: 20,
      bottom: 20,
      child: FloatingActionButton(
        onPressed: () {
          // 跳转发布帖子页面
          print("跳转到发布帖子页面");
          communityLogic.viewCreatePostPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
