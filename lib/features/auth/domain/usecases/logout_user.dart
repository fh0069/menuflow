import '../repositories/auth_repository.dart';

/// Caso de uso que cierra la sesión del usuario actual.
/// Representa la operación de logout sin conocer
/// los detalles de infraestructura.
class LogoutUser {
  final AuthRepository _repository;

  LogoutUser(this._repository);

  Future<void> call() {
    return _repository.logout();
  }
}