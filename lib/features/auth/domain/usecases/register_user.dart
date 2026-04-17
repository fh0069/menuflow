import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository _repository;

  RegisterUser(this._repository);

  Future<User> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.register(name, email, password);
  }
}