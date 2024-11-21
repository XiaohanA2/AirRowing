import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'community_logic.dart';
import 'community_state.dart';

// 单个帖子布局Widget，是一个有状态的组件
class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState(post: post);
}

class _PostWidgetState extends State<PostWidget> {
  // 各个组件的属性
  final double iconSize = 18;
  final double fontSize = 10;
  final fontColor = Colors.grey;
  final positionColor = Colors.grey;

  final Post post;

  double? _imageHeight; //用来获取图片高度，来展示文本
  @override
  void initState() {
    super.initState();
    _getImageSize();
  }

  Future<double> _getImageSize() async {
    Image image = Image.network(widget.post.imageUrl);
    Completer<double> completer = Completer();
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(info.image.height.toDouble());
        },
      ),
    );
    return completer.future;
  }

  _PostWidgetState({required this.post});

  @override
  Widget build(BuildContext context) {
    CommunityLogic communityLogic = Get.find<CommunityLogic>();

    return InkWell(
      // 点击进入详细帖子
      onTap: () => post.has_video == false
          ? communityLogic.viewPost(post.postId)
          : communityLogic.viewVideo(post.postId), // 启用 onTap 事件处理
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像，利用InkWell进行包裹，使得头像可以点击跳转到个人信息页
            InkWell(
              onTap: () {
                print("is pressed");
                communityLogic.viewPersonalHome(0);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(post.imageUrl),
                ),
              ),
            ),

            // 帖子
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            post.author,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // 设置字体大小为18，可以根据需要调整大小
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            post.time,
                            style: TextStyle(
                              color: positionColor,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            post.ip,
                            style: TextStyle(
                              color: positionColor,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: positionColor,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                    child: Text(post.title),
                  ),

                  FutureBuilder<double>(
                    future: _getImageSize(),
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // 加载中...
                      } else {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else
                          return Container(
                            padding: EdgeInsets.only(right: 10.0),
                            width: MediaQuery.of(context).size.width,
                            // 这里是如果图片大小小于300，就以图片高度为主，如果大于300，就以300为主做宽度自适应
                            height: snapshot.data != null
                                ? (snapshot.data! < 300 ? snapshot.data : 300)
                                : 300,
                            child: post.cover == ""
                                ? null
                                : FittedBox(
                                    alignment: Alignment.centerLeft, // 设置图片左对齐

                                    child: FadeInImage(
                                      placeholder: AssetImage(
                                        'assets/community/detailedPost1.jpg',
                                      ),
                                      // 占位符图片的路径
                                      image: NetworkImage(post.cover),
                                      fit: BoxFit.scaleDown,
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                          );
                      }
                    },
                  ),

                  // 这里添加帖子底部按钮组

                  Row(
                    // 按钮组平均分配水平空间
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.monitor_heart_outlined,
                            size: iconSize,
                            color: fontColor,
                          ),
                          label: Text(
                            post.view_num.toString(),
                            style: TextStyle(
                              fontSize: fontSize,
                              color: fontColor,
                            ),
                          ),
                          onPressed: () {
                            // 阅读量逻辑
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.chat_outlined,
                            size: iconSize,
                            color: fontColor,
                          ),
                          label: Text(
                            post.comment_num.toString(),
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
                            post.forward_num.toString(),
                            style: TextStyle(
                              fontSize: fontSize,
                              color: fontColor,
                            ),
                          ),
                          onPressed: () {
                            // 分享逻辑
                          },
                        ),
                      ),
                      Expanded(
                          child: TextButton.icon(
                        icon: Icon(
                          post.is_liked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: iconSize,
                          color: fontColor,
                        ),
                        label: Text(
                          post.like_num.toString(),
                          style: TextStyle(
                            fontSize: fontSize,
                            color: fontColor,
                          ),
                        ),
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {
                          // 喜欢逻辑：爱心变成实心，点赞数量加1
                          communityLogic.likePost();

                          // 更新点赞状态
                          setState(() {
                            post.is_liked = !post.is_liked;
                          });
                          // post.is_liked = !post.is_liked;
                          // Get.find<CommunityLogic>().update(/*['like.button']*/);
                        },
                      )),
                    ],
                  ),
                  // 帖子之间分割线
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
