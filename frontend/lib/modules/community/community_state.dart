import 'package:get/get.dart';

class CommunityState {
  CommunityState() {
    ///Initialize variables
  }

  var posts = <Post>[].obs;
}

// 帖子类
class Post {
  final int postId;
  final String author;
  final String time;
  final String ip;
  final String title;
  final String imageUrl;
  final String cover; //帖子封面照片

  final int view_num;
  final int comment_num;
  final int forward_num;
  final int like_num;

  bool is_liked;
  bool has_video;

  // 构造函数
  Post({
    required this.postId,
    required this.author,
    required this.time,
    required this.ip,
    required this.title,
    required this.imageUrl,
    required this.view_num,
    required this.comment_num,
    required this.forward_num,
    required this.like_num,
    required this.is_liked,
    required this.has_video,
    required this.cover,
  });
}
