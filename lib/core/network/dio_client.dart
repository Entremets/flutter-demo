// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:logger/logger.dart';
import '../storage/secure_storage.dart'; // 引入
import '../auth/auth_notifier.dart'; // 引入认证管理器，用于处理 401
class DioClient {
  late final Dio _dio;
  final AuthNotifier? authNotifier; // 可选：用于在拦截器中触发登出
  final Logger _logger = Logger();

  
  
  
  final SecureStorageService _secureStorage; // 🔥 注入安全存储服务
  DioClient({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    this.authNotifier,
     required SecureStorageService secureStorage
  }):_secureStorage = secureStorage
   {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? 'https://api.example.com', // 替换为你的真实 API 地址
        connectTimeout: connectTimeout ?? const Duration(seconds: 15),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.addAll([
      _AuthInterceptor(authNotifier,secureStorage), // 自定义拦截器：处理 Token 和 401
      LogInterceptor( // Dio 自带的日志拦截器
        requestBody: true,
        
        responseBody: true,
        
        error: true,
        logPrint: (obj) => _logger.i(obj), // 使用 logger 打印
      ),
    ]);
  }

  Dio get dio => _dio;

}

// 自定义拦截器：处理 Token 注入和 401 错误
class _AuthInterceptor extends Interceptor {
  final AuthNotifier? authNotifier;
  final SecureStorageService _secureStorage; // 1. 添加成员变量

  // 🔴 如果你想在拦截器里也用 logger，也需要在这里定义一个
  final Logger _logger = Logger(); 
  _AuthInterceptor(this.authNotifier,this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. 如果有 Token，自动添加到 Header
    // 实际项目中，你应该从 SharedPreferences 或 SecureStorage 读取 Token
    // 这里模拟一个 Token
    final token = _secureStorage.readAccessToken(); 
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 2. 处理 401 Unauthorized
    if (err.response?.statusCode == 401) {
      _logger.e("收到 401 错误，Token 可能已过期");
      
      // 通知全局状态管理器，触发路由跳转
      authNotifier?.logout(expired: true);
    }
    
    // 统一错误转换 (可选)
    // 你可以把 DioException 转换成你 domain 层定义的 Failure 或 Exception
    handler.next(err);
  }
}