part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// abstract class AuthEvent {}
class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  const SignUpEvent(this.email, this.password);
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
