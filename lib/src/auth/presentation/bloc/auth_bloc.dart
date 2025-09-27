import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        emit(const AuthError("Email and password cannot be empty"));
        return;
      }

      // check if already loggedin
      final isLoggedIn = await authRepository.getCurrentUser();
      if (isLoggedIn != null) {
        emit(Authenticated(isLoggedIn));
        return;
      }

      final user = await authRepository.signIn(
          email: event.email, password: event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError("Failed to sign in"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signUp(
          email: event.email, password: event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError("Failed to sign up"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    await authRepository.signOut();
    emit(Unauthenticated());
  }
}
