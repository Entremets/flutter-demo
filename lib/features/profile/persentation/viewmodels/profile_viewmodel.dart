// lib/features/profile/presentation/viewmodels/profile_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../state/profile_state.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_name.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetUserProfile getUserProfile;
  final UpdateUserName updateUserName;

  ProfileState _state = ProfileState.initial;
  ProfileState get state => _state;

  
  ProfileViewModel({
    required this.getUserProfile,
    required this.updateUserName,
  });

  // 初始化加载
  Future<void> loadProfile() async {
    _state = ProfileState.loading;
    notifyListeners();

    try {
      final user = await getUserProfile();
      _state = ProfileState.success(user);
    } catch (e) {
      _state = ProfileState.error(e.toString());
    }
    notifyListeners();
  }

  // 更新用户名
  Future<void> updateName(String newName) async {
    // 如果当前已经有用户数据，可以先 optimistic update (可选)，这里为了简单先显示 loading
    if (_state.status != ProfileStatus.success) return;
    
    _state = _state.copyWith(status: ProfileStatus.loading);
    notifyListeners();

    
    
    
    try {
      final updatedUser = await updateUserName(newName);
      _state = ProfileState.success(updatedUser);
    } catch (e) {
      _state = ProfileState.error(e.toString());
    }
    notifyListeners();
  }
  
  // 清除错误
  void clearError() {
    if (_state.status == ProfileStatus.error) {
       // 保留用户数据，只清除错误信息，回到 success 状态
       _state = _state.copyWith(status: ProfileStatus.success, errorMessage: null);
       notifyListeners();
    }
  }
}