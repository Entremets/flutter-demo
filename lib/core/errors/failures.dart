// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {} // 本地存储失败
class InvalidInputFailure extends Failure {} // 输入无效