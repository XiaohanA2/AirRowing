import 'package:air_rowing/modules/login/login_logic.dart';
import 'package:get/get.dart';
import '../../../request_client.dart';
import 'message_state.dart';

class MessageLogic extends GetxController {
  final MessageState state = MessageState();
  late RequestClient _requestClient;
  late UserController userController = Get.find();

  @override
  void onInit() {
    super.onInit();
    // Mock data, replace with actual data fetching logic
    _requestClient = RequestClient();
    getMsg();

  }

  // 获取消息列表
  Future<void> getMsg() async {
    // final Map<String, dynamic> arguments = Get.arguments;
    // int userId = arguments['userId']; // 目前登录用户的id

    state.isLoading.value = true;
    //int userId = userController.userId();
    int userId = 6101;
    print("msg里面的userid是：${userId}");

    final response = await _requestClient.request<List<dynamic>>(
      '/app-api/club/notification/get',
      // 这里很奇怪，为什么不能直接加进去
      queryParameters: {"userId": userId},
    );
    print("The msgresponse is ${response.data}");
    // 确保响应数据不为空
    if (response.data != null) {
      List<Message> msgList = (response.data as List).map((item) {
        Message message = Message(
            content: item["content"],
            time: DateTime.fromMillisecondsSinceEpoch(item["notificationTime"]),
            senderName: item["clubName"],
            senderLogo: "assets/club/club_avatar.jpg");
        return message;
      }).toList();
      // 将转换后的列表赋值给state的trainingList
      state.messageList.value = msgList;
    }

    state.isLoading.value = false;
  }
}
