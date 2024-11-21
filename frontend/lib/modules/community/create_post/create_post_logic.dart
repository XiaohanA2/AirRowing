import 'package:get/get.dart';
import '../../login/login_logic.dart';
import 'create_post_state.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../request_client.dart'; // 导入RequestClient类

class CreatePostLogic extends GetxController {
  final CreatePostState state = CreatePostState();
  late RequestClient _requestClient;
  final UserController userController = Get.find();

  @override
  void onInit() {
    super.onInit();
    // 初始化请求
    _requestClient = RequestClient();
  }

  // 标题编辑控制器
  TextEditingController titleController = TextEditingController();

  // 文本编辑控制器
  TextEditingController textController = TextEditingController();

  //拍照
  Future _getImageFromCamera() async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 400);

    if (image != null) {
      state.images.add(File(image.path));
      print("从摄像头添加照片");
    } // 使用XFile的path创建File对象

    update();
  }

  //相册选择
  Future _getImageFromGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) state.images.add(File(image.path));

    update();
  }

  // List<File> get images => images; // 提供一个获取图片列表的方法

  void takePhotoFromCamera() {
    _getImageFromCamera();
  }

  void takePhotoFromGallery() {
    _getImageFromGallery();
  }

  // 点击右上角发送帖子
  void sendPost() {
    print("Send icon tapped!");

    for (var image in state.images) {
      print("12312312323");
      imageUpload(image);
    }

    // 发送帖子
    postCreate();

    // 清空暂存照片
    state.images.clear();
    // 清空暂存文字
    textController.clear();

    // 回到社区页面
    Get.toNamed('/community');
  }

  // 向后端发送请求：发送帖子
  Future<void> postCreate() async {
    //int userId = userController.userId.value; // 目前登录用户的id
    int userId = 6101;

    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/post/create',
      method: 'POST',
      queryParameters: {
        "title": titleController.text,
        "content": textController.text,
        "userId": userId,
        "uploadfileId": 0, //应该是list
        "location": "0.0.0.0"
      },
    );
    await (response);
    print(response);
    print(titleController.text);
  }

  // 上传文件接口
  Future<void> imageUpload(File file) async {
    //-----
    // 确保传输对象不为空
    if (file == null) {
      print('Error: No file selected');
      return;
    }
    print("nbnbnbnb");
    final response = await _requestClient.request<Map<String, dynamic>>(
      '/app-api/community/upload/upload_image',
      method: 'POST',
      data: {
        "file": file,
        "uploaderName": "tester",
      },
    );
    print("7878789");
    print(response);
    await (response);
  }
}
