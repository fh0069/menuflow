import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;

  LoginUser(this._repository);

  Future<User> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email, password);
  }
}