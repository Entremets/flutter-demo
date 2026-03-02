// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage(
    // Android 配置
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // 强制使用加密 SP
    ),
    // iOS 配置
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // 写入 Token
  Future<void> writeToken({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // 读取 Token
  Future<String?> readAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // 删除 Token (登出时调用)
  Future<void> deleteToken() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
  
  // 清空所有 (可选)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}