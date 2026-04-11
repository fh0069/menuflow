import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso que autentica a un usuario.
/// Representa la operación de inicio de sesión
/// sin conocer los detalles de infraestructura.
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