import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestClient {
  late Dio _dio;
  late String baseUrl = dotenv.env['baseUrl']!;

  late String Authorization = dotenv.env['Authorization']!;
  late String tenant_id = dotenv.env['tenant-id']!;

  RequestClient() {
    _dio = Dio(BaseOptions(
      baseUrl: this.baseUrl,
      connectTimeout: Duration(milliseconds: 5000), // 连接超时时间
      receiveTimeout: Duration(milliseconds: 3000), // 接收超时时间
    ));

    // 添加拦截器（例如，用于日志记录、错误处理）
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<ApiResponse<T>> request<T>(
      String path, {
        String method = 'GET',
        dynamic data,
        Map<String, dynamic>? queryParameters,
        T Function(dynamic)? fromJsonT,
        Map<String, dynamic>? headers,
      }) async {
    headers ??= {
      'Authorization': Authorization,
      'tenant-id': tenant_id,
    };
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      );
      if (fromJsonT != null && response.data != null) {
        return ApiResponse.fromResponse(response, fromJsonT);
      } else {
        return ApiResponse<T>(
          statusCode: response.statusCode ?? 0,
          message: response.statusMessage ?? "Success",
          data: response.data['data'] as T?,
        );
      }
    } on DioError catch (e) {
      return ApiResponse.fromError(e);
    }
  }
}

/*
* Response有三个数据成员，分别是statusCode,message和data
* */
class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T? data;

  ApiResponse({required this.statusCode, required this.message, this.data});

  factory ApiResponse.fromResponse(
      Response response, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      statusCode: response.statusCode ?? 0,
      message: "Success",
      data: fromJsonT(response.data),
    );
  }

  factory ApiResponse.fromError(DioError error) {
    return ApiResponse<T>(
      statusCode: error.response?.statusCode ?? 0,
      message: error.message!,
      data: null,
    );
  }
}
