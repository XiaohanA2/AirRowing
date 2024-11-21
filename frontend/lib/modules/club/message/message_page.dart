import 'package:air_rowing/modules/club/message/message_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../club_logic.dart';
import '../club_routes.dart';
import '../club_state.dart';
import '../clubDrawer/drawer_page.dart';


class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubLogic());
    final logic = Get.find<ClubLogic>();
    final state = logic.state;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0, // 调整需要的高度
          title: Text(
            "消息列表", // Add your title text here
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true, // Center the title
          actions: [
            IconButton(
              onPressed: () {

              },
              icon: CircleAvatar(
                backgroundColor: Colors.white, // 设置背景色为白色
                backgroundImage: AssetImage(state.clubInfo.value.clubSrc),
              ),
            ),
          ],
        ),

        body: MessageList(),
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(MessageLogic());
    final state = logic.state;

    return Obx(() {
      if (state.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (state.messageList.isEmpty) {
        return Center(child: Text('暂无消息'));
      } else {
        return ListView.builder(
          itemCount: state.messageList.length,
          itemBuilder: (context, index) {
            final message = state.messageList[index];
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(message.senderLogo),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message.senderName),
                          SizedBox(height: 15),
                        ],
                      ),
                      Text(
                        _formatTime(message.time),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  subtitle: Text(message.content),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Divider(),
                  ),
                ),
              ],
            );
          },
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }
}