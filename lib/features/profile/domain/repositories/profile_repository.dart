// lib/features/profile/domain/repositories/profile_repository.dart
import '../entities/user.dart';


abstract class ProfileRepository {
  Future<User> getUserProfile();
  Future<User> updateUserName(String newName);
}