// lib/core/auth/auth_notifier.dart
import 'package:flutter/foundation.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = true; // 假设初始已登录
  bool _isTokenExpired = false; // 标记是否因 401 过期

  bool get isLoggedIn => _isLoggedIn;
  bool get isTokenExpired => _isTokenExpired;

  // 模拟登录
  void login() {
    _isLoggedIn = true;
    _isTokenExpired = false;
    notifyListeners();
  }

  // 模拟登出或 Token 过期
  void logout({bool expired = false}) {
    _isLoggedIn = false;
    _isTokenExpired = expired;
    notifyListeners(); // 🔥 关键：通知所有监听者（包括 GoRouter）
  }
  
  void clearExpiredFlag() {
    _isTokenExpired = false;
    notifyListeners();
  }
}