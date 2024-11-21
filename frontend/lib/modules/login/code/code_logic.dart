import 'package:get/get.dart';
import 'code_state.dart';
import '/api/base_api_client.dart';
import '/api/api_constants.dart';

class CodeLogic extends GetxController {
  final CodeState state = CodeState();

  // 发送验证码
  Future<void> sendVerificationCode() async {
    String email = state.emailController.text.trim();

    if (email.isEmpty) {
      state.errorMessage.value = '请输入邮箱';
      return;
    }

    final data = {
      "email": email,
    };

    try {
      // 调用 BaseApiClient 的 POST 方法
      final response = await BaseApiClient.post(SEND_VERIFICATION_CODE_API, data: data);

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar('验证码已发送', '请查收您的邮箱');
      } else {
        state.errorMessage.value = response.data['message'] ?? '验证码发送失败';
      }
    } catch (e) {
      state.errorMessage.value = '验证码发送异常，请稍后重试';
      print("Error in sendVerificationCode: $e");
    }
  }

  // 使用验证码登录
  Future<void> loginWithCode() async {
    String email = state.emailController.text.trim();
    String code = state.codeController.text.trim();

    if (email.isEmpty || code.isEmpty) {
      state.errorMessage.value = '请填写所有字段';
      return;
    }

    final data = {
      "email": email,
      "code": code,
      "type": 1, // 指定登录类型为验证码登录
    };

    try {
      // 调用 BaseApiClient 的 POST 方法
      final response = await BaseApiClient.post(LOGIN_WITH_CODE_API, data: data);

      if (response.statusCode == 200 && response.data['success'] == true) {
        String token = response.data['data']; // 登录成功返回的 token

        // 保存 token
        final userController = Get.put(UserController());
        userController.setToken(token);

        // 提示登录成功并跳转到主页面
        Get.snackbar('登录成功', '欢迎回来');
        Get.offAllNamed('/home'); // 假设主页面路由为 '/home'
      } else {
        state.errorMessage.value = response.data['message'] ?? '登录失败';
      }
    } catch (e) {
      state.errorMessage.value = '登录异常，请稍后重试';
      print("Error in loginWithCode: $e");
    }
  }
}

// UserController 用于管理全局登录状态
class UserController extends GetxController {
  var token = ''.obs;

  void setToken(String newToken) {
    token.value = newToken;
  }

  void clearToken() {
    token.value = '';
  }
}
