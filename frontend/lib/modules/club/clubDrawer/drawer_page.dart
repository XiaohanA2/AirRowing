import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Drawer(
        child: Container(
          color: Colors.white, // 设置背景色为白色
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20),
            children: <Widget>[
              ListTile(
                title: Text('训练&比赛'),
                onTap: () {
                  // 处理选项1的操作
                  Navigator.pop(context); // 关闭侧边栏
                  Navigator.pushNamed(context, '/club'); // 替换当前页面
                },
              ),
              ListTile(
                title: Text('我的俱乐部'),
                onTap: () {
                  Navigator.pop(context); // 关闭侧边栏
                  Navigator.pushNamed(context, '/club/myClub'); // 替换当前页面
                },
              ),
              ListTile(
                title: Text('俱乐部列表'),
                onTap: () {
                  Navigator.pop(context); // 关闭侧边栏
                  Navigator.pushNamed(context, '/club/allClub'); // 替换当前页面
                },
              ),
              ListTile(
                title: Text('个人出勤'),
                onTap: () {
                  Navigator.pop(context); // 关闭侧边栏
                  Navigator.pushNamed(context, '/club/attendance'); // 替换当前页面
                },
              ),
              ListTile(
                title: Text('个人信箱'),
                onTap: () {
                  Navigator.pop(context); // 关闭侧边栏
                  Navigator.pushNamed(context, '/club/message'); // 替换当前页面
                },
              ),
              // 添加更多的列表项...
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AppDrawer extends StatelessWidget {
//   final Function(int) onItemTapped;
//
//   const AppDrawer({required this.onItemTapped});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.4,
//       child: Drawer(
//         child: Container(
//           color: Colors.white,
//           child: ListView(
//             padding: EdgeInsets.symmetric(vertical: 20),
//             children: <Widget>[
//               ListTile(
//                 title: Text('训练&比赛'),
//                 onTap: () {
//                   onItemTapped(0); // 切换到训练列表
//                 },
//               ),
//               ListTile(
//                 title: Text('我的俱乐部'),
//                 onTap: () {
//                   onItemTapped(1); // 切换到比赛列表
//                 },
//               ),
//               ListTile(
//                 title: Text('俱乐部列表'),
//                 onTap: () {
//                   onItemTapped(2); // 切换到比赛列表
//                 },
//               ),
//               ListTile(
//                 title: Text('个人出勤'),
//                 onTap: () {
//                   onItemTapped(3); // 切换到比赛列表
//                 },
//               ),
//               ListTile(
//                 title: Text('个人信箱'),
//                 onTap: () {
//                   onItemTapped(4); // 切换到比赛列表
//                 },
//               ),
//               // 添加其他列表项...
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
