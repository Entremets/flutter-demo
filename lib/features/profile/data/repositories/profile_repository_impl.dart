// lib/features/profile/data/repositories/profile_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';

import '../datasources/profile_local_datasource.dart';
import '../models/user_model.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../../../core/auth/auth_notifier.dart';
import 'package:logger/logger.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource; // 🔥 新增
  
  final AuthNotifier authNotifier;
  final Logger _logger = Logger(); // 用于日志记录

  ProfileRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource, // 注入
    required this.authNotifier,
  });

  @override
  Future<User> getUserProfile() async {
    try {
      // 策略：优先从网络获取
      final user = await remoteDataSource.getUserProfile();
      // 获取成功后，缓存到本地
      await localDataSource.saveUser(user as UserModel);
      return user;
    } catch (e) {
      // 网络失败，尝试从本地缓存读取
      _logger.w("网络请求失败，尝试读取本地缓存: $e");
      try {
        return await localDataSource.getUser();
      } catch (localError) {
        throw Exception("无法加载数据：无网络且无缓存");
      }
    }
  }

  
  
  @override
  Future<User> updateUserName(String newName) async {
    // 直接调用网络更新
    final user = await remoteDataSource.updateUserName(newName);
    // 更新本地缓存
    await localDataSource.saveUser(user as UserModel);
    return user;
  }
}
