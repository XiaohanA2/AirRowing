import 'dart:io';
import 'dart:math';

import 'package:air_rowing/modules/community/personal_home/personal_home_logic.dart';
import 'package:air_rowing/modules/community/personal_home/personal_home_state.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import '../../request_client.dart'; // 导入RequestClient类
import 'community_state.dart';
import 'create_post/create_post_page.dart';
import 'detailed_post/detailed_post_logic.dart';
import 'package:air_rowing/utils/location_utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CommunityLogic extends GetxController {
  final CommunityState state = CommunityState();
  late RequestClient _requestClient;

  @override
  void onInit() {
    super.onInit();
    _requestClient = RequestClient();

    // Mock data, replace with actual data fetching logic
    // state.posts.assignAll([
    //   Post(
    //     postId: 0,
    //
    //     author: '用户A',
    //     time: '2分钟前',
    //     ip: "上海市",
    //     content: '我是赛艇界唯一的goat',
    //     imageUrl: 'assets/club/avatar.jpg',
    //
    //     comment_num: 32,
    //     like_num: 10,
    //     forward_num: 213,
    //     view_num: 123,
    //     is_liked: false,
    //     has_video: false,
    //   ),
    //   Post(
    //     postId: 1,
    //
    //     author: '用户B',
    //     time: '10分钟前',
    //     ip: "上海市",
    //     content: '这是第二条帖子的内容。',
    //     imageUrl: 'assets/community/detailedPost2.jpg',
    //     comment_num: 32,
    //     like_num: 10,
    //     forward_num: 213,
    //     view_num: 1000,
    //     is_liked: true,
    //     has_video: true,
    //
    //   ),
    //
    //   Post(
    //     postId: 2,
    //
    //     author: '用户C',
    //     ip: "上海市",
    //     time: '10分钟前',
    //     content: '这是第三条帖子的内容。',
    //     imageUrl: 'assets/club/avatar.jpg',
    //     comment_num: 32,
    //     like_num: 10,
    //     forward_num: 213,
    //     view_num: 1000,
    //     is_liked: true,
    //     has_video: false,
    //
    //   ),
    //
    //   Post(
    //     postId: 3,
    //     author: '用户D',
    //     ip: "上海市",
    //     time: '10分钟前',
    //     content: '这是第四条帖子的内容。',
    //     imageUrl: 'assets/club/avatar.jpg',
    //     comment_num: 32,
    //     like_num: 10,
    //     forward_num: 213,
    //     view_num: 1000,
    //     is_liked: true,
    //     has_video: false,
    //
    //   ),
    //
    // ]);
  }

  ///以下为接口函数

  /**
      获取关注了的人的帖子
   */
  Future<void> getFollowingPosts() async {
    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/post/page',
      queryParameters: {
        'pageNo': '1',
        'pageSize': 10,
        'returnType': 0,
      },
    );
    // print("The response is $response");
    // // 需要？来检查空值
    // print(response.data?['list']);
    // 解析帖子列表
    List<dynamic>? postListData = response.data?['list'];
    // print(postListData?[0]['title']);

    // 清空之前加载的帖子
    state.posts.clear();
    // 循环写入帖子
    if (postListData != null) {
      for (var post in postListData) {
        // 将时间戳转换为 Dart 的 DateTime 对象
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(post['createTime']);
        // 转换为本地时间
        dateTime = dateTime.toLocal();

        // 格式化 DateTime 对象，精确到分钟
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

        // 转发数量取一个随机数，美化页面
        Random random = Random.secure();
        //获取指定范围内的 int 类型随机数
        //这里是 0~100
        int randomInt = random.nextInt(100);

        // print(formattedDate);
        state.posts.add(
          Post(
            postId: post['id'],
            author: post['userNickname'],
            ip: "",
            time: formattedDate,
            title: post['title'],
            imageUrl: post['userAvatar'],
            comment_num: post['commentCount'],
            like_num: post['likeCount'],
            forward_num: randomInt,
            view_num: post['viewCount'],
            is_liked: true,
            has_video: false,
            cover: post['imagePath'] == null ? "" : post['imagePath'],
          ),
        );
      }
    }
  }

  /*
  点赞帖子
   */
  Future<void> likePost() async {
    final Map<String, dynamic> arguments = Get.arguments;
    int userId = arguments['userId']; // 目前登录用户的id
    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/like/create',
      method: 'POST',
      data: {"userId": userId, "postId": 1, "date": ""},
    );
    // print(response.data);
  }

  /// 接口函数部分结束

  /// 以下是community部分页面跳转逻辑
  void viewCommunity() {
    // Navigate to the community page
    Get.toNamed('/community');
  }

  // 实现页面跳转到具体post页面的逻辑
  // 利用异步，来保证请求完成后再进行
  void viewPost(int postId) async {
    Get.put(DetailedPostLogic());
    DetailedPostLogic detailedPostLogic = Get.find<DetailedPostLogic>();

    // 等待详情帖子信息请求完成
    await detailedPostLogic.getDetailedPost(postId);
    await detailedPostLogic.getPostComments(postId);

    // Navigate to the detailed post page
    Get.toNamed('/community/detailed_post', arguments: {'postId': postId});
  }

  void viewVideo(int videoId) {
    // Navigate to the detailed video page
    Get.toNamed('/community/video_post');
  }

  void viewPersonalHome(int userId) async {
    Get.put(PersonalHomeLogic());
    PersonalHomeLogic personalHomeLogic = Get.find<PersonalHomeLogic>();
    print(userId);

    await personalHomeLogic.getPersonalHonor(userId);

    await personalHomeLogic.getSelfPosts(userId);
    await personalHomeLogic.getFavoritedPosts(userId);
    await personalHomeLogic.getLikedPosts(userId);

    // Navigate to the personal home page
    Get.toNamed('/community/personal_home', arguments: {'userId': userId});
  }

  //实现跳转编辑页面逻辑
  void viewEditInfoPage(int userId) {
    Get.toNamed('/community/edit_info', arguments: {'userId': userId});
  }

  // 实现跳转到发布帖子页面
  void viewCreatePostPage() {
    Get.toNamed('/community/create_post');
  }
}
