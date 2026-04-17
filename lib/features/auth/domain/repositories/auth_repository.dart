import '../entities/user.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  Future<User?> getCurrentUser();
  Future<User> register(String name, String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout();
}
