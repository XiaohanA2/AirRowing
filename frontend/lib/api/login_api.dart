import 'base_api_client.dart';
import 'api_constants.dart';

class LoginApi {
  // 发送验证码
  static Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    final response = await BaseApiClient.post(SEND_VERIFICATION_CODE_API, data: {
      "email": email,
    });

    if (response.statusCode == 200) {
      return response.data; // 返回接口返回的 JSON 数据
    } else {
      throw Exception("Failed to send verification code: ${response.statusMessage}");
    }
  }

  // 验证码登录
  static Future<Map<String, dynamic>> loginWithCode(String email, String code, int type) async {
    final response = await BaseApiClient.post(LOGIN_WITH_CODE_API, data: {
      "email": email,
      "code": code,
      "type": type,
    });

    if (response.statusCode == 200) {
      return response.data; // 返回接口的 JSON 数据
    } else {
      throw Exception("Failed to login with verification code: ${response.statusMessage}");
    }
  }

  // 密码登录
  static Future<Map<String, dynamic>> loginWithPassword(String email, String password, int type) async {
    final response = await BaseApiClient.post(LOGIN_WITH_CODE_API, data: {
      "email": email,
      "password": password,
      "type": type,
    });

    if (response.statusCode == 200) {
      return response.data; // 返回接口返回的 JSON 数据
    } else {
      throw Exception("Failed to login with password: ${response.statusMessage}");
    }
  }

  // 注销接口
  static Future<Map<String, dynamic>> logout() async {
    final response = await BaseApiClient.post(LOGOUT_API);

    if (response.statusCode == 200) {
      return response.data; // 返回接口返回的 JSON 数据
    } else {
      throw Exception("Failed to logout: ${response.statusMessage}");
    }
  }
}
