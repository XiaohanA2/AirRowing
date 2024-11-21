import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../login/login_logic.dart';
import 'detailed_post_state.dart';
import '../../../request_client.dart'; // 导入RequestClient类
import 'dart:io';

class DetailedPostLogic extends GetxController {
  final Detailed_postState state = Detailed_postState();
  late RequestClient _requestClient;
  final Map<String, dynamic> arguments = Get.arguments;
  late UserController userController = Get.find();

  @override
  void onInit() {
    super.onInit();

    print("Logic Initialization");

    // // 初始化数据
    // _loadInitialData();
    // 初始化请求
    _requestClient = RequestClient();

    // // 获取传递的参数
    // final Map<String, dynamic> arguments = Get.arguments;
    // final postId = arguments['postId'];
    // getDetailedPost(postId);
  }

  void _loadInitialData() {
    // Mock data, replace with actual data fetching logic
    state.detailedPost = DetailedPost(
        postId: 0,
        author: '用户A',
        user_id: 1,
        time: '2分钟前',
        ip: "上海市嘉定区",
        title: "赛艇介绍",
        content:
            '赛艇（Rowing），是用桨进行的赛艇运动。它与划艇（canoeing）运动的不同之处在于，赛艇的桨是用桨锁固定在船上的，而划艇的桨是不连接在船上的。'
            '赛艇运动分为两个项目：双桨赛艇和单桨赛艇。在单桨赛艇中，每个划手都持有两只桨，每只手都持有一只桨，而在扫划中，每个划手都用双手持有一只桨。运动员可以参加几个级别的比赛，从一个人的单人赛艇到有八个划手和一个舵手的八人赛艇。有各种各样的课程类型和比赛形式，但大多数精英和锦标赛级别的比赛是在2公里（1.2英里）长的平静水面上进行的，有几条用浮标标记的车道。',
        imageUrl: 'assets/club/avatar.jpg',
        imageUrls: [
          'assets/club/avatar.jpg',
          'assets/club/avatar.jpg',
          'assets/club/avatar.jpg',
          'assets/community/detailedPost1.jpg',
          'assets/community/detailedPost2.jpg',
        ],
        comment_num: 32,
        like_num: 10,
        favorite_num: 213,
        view_num: 123,
        is_followed: true,
        is_favorited: false,
        is_liked: false);
    state.comments.assignAll([
      Comment(
        author: '用户B',
        time: '1分钟前',
        ip: "上海市",
        content: '我是1楼',
        like_num: 10,
        imageUrl: 'assets/club/avatar.jpg',
      ),
      Comment(
        author: '用户X',
        time: '1分钟前',
        ip: "上海市",
        content: '我是2楼',
        like_num: 123,
        imageUrl: 'assets/club/avatar.jpg',
      ),
      Comment(
        author: '用户X',
        time: '12分钟前',
        ip: "江苏省",
        content: '我是3楼',
        like_num: 13,
        imageUrl: 'assets/club/avatar.jpg',
      ),
    ]);
  }

  // 获取帖子详细信息
  Future<void> getDetailedPost(int id) async {
    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/post/get',
      queryParameters: {
        'id': id,
      },
    );
    // 帖子作者的id
    int creatorId = response.data?['userId'];
    int userId = arguments['userId']; // 目前登录用户的id

    bool isFollowed = await followedOrNot(userId, creatorId);

    // 将时间戳转换为 Dart 的 DateTime 对象
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(response.data?['createTime']);
    // 转换为本地时间
    dateTime = dateTime.toLocal();
    // 格式化 DateTime 对象，精确到分钟
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    List<dynamic> dynamicImageUrls = response.data?['uploadFilePath'];
    List<String> imageUrls = dynamicImageUrls.cast<String>();

    state.detailedPost = DetailedPost(
            postId: id,
            author: response.data?['userNickname'],
            user_id: response.data?['userId'],
            time: formattedDate,
            ip: '',
            title: response.data?['title'],
            content: response.data?['content'],
            imageUrl:response.data?['userAvatar'],
            imageUrls: imageUrls,
            comment_num: response.data?['commentCount'],
            like_num: response.data?['likeCount'],
            favorite_num: response.data?['favoriteCount'],
            view_num: response.data?['viewCount'],
            is_followed: isFollowed,
            is_favorited: false,
            is_liked: false)
        .obs;
    print(response.data);
  }

  // 获取当前用户是否关注了帖子作者
  Future<bool> followedOrNot(int userId, int creatorId) async {
    return true;
  }

  // 获取帖子评论分页
  Future<void> getPostComments(int postId) async {
    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/comment/page',
      queryParameters: {
        'postId': postId,
        'pageNo': 1,
        'pageSize': 10,
      },
    );
    List<dynamic>? commentsData = response.data?['list'];
    // 清空所有评论
    state.comments.clear();

    // 循环写入评论
    if (commentsData != null) {
      for (var comment in commentsData) {
        // 将时间戳转换为 Dart 的 DateTime 对象
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(comment['createTime']);
        // 转换为本地时间
        dateTime = dateTime.toLocal();

        // 格式化 DateTime 对象，精确到分钟
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

        // print(formattedDate);
        state.comments.add(
          Comment(
            author: comment['userNickname'],
            content: comment['content'],
            time: formattedDate,
            ip: "上海市",
            imageUrl: comment['userAvatar'],
            like_num: 23,
          ),
        );
      }
    }
    update(); // 更新状态，通知页面刷新
  }

  // 点赞帖子
  Future<void> likePost(int postId) async {
    int userId = arguments['userId']; // 目前登录用户的id

    if (state.detailedPost().is_liked == false) {
      // 如果没有点赞过就点赞
      print('点赞帖子');
      // 需要在异步操作前进行刷新
      state.detailedPost().is_liked = true;
      state.detailedPost().like_num++;

      await _requestClient.request<Map<String, dynamic>>(
        '/app-api/community/like/create',
        method: 'POST',
        queryParameters: {"userId": userId, "postId": postId},
      );
    } else {
      print('取消点赞帖子');
      // 需要在异步操作前进行刷新
      state.detailedPost().is_liked = false;
      state.detailedPost().like_num--;

      // 如果已经点赞过了就取消点赞
      await _requestClient.request<Map<String, dynamic>>(
        '/app-api/community/like/delete',
        method: 'DELETE',
        queryParameters: {"userId": userId, "postId": postId},
      );
    }
    update(); // 更新状态，通知页面刷新
  }

  // 收藏帖子
  Future<void> favoritePost(int postId) async {
    int userId = arguments['userId']; // 目前登录用户的id

    if (state.detailedPost().is_favorited == false) {
      // 如果没有收藏过就收藏
      print('点赞帖子');
      state.detailedPost().is_favorited = true;
      state.detailedPost().favorite_num++;
      await _requestClient.request<Map<String, dynamic>>(
        '/app-api/community/favorite/create',
        method: 'POST',
        queryParameters: {"userId": userId, "postId": postId},
      );
    } else {
      print('取消收藏帖子');
      state.detailedPost().is_favorited = false;
      state.detailedPost().favorite_num--;

      // 如果已经点赞过了就取消点赞
      await _requestClient.request<Map<String, dynamic>>(
        '/app-api/community/favorite/delete',
        method: 'DELETE',
        queryParameters: {"userId": userId, "postId": postId},
      );
    }
    update(); // 更新状态，通知页面刷新
  }

// 添加评论
  Future<void> addComment(int postId, String content) async {
    //int userId = userController.userId();
    int userId = 6101;

    // 发送帖子请求
    await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/comment/create',
      method: 'POST',
      queryParameters: {
        "userId": userId,
        "postId": postId,
        "content": content,
      },
    );
  }
}
