part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class Unauthenticated extends AuthState {}
