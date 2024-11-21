import 'package:air_rowing/modules/login/login_logic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../community_state.dart';
import 'personal_home_state.dart';
import '../../../request_client.dart'; // 导入RequestClient类

class PersonalHomeLogic extends GetxController {
  final PersonalHomeState state = PersonalHomeState();
  late RequestClient _requestClient;
  late UserController userController = Get.find();
  final Map<String, dynamic> arguments = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    // 初始化请求
    _requestClient = RequestClient();
  }

  // 获取个人荣誉信息
  Future<void> getPersonalHonor(int userId) async {

    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/home/honor/get',
      queryParameters: {
        'user_id': userId,
      },
    );

    state.personalInfo = PersonalInfo(
      userNickname: response.data?['nickname'],
      userAvatar: response.data?['avatar'],
      userAge: 24,
      userLocation: "上海市",
      userSignature: response.data?['signature'],
    );
  }

  // 获取自己发布的所有帖子分页
  Future<void> getSelfPosts(int userId) async {
    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/post/page',
      queryParameters: {
        'userId': userId,
        'returnType': 0,
        'pageNo': '1',
        'pageSize': 10,
      },
    );
    // print("The response is $response");
    // // 需要？来检查空值
    // print(response.data?['list']);
    // 解析帖子列表
    List<dynamic>? postListData = response.data?['list'];
    // print(postListData?[0]['title']);

    // 循环写入帖子
    if (postListData != null) {
      for (var post in postListData) {
        // 将时间戳转换为 Dart 的 DateTime 对象
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(post['createTime']);

        // 格式化 DateTime 对象，精确到分钟
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

        // print(formattedDate);
        state.selfPosts.add(
          Post(
            postId: post['id'],
            author: post['userNickname'],
            ip: "",
            time: formattedDate,
            title: post['title'],
            imageUrl: post['userAvatar'],
            comment_num: post['commentCount'],
            like_num: post['likeCount'],
            forward_num: 0,
            view_num: post['viewCount'],
            is_liked: true,
            has_video: false,
            cover: post['imagePath'] == null ? "" : post['imagePath'],
          ),
        );
      }
    }
  }

  // 获取自己发布的所有帖子分页
  Future<void> getLikedPosts(int userId) async {
    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/post/page',
      queryParameters: {
        'userId': userId,
        'returnType': 1,
        'pageNo': '1',
        'pageSize': 10,
      },
    );
    // print("The response is $response");
    // // 需要？来检查空值
    // print(response.data?['list']);
    // 解析帖子列表
    List<dynamic>? postListData = response.data?['list'];
    // print(postListData?[0]['title']);

    // 循环写入帖子
    if (postListData != null) {
      for (var post in postListData) {
        // 将时间戳转换为 Dart 的 DateTime 对象
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(post['createTime']);

        // 格式化 DateTime 对象，精确到分钟
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

        // print(formattedDate);
        state.likedPosts.add(
          Post(
            postId: post['id'],
            author: post['userNickname'],
            ip: "",
            time: formattedDate,
            title: post['title'],
            imageUrl: post['userAvatar'],
            comment_num: post['commentCount'],
            like_num: post['likeCount'],
            forward_num: 0,
            view_num: post['viewCount'],
            is_liked: true,
            has_video: false,
            cover: post['imagePath'] == null ? "" : post['imagePath'],
          ),
        );
      }
    }
  }

  // 获取自己收藏的所有帖子分页
  Future<void> getFavoritedPosts(int userId) async {
    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/post/page',
      queryParameters: {
        'userId': userId,
        'returnType': 2,
        'pageNo': '1',
        'pageSize': 10,
      },
    );
    // print("The response is $response");
    // // 需要？来检查空值
    // print(response.data?['list']);
    // 解析帖子列表
    List<dynamic>? postListData = response.data?['list'];
    // print(postListData?[0]['title']);

    // 循环写入帖子
    if (postListData != null) {
      for (var post in postListData) {
        // 将时间戳转换为 Dart 的 DateTime 对象
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(post['createTime']);

        // 格式化 DateTime 对象，精确到分钟
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

        // print(formattedDate);
        state.favoritedPosts.add(
          Post(
            postId: post['id'],
            author: post['userNickname'],
            ip: "",
            time: formattedDate,
            title: post['title'],
            imageUrl: post['userAvatar'],
            comment_num: post['commentCount'],
            like_num: post['likeCount'],
            forward_num: 0,
            view_num: post['viewCount'],
            is_liked: true,
            has_video: false,
            cover: post['imagePath'] == null ? "" : post['imagePath'],
          ),
        );
      }
    }
  }
}
