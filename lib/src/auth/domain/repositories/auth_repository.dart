import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signUp({required String email, required String password});
  Future<UserEntity?> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}
