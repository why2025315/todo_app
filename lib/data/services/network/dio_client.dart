import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:todo_app/config/dio.dart';

// lib/data/services/network/dio_client.dart
class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: DioConfig.baseUrl,
        connectTimeout: Duration(milliseconds: DioConfig.timeout),
        receiveTimeout: Duration(milliseconds: DioConfig.timeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 添加拦截器
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // 请求拦截器
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 可以在这里添加认证令牌、日志等
          if (kDebugMode) {
            print('Request: ${options.method} ${options.uri}');
            print('Headers: ${options.headers}');
            if (options.data != null) {
              print('Data: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 可以在这里统一处理响应数据
          if (kDebugMode) {
            print('Response: ${response.statusCode} ${response.statusMessage}');
            print('Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // 可以在这里统一处理错误
          if (kDebugMode) {
            print('Error: ${e.message}');
            print('Error Type: ${e.type}');
            if (e.response != null) {
              print('Error Response: ${e.response?.data}');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
