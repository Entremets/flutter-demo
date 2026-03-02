// lib/features/profile/data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id, required super.name, required super.email});

  // 从 SharedPreferences 读取
  factory UserModel.fromSpMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    
    );
  }

  // lib/features/profile/data/models/user_model.dart 补充
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? json['username'] ?? 'Unknown', // 适配不同 API
      email: json['email'] ?? 'no-email@example.com',
    );
  }

  // 转为 Map 存入 SharedPreferences
  Map<String, dynamic> toSpMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // 从 Entity 转换过来
  factory UserModel.fromEntity(User user) {
    return UserModel(id: user.id, name: user.name, email: user.email);
  }
}
