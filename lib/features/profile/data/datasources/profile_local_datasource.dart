// lib/features/profile/data/datasources/profile_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserModel> getUser();
  Future<void> saveUser(UserModel user);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getUser() async {
    // 模拟读取，如果没有数据则返回默认数据或抛异常
    final jsonString = sharedPreferences.getString('user_profile');
    if (jsonString != null) {
      // 这里为了演示简单，直接存 Map 的字符串化，实际建议用 jsonEncode
      // 简化起见，我们假设 SP 里存的是简单的 key-value 组合
      final Map<String, dynamic> data = {
        'id': sharedPreferences.getString('user_id') ?? '001',
        'name': sharedPreferences.getString('user_name') ?? 'Guest',
        'email': sharedPreferences.getString('user_email') ?? 'guest@example.com',
      };
      return UserModel.fromSpMap(data);
    } else {
      // 首次使用返回默认用户
      return const UserModel(id: '001', name: 'New User', email: 'new@example.com');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString('user_id', user.id);
    await sharedPreferences.setString('user_name', user.name);
    await sharedPreferences.setString('user_email', user.email);
  }
}