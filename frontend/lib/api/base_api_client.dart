import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BaseApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: const Duration(milliseconds: 5000), // 使用 Duration 类型
    receiveTimeout: const Duration(milliseconds: 3000), // 使用 Duration 类型
    headers: {
      "Content-Type": "application/json",
    },
  ));

  // 添加拦截器，自动添加 Authorization Header
  static void addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // Continue
      },
    ));
  }

  // POST 请求
  static Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      throw Exception("POST request failed: $e");
    }
  }
}
