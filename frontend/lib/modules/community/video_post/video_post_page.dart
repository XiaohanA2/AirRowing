import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'video_post_logic.dart';
import 'package:video_player/video_player.dart';

class Video_postPage extends StatelessWidget {
  const Video_postPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(Video_postLogic());
    final state = Get.find<Video_postLogic>().state;

    // 页面主体，包含VideoSwipePage
    return Container(
      child: VideoSwipePage(),
    );
  }
}

// VideoSwipePage是一个有状态组件
class VideoSwipePage extends StatefulWidget {
  @override
  _VideoSwipePageState createState() => _VideoSwipePageState();
}

class _VideoSwipePageState extends State<VideoSwipePage> {
  @override
  Widget build(BuildContext context) {
    // final videoUrls = Get.find<Video_postLogic>().state.videoUrls;
    final shortVideos = Get.find<Video_postLogic>().state.shortVideos;
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: shortVideos.length,
      itemBuilder: (context, index) {
        return VideoPlayerScreen(videoUrl: shortVideos[index].videoUrl);
      },
    );
  }
}

// VideoPlayerScreen是用于播放单个视频的Widget
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

// _VideoPlayerScreenState是VideoPlayerScreen的状态类，负责管理视频的播放和控制
class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double _sliderValue = 10.0; // 设置进度条位置

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() {});
        _controller.play();
      });
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  // 释放视频控制器资源
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Scaffold(
      body: Container(
        color:Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(_controller),
                Container(
                  width: double.infinity,
                  height: 10.0, // 设置进度条高度
                  color: Colors.black54, // 进度条背景颜色
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.blue,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BarBelowVideo(),
    )
        : Center(child: CircularProgressIndicator());
  }

}

// 添加点赞、评论等按钮，位于视频下方,Position指定位置
class BarBelowVideo extends StatelessWidget {
  final double iconSize = 30;
  final double fontSize = 20;
  final fontColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0, // 距离底部的距离
      left: 16.0, // 距离左边的距离
      right: 0, // 距离右边的距离

      child: Container(
        color: Colors.black, // 设置背景颜色为黑色
        child: Row(
          children: [

            Expanded(
              child: TextButton.icon(
                icon: Icon(
                  Icons.chat_outlined,
                  size: iconSize,
                  color: fontColor,
                ),
                label: Text(
                  "20",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: fontColor,
                  ),
                ),
                onPressed: () {
                  // 评论逻辑
                },
              ),
            ),
            Expanded(
              child: TextButton.icon(
                icon: Icon(
                  Icons.discount_outlined,
                  size: iconSize,
                  color: fontColor,
                ),
                label: Text(
                  "3",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: fontColor,
                  ),
                ),
                onPressed: () {
                  // 评论逻辑
                },
              ),
            ),
            Expanded(
              child: TextButton.icon(
                icon: Icon(
                  Icons.favorite_border,
                  size: iconSize,
                  color: fontColor,
                ),
                label: Text(
                  "3",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: fontColor,
                  ),
                ),
                onPressed: () {
                  // 评论逻辑
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
