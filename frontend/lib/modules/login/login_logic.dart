import 'package:air_rowing/api/login_api.dart';
import 'package:air_rowing/main_frame.dart';
import 'login_state.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  Future<void> loginWithPassword() async {
    String email = state.emailController.text.trim();
    String password = state.passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      state.errorMessage.value = '请填写所有字段';
      return;
    }

    try {
      // 调用密码登录接口
      final response = await LoginApi.loginWithPassword(email, password, 2);
      if (response['success'] == true) {
        String token = response['data']; // 登录成功返回的 token

        // 保存 token（可以使用 SharedPreferences 或其他方式）
        final userController = Get.put(UserController());
        userController.setToken(token);

        // 提示登录成功并跳转到主界面
        Get.snackbar('登录成功', '欢迎回来');
        Get.offAllNamed('/home'); // 跳转到 '/home' 路由
      } else {
        // 登录失败，显示错误信息
        state.errorMessage.value = response['message'] ?? '登录失败';
      }
    } catch (e) {
      state.errorMessage.value = '登录异常，请稍后再试';
    }
  }

  Future<void> loginWithCode() async {
    String email = state.emailController.text.trim();
    String code = state.codeController.text.trim();

    if (email.isEmpty || code.isEmpty) {
      state.errorMessage.value = '请填写所有字段';
      return;
    }

    try {
      // 调用验证码登录接口
      final response = await LoginApi.loginWithCode(email, code, 1);
      if (response['success'] == true) {
        String token = response['data']; // 登录成功返回的 token

        // 保存 token（可以使用 SharedPreferences 或其他方式）
        final userController = Get.put(UserController());
        userController.setToken(token);

        // 提示登录成功并跳转到主界面
        Get.snackbar('登录成功', '欢迎回来');
        Get.offAll(() => MainFrame());
      } else {
        // 登录失败，显示错误信息
        state.errorMessage.value = response['message'] ?? '登录失败';
      }
    } catch (e) {
      state.errorMessage.value = '登录异常，请稍后再试';
    }
  }

  Future<void> sendVerificationCode() async {
    String email = state.emailController.text.trim();

    if (email.isEmpty) {
      state.errorMessage.value = '请输入邮箱';
      return;
    }

    try {
      // 调用发送验证码接口
      final response = await LoginApi.sendVerificationCode(email);
      if (response['success'] == true) {
        Get.snackbar('验证码已发送', '请查收邮箱');
      } else {
        state.errorMessage.value = response['message'] ?? '验证码发送失败';
      }
    } catch (e) {
      state.errorMessage.value = '验证码发送异常，请稍后再试';
    }
  }

  Future<void> logout() async {
    try {
      // 调用注销接口
      await LoginApi.logout();

      // 清除本地保存的 token
      final userController = Get.put(UserController());
      userController.clearToken();

      // 提示注销成功并跳转到登录页面
      Get.snackbar('注销成功', '您已退出登录');
      Get.offAllNamed('/login'); // 假设登录界面路由为 '/login'
    } catch (e) {
      Get.snackbar('注销失败', '请稍后再试');
    }
  }
}

// 创建一个 UserController 来存储全局变量
class UserController extends GetxController {
  var token = ''.obs;

  void setToken(String newToken) {
    token.value = newToken;
  }

  void clearToken() {
    token.value = '';
  }
}
