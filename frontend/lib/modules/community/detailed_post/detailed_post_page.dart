import 'package:air_rowing/modules/community/community_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'detailed_post_logic.dart';

class Detailed_postPage extends StatelessWidget {
  const Detailed_postPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PostHeader(),
      body: ListView(
        children: [
          PostImage(), // 帖子图片部分
          PostContent(), // 帖子内容部分
          PostBar(), // 帖子下方点赞栏
          PostComment(), // 帖子评论部分
        ],
      ),
      bottomNavigationBar: CommentBar(),
    );
  }
}

// 帖子台头部分
class PostHeader extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(65.0); // 此处设置AppBar的高度
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 获取详细页的具体帖子
      var detailedPost = Get.find<DetailedPostLogic>().state.detailedPost;
      print(detailedPost);

      // print(detailedPost['content']);
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // 在这里添加菜单按钮被点击时的操作
            // 返回上一个页面
            Navigator.of(context).pop();
          },
        ),
        leadingWidth: 25,
        title: InkWell(
          onTap: () {
            print(detailedPost().author);
            // 导航到个人主页
            Get.find<CommunityLogic>().viewPersonalHome(1);
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20, // 设置头像半径
                backgroundImage: NetworkImage(detailedPost().imageUrl),
              ),
              SizedBox(width: 10.0), // 添加一些间距
              Text(detailedPost().author),
            ],
          ),
        ),
        actions: [
          GetBuilder<DetailedPostLogic>(builder: (controller) {
            return TextButton(
              onPressed: () {
                // 按钮点击事件处理
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('确认'),
                      content: Text(
                          detailedPost().is_followed ? '确认要取消关注吗？' : '确认要关注吗？'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('取消'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('确认'),
                          onPressed: () {
                            print("关注按钮被点击了");
                            // // 调用逻辑层的方法来切换关注状态
                            // Get.find<DetailedPostLogic>().toggleFollowUser(0);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  detailedPost().is_followed
                      ? Colors.grey // 已关注状态的背景色
                      : Color.fromRGBO(17, 72, 244, 1.0), // 未关注状态的背景色
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    detailedPost().is_followed ? Icons.check : Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    detailedPost().is_followed ? '已关注' : '关注',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ],
              ),
            );
          }),
          IconButton(
            icon: Icon(Icons.ios_share),
            onPressed: () {
              // 处理搜索按钮点击事件
            },
          ),
        ],
      );
    });
  }
}

// 帖子图片部分：图片
class PostImage extends StatefulWidget {
  @override
  State<PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  int currentIndex = 0; //图片轮播
  final double maxHeight = 300.0; // 设置最大高度
  @override
  Widget build(BuildContext context) {
    final DetailedPostLogic logic = Get.find();

    // 获取详细页的具体帖子
    final detailedPost = logic.state.detailedPost;

    final List<String> imageUrls = detailedPost().imageUrls;

    return Column(
      children: [
        Container(
          height: maxHeight, // 调整图片栏高度
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            }, //滑动到一个页面就更新状态
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                fit: BoxFit
                    .fitHeight, // 图片填充方式，现在是固定高度，宽度自适应，这里准备修改逻辑，设定一个固定高度如300，高度高于这个的高度自适应，高度低于这个的，宽度自适应
              );
            },
          ),
        ),
        //   添加指示器
        const SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imageUrls.length,
              (index) => Indicator(isActive: index == currentIndex)),
        ),
        const SizedBox(
          height: 5.0,
        ),
      ],
    );
  }
}

// 帖子图片部分：图片下方指示器
class Indicator extends StatelessWidget {
  const Indicator({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: isActive ? 10.0 : 6.0, //修改一下宽度表示滑动到这个indicator了
      height: 6.0,
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromRGBO(17, 72, 244, 1.0)
            : Colors.grey[400],
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}

// 帖子文字部分
class PostContent extends StatelessWidget {
  final double fontSize = 12;
  final fontColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final DetailedPostLogic logic = Get.find();

    // 获取详细页的具体帖子
    final detailedPost = logic.state.detailedPost;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0), // 添加左右的空白
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 设置文本从左边开始
            children: [
              Text(
                detailedPost().title,
                style: TextStyle(
                  fontSize: 24, // 设置标题字号
                  fontWeight: FontWeight.bold, // 设置标题加粗
                ),
                textAlign: TextAlign.left, // 文本左对齐
              ),
              SizedBox(height: 8), // 添加一个间距
              Text(
                detailedPost().content,
                style: TextStyle(
                  fontSize: 16, // 设置内容字号
                  fontWeight: FontWeight.normal, // 设置内容正常字体重量
                ),
                textAlign: TextAlign.left, // 文本左对齐
              ),

              SizedBox(
                height: 28.0,
              ), // 空行
              // 帖子底部信息
              Row(
                children: [
                  Text(
                    detailedPost().time + ' ',
                    style: TextStyle(
                      color: fontColor, // 设置文本颜色
                      fontSize: fontSize, // 设置字体大小
                    ),
                  ),
                  Text(
                    detailedPost().ip + ' ',
                    style: TextStyle(
                      color: fontColor, // 设置文本颜色
                      fontSize: fontSize, // 设置字体大小
                    ),
                  ),
                  Text(
                    detailedPost().view_num.toString() + '次浏览',
                    style: TextStyle(
                      color: fontColor, // 设置文本颜色
                      fontSize: fontSize, // 设置字体大小
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ), // 空行
            ]));
  }
}

class CommentBar extends StatefulWidget {
  const CommentBar({super.key});

  @override
  State<CommentBar> createState() => _CommentBarState();
}

class _CommentBarState extends State<CommentBar> {
  bool _isInputWords = false;

  // 评论输入框
  final TextEditingController _textCommentEditingController =
      new TextEditingController();

  // 焦点
  final FocusNode _focusNode = FocusNode();

  // // 键盘高度
  // final double _keyboardHeight = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //   监控键盘输入
    _textCommentEditingController.addListener(() {
      setState(() {
        _isInputWords = _textCommentEditingController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textCommentEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DetailedPostLogic logic = Get.find();
    int postId = logic.state.detailedPost().postId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: MediaQuery.of(context).viewInsets,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      //  绘制输入框
                      controller: _textCommentEditingController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "评论",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black26,
                          letterSpacing: 2,
                        ),
                      ),
                      maxLines: 1,
                      minLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),
                  //   这里不加表情符号

                  //   发送按钮
                  ElevatedButton(
                      onPressed: () {
                        print("发送评论");
                        String content = _textCommentEditingController.text;
                        print(_textCommentEditingController.text);
                        // 调用方法向后端发送评论
                        logic.addComment(postId, content);
                        // 清空输入框内容
                        _textCommentEditingController.clear();
                        // 取消焦点，取消输入框
                        _focusNode.unfocus();
                        // 刷新帖子
                        logic.getPostComments(postId);
                        // 刷新
                        setState(() {});
                      },
                      child: const Text(
                        "发送",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 帖子文字下方功能区域部分
class PostBar extends StatefulWidget {
  @override
  State<PostBar> createState() => _PostBarState();
}

class _PostBarState extends State<PostBar> {
  // 各个组件的属性
  final double iconSize = 24;

  final double fontSize = 12;

  final fontColor = Colors.grey;

  bool isLiked = false;
  bool isCollected = false;

  @override
  Widget build(BuildContext context) {
    final DetailedPostLogic logic = Get.find();

    // 获取详细页的具体帖子
    final detailedPost = logic.state.detailedPost;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0), // 添加左右的空白

        child: Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(
                      detailedPost().is_liked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      // 根据点赞状态选择图标
                      size: iconSize,
                      color: detailedPost().is_liked
                          ? Colors.red
                          : fontColor, // 根据点赞状态选择颜色
                    ),
                    label: Text(
                      detailedPost().like_num.toString(),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: fontColor,
                      ),
                    ),
                    onPressed: () {
                      // 点赞逻辑
                      setState(() {
                        logic.likePost(detailedPost().postId);
                        print(detailedPost().is_liked);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.comment,
                      size: iconSize,
                      color: fontColor,
                    ),
                    label: Text(
                      detailedPost().comment_num.toString(),
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
                      detailedPost().is_favorited
                          ? Icons.star
                          : Icons.star_border,
                      // 根据收藏状态选择图标
                      size: iconSize,
                      color: detailedPost().is_favorited
                          ? Colors.orange
                          : fontColor, // 根据收藏状态选择颜色
                    ),
                    label: Text(
                      detailedPost().favorite_num.toString(),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: fontColor,
                      ),
                    ),
                    onPressed: () {
                      //收藏逻辑
                      setState(() {
                        logic.favoritePost(detailedPost().postId);
                        // print(detailedPost().is_favorited);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.more_horiz,
                      size: iconSize,
                      color: fontColor,
                    ),
                    label: Text(""),
                    onPressed: () {
                      // 其他逻辑
                    },
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ));
  }
}

// 帖子评论部分，需要用Obx包裹，以便实时更新
class PostComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = Get.put(DetailedPostLogic());

    // 获取详细页的具体帖子
    final comments = Get.find<DetailedPostLogic>().state.comments;

    return Obx(
      () => Column(
        children: [
          for (var comment in comments)
            Column(
              children: [
                // 每条评论的内容
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0), // 添加左右的空白
                  child: ListTile(
                    // 头像
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(comment.imageUrl),
                    ),
                    // 评论作者
                    title: Text(
                      comment.author,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold, // 设置字体粗细
                      ),
                    ),
                    // 评论内容
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.content),
                        // 发布时间与ip地址
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${comment.time} ${comment.ip}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                )),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                        Text('${comment.like_num}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 5,
                            )),
                      ],
                    ),
                  ),
                ),
                // 分割线，最后一条评论后不添加分割线
                if (comment != comments.last)
                  Divider(
                    thickness: 1,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
