import 'package:get/get.dart';

class Detailed_postState {
  Detailed_postState() {
    ///Initialize variables
    print("State Initialization");
  }

  var detailedPost;
  var comments = <Comment>[].obs;
}

// 帖子类
class DetailedPost {
  final int postId;

  final String author;
  final int user_id;
  final String time;
  final String ip;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> imageUrls;

  int view_num;
  int comment_num;
  int favorite_num;
  int like_num;
  bool is_followed;
  bool is_liked;
  bool is_favorited;

  // 构造函数
  DetailedPost({
    required this.postId,
    required this.author,
    required this.user_id,
    required this.time,
    required this.ip,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.imageUrls,
    required this.view_num,
    required this.comment_num,
    required this.favorite_num,
    required this.like_num,
    required this.is_followed,
    required this.is_liked,
    required this.is_favorited,
  });
}

// 具体评论类
class Comment {
  final String author;
  final String time;
  final String ip;
  final String content;
  final String imageUrl;

  int like_num;

  // 构造函数
  Comment({
    required this.author,
    required this.time,
    required this.ip,
    required this.content,
    required this.imageUrl,
    required this.like_num,
  });
}
