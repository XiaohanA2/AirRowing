import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final LoginLogic logic = Get.put(LoginLogic());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      body: Stack(
        children: <Widget>[
          // 顶部图片
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: height / 1.8,
            child: Image.asset(
              'assets/login/open/rowing_logo.png', // 替换为你的图片路径
              fit: BoxFit.cover,
            ),
          ),
          // 中间图片
          Positioned(
            width: width,
            height: height / 2,
            left: 40,
            top: 40,
            child: Image.asset(
              'assets/login/open/every_stroke_count.png',
            ),
          ),
          // 小标志
          Positioned(
            width: 36,
            height: 36,
            top: height / 2,
            left: 0,
            child: Image.asset(
              'assets/login/rowing_small_logo.png',
            ),
          ),
          // 标题
          Positioned(
            top: height / 2,
            left: 38,
            child: Text(
              "登录 AirRowing",
              style: TextStyle(
                fontFamily: 'inter',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 23,
              ),
            ),
          ),
          // 登录表单
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 310.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // 邮箱输入框
                    TextField(
                      controller: logic.state.emailController,
                      decoration: InputDecoration(
                        labelText: '请输入您的用户名或邮箱',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 10.0)),
                    // 密码输入框
                    TextField(
                      controller: logic.state.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: '请输入您的密码',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 10.0)),
                    // 登录按钮
                    ElevatedButton(
                      onPressed: logic.loginWithPassword, // 调用密码登录方法
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(5),
                        minimumSize: MaterialStateProperty.all<Size>(Size(width * 0.92, 50)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // 圆角半径
                          ),
                        ),
                      ),
                      child: Container(
                        width: width * 0.8, // 按钮宽度为屏幕宽度
                        child: Center(
                          child: Text(
                            '登录',
                            style: TextStyle(
                              color: Color(0xFF1B41B2),
                              fontFamily: 'inter',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 错误提示
                    Obx(() => Visibility(
                      visible: logic.state.errorMessage.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          logic.state.errorMessage.value,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )),
                    // 验证码登录按钮
                    TextButton(
                      onPressed: () => Get.toNamed('/code'), // 跳转验证码登录页面
                      child: Text('验证码登录'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
