import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'code_logic.dart';

class CodePage extends StatelessWidget {
  final CodeLogic logic = Get.put(CodeLogic());

  @override
  Widget build(BuildContext context) {
    double heightContext = MediaQuery.of(context).size.height;
    double widthContext = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      body: Stack(
        children: <Widget>[
          // 小标志
          Positioned(
            width: 64,
            height: 64,
            top: heightContext * 0.20,
            left: 20,
            child: Image.asset('assets/login/rowing_small_logo.png'),
          ),
          // 标题
          Positioned(
            top: heightContext * 0.26,
            left: 20,
            child: Text(
              "验证码登录",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'inter',
                fontSize: 23,
              ),
            ),
          ),
          // 登录表单
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 邮箱输入框
                  TextField(
                    controller: logic.state.emailController,
                    decoration: InputDecoration(
                      labelText: '请输入您的邮箱',
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
                  // 验证码输入框和发送验证码按钮
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: logic.state.codeController,
                          decoration: InputDecoration(
                            labelText: '请输入验证码',
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
                      ),
                      SizedBox(width: 10), // 间距
                      Expanded(
                        flex: 1,
                        child: Obx(
                              () => ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(5),
                              minimumSize: MaterialStateProperty.all<Size>(Size(60, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            onPressed: logic.isTimerRunning.value ? null : logic.sendVerificationCode,
                            child: Text(
                              logic.isTimerRunning.value
                                  ? '${logic.countdown.value}s'
                                  : '发送',
                              style: TextStyle(
                                color: logic.isTimerRunning.value
                                    ? Colors.grey
                                    : Color(0xFF1B41B2),
                                fontFamily: 'inter',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10.0)),
                  // 登录按钮
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(5),
                      minimumSize: MaterialStateProperty.all<Size>(Size(400, 50)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // 圆角半径
                        ),
                      ),
                    ),
                    onPressed: logic.loginWithCode,
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
                  // 提示文字
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      '如果是第一次登录，用户将自动注册',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'inter',
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
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
                  // 返回按钮
                  TextButton(
                    onPressed: () => Get.back(), // 返回到密码登录页面
                    child: Text('密码登录'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
