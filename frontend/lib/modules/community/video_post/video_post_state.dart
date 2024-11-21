// video_post_state.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Video_postState {
  Video_postState() {
    ///Initialize variables
  }
  // 定义一个RxList存储视频URLs
  final videoUrls = RxList<String>([
    'assets/community/test1.mp4',
    'assets/community/test2.mp4',
    // 添加更多视频URL
  ]);

  var shortVideos = <ShortVideo>[].obs;
}

// 短视频类
class ShortVideo {
  final int videoId;
  final String author;
  final String time;
  final String ip;
  final String content;
  final String videoUrl;

  final int comment_num;
  final int forward_num;
  final int like_num;

  // 构造函数
  ShortVideo({
    required this.videoId,
    required this.author,
    required this.time,
    required this.ip,
    required this.content,
    required this.videoUrl,
    required this.comment_num,
    required this.forward_num,
    required this.like_num,
  });
}
