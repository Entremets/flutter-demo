// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserName(String name);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> getUserProfile() async {
    try {
      // 发起 GET 请求
      final response = await dioClient.dio.get('/users/1'); 
      
      if (response.statusCode == 200) {
        // 将 JSON 转换为 Model
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // DioException 已经包含了网络错误、超时、401 等
      // 拦截器已经处理了 401 的全局逻辑，这里只需抛出异常让上层知道失败
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<UserModel> updateUserName(String name) async {
    final response = await dioClient.dio.patch(
      '/users/1',
      data: {'name': name},
    );
    
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update name');
    }
  }
}