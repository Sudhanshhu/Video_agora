import 'package:ecommerce/src/home/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final List<ApiUser> users;
  final HomeStatus status;
  final String? error;

  const HomeState({
    this.users = const [],
    this.status = HomeStatus.initial,
    this.error,
  });

  HomeState copyWith({
    List<ApiUser>? users,
    HomeStatus? status,
    String? error,
  }) {
    return HomeState(
      users: users ?? this.users,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [users, status, error];
}
