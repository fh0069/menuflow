import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso que registra un nuevo usuario.
/// Representa la operación de creación de cuenta
/// sin conocer los detalles de infraestructura.
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