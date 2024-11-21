import 'package:get/get.dart';

class MessageState {
  MessageState() {
    ///Initialize variables
  }

  var messageList = <Message>[].obs;
  var isLoading = false.obs;

}

class Message {
  final String content;
  final DateTime time;
  final String senderName;
  final String senderLogo;

  Message({
    required this.content,
    required this.time,
    required this.senderName,
    required this.senderLogo,
  });
}