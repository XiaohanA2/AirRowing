import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'video_post_state.dart';

class Video_postLogic extends GetxController {
  final Video_postState state = Video_postState();

  @override
  void onInit() {
    super.onInit();
    // 初始化逻辑，mock data
    state.shortVideos.assignAll([
      ShortVideo(
        videoId: 0,
        author: '用户A',
        time: '2分钟前',
        ip: '上海市',
        content: '赛艇比赛在大自然界举行',
        videoUrl: 'assets/community/test1.mp4',
        comment_num: 412,
        forward_num: 213,
        like_num: 10,
      ),
      ShortVideo(
        videoId: 0,
        author: '用户B',
        time: '2分钟前',
        ip: '上海市',
        content: '赛艇比赛在大自然界举行',
        videoUrl: 'assets/community/test2.mp4',
        comment_num: 412,
        forward_num: 213,
        like_num: 10,
      ),
      ShortVideo(
        videoId: 0,
        author: '用户C',
        time: '2分钟前',
        ip: '上海市',
        content: '赛艇比赛在大自然界举行',
        videoUrl: 'assets/community/test1.mp4',
        comment_num: 412,
        forward_num: 213,
        like_num: 10,
      )
    ]);
  }
}
