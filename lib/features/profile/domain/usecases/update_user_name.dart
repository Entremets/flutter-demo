// lib/features/profile/domain/usecases/update_user_name.dart
import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateUserName {
  final ProfileRepository repository;

  UpdateUserName(this.repository);

  Future<User> call(String newName) async {
    if (newName.trim().isEmpty) {
      throw Exception("名字不能为空"); // 简单业务规则验证
    }
    return await repository.updateUserName(newName);
  }
}