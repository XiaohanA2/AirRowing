import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeState {
  // 输入框控制器
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  // 错误信息
  final RxString errorMessage = ''.obs;
}