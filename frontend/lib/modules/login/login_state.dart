import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginState {
  // 输入框控制器
  TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // 错误信息
  final RxString errorMessage = ''.obs;
}
