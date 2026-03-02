// lib/features/profile/presentation/state/profile_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

// 定义 UI 可能的几种状态
enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final String? errorMessage;

  const ProfileState({
    
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  // 初始状态
  static const initial = ProfileState();

  // 加载状态
  static const loading = ProfileState(status: ProfileStatus.loading);

  // 成功状态
  static ProfileState success(User user) => ProfileState(status: ProfileStatus.success, user: user);

  // 错误状态
  static ProfileState error(String message) => ProfileState(status: ProfileStatus.error, errorMessage: message);

  @override
  List<Object?> get props => [status, user, errorMessage];
  
  // 辅助方法：拷贝修改
  ProfileState copyWith({ProfileStatus? status, User? user, String? errorMessage}) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  
  
  
  }
}