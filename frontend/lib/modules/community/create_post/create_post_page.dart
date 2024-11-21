import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_post_logic.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  _CreatePostPageState createState() => _CreatePostPageState();
}

// 页面主体结构
class _CreatePostPageState extends State<CreatePostPage> {
  CreatePostLogic createPostLogic = Get.put(CreatePostLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(), // 顶部导航栏
      body: Container(
        child: ListView(
          children: <Widget>[
            TextInput(),
            const SizedBox(
              height: 10,
            ),
            BuildImages(), // 展示选择的图片
          ],
        ),
      ),
      // bottomNavigationBar: BottomRelease(),
    );
  }
}

// 顶部导航栏
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    CreatePostLogic createPostLogic = Get.put(CreatePostLogic());

    return AppBar(
      title: Text(""),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.send), // 使用发送图标
          onPressed: () => createPostLogic.sendPost(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); // 这里设置TopBar高度
}

class TextInput extends StatelessWidget {
  // 通过Get.find获取控制器实例
  final controller = Get.put(CreatePostLogic());

  @override
  Widget build(BuildContext context) {
    double TITLESIZE = 20;
    double TEXTSIZE = 16;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          // 帖子标题
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(
              hintText: "  给帖子取个标题吧...",
              hintStyle: TextStyle(fontSize: TITLESIZE), // 设置提示字体大小为 16
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: TITLESIZE), // 设置输入的文本字体大小为 18
            maxLines: 1,
          ),
          // 帖子内容
          TextField(
            controller: controller.textController,
            decoration: InputDecoration(
              hintText: "  分享新鲜事...",
              hintStyle: TextStyle(fontSize: TEXTSIZE),
              border: InputBorder.none,
            ),
            maxLines: null, // 最大行数
            style: TextStyle(fontSize: TEXTSIZE),
          ),
        ]));
  }
}

class BuildImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          GetBuilder<CreatePostLogic>(// 使用 GetBuilder 来监听 CreatePostLogic 的变化
              builder: (logic) {
        // 使用 logic.images 来获取图片数量
        // 添加一个额外的格子用于上传
        int itemCount = logic.state.images.length + 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index < logic.state.images.length) {
              // 显示图片
              return Image.file(
                logic.state.images[index],
                fit: BoxFit.cover,
              );
            } else {
              // 最后一个格子用于添加图片
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // 背景色
                  border: Border.all(color: Colors.black54),
                ),
                child: IconButton(
                    icon: Icon(Icons.add, size: 24),
                    onPressed: () => showImageSourceActionSheet(context)),
              );
            }
          },
        );
      }),
    );
  }
}

void showImageSourceActionSheet(BuildContext context) {
  // Assuming CreatePostLogic is already instantiated and managed by GetX.
  final CreatePostLogic createPostLogic = Get.find<CreatePostLogic>();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('照相机'),
              onTap: () {
                Navigator.pop(context);
                createPostLogic.takePhotoFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('相册'),
              onTap: () {
                Navigator.pop(context);
                createPostLogic.takePhotoFromGallery();
              },
            ),
          ],
        ),
      );
    },
  );
}

// 底部确认按钮
class BottomRelease extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: ElevatedButton(
        onPressed: () {
          print("点击确认发布按钮");
        },
        child: Text('确认发布'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(203, 91, 157, 255),
        ),
      ),
    );
  }
}
