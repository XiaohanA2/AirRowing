import 'package:flutter/material.dart';

class EditInfoPage extends StatelessWidget {
  const EditInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 15.0), // 设置自定义高度
        child: AppBar(

          title: Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Text('编辑资料'),
          ),
          centerTitle: true, // 标题居中
          leading: Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),

      body: EditInfoBody(),
    );
  }
}

class EditInfoBody extends StatelessWidget {
  List menuTitles = [
    '编辑资料',
    '个性签名',
    '性别',
    '生日',
    '俱乐部',
    '荣誉橱窗',
    '背景图',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 50), // 添加间距
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // 圆形形状描边头像
                    border: Border.all(
                        color: Color.fromRGBO(17, 72, 244, 1.0),
                        width: 2), // 蓝色边框
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("https://airrowing-1318433228.cos.ap-shanghai.myqcloud.com/front_end/a2.jpg"),
                    radius: 60,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(77, 77, 77, 1.0), // 灰色背景
                      shape: BoxShape.circle, // 圆形形状
                    ),
                    padding: EdgeInsets.all(5), // 内边距
                    child: GestureDetector(
                      onTap: () {
                        // 在此处添加点击相机图标后的操作
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white, // 白色相机图标
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 40), //头像与下面的文字列表的间距
            for (int i = 0; i < menuTitles.length; i++)
              Column(
                children: [
                  ListTile(
                    title: i == 0
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 使子组件在水平方向上均匀分布
                      children: [
                        Text(menuTitles[i]),
                        Row(
                          children: [
                            SizedBox(width: 10), // 添加间距
                            Text(
                              '用户名', // 这里是假数据，可以根据实际情况填充
                              style: TextStyle(
                                  color: Colors.black), // 使用黑色字体
                            ),
                          ],
                        ),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 使子组件在水平方向上均匀分布
                      children: [
                        Text(menuTitles[i]),
                        Row(
                          children: [
                            SizedBox(width: 10), // 添加间距
                            if (i == 5)
                              _buildHonorWidget()
                            else if (i == 6)
                              _buildBackgroundWidget()
                            else
                              _buildSubtitle(i), // 显示相应的信息
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios), //此处加每个>的点击逻辑
                  ),
                  if (i < menuTitles.length - 1)
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15.0), // 添加水平方向的间距
                      child: Divider(),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle(int index) {
    String? subtitleText;
    switch (index) {
      case 1:
        subtitleText = '留下个性签名...';
        break;
      case 2:
        subtitleText = '选择性别';
        break;
      case 3:
        subtitleText = '选择生日';
        break;
      case 4:
        subtitleText = '选择俱乐部';
        break;
      default:
        subtitleText = null;
    }
    return subtitleText != null
        ? Text(
            subtitleText,
            style: TextStyle(color: Colors.grey),
          )
        : SizedBox(); // 如果没有 subtitle，返回一个空的 SizedBox
  }

  Widget _buildHonorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.dashboard,
            color: Colors.black,
          ) // Layout Dashboard 图标
        ],
      ),
    );
  }

  Widget _buildBackgroundWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'assets/community/detailedPost1.jpg', // 替换为背景图像URL
            width: 100, // 图像的宽度
            height: 80, // 图像的高度
            fit: BoxFit.cover, // 根据需要调整图像大小以适应容器
          ),
        ],
      ),
    );
  }
}
