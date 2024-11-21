import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // 删除本地存储的 token
  }
}
