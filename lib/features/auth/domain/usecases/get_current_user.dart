import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso que obtiene el usuario autenticado actual,
/// o null si no existe una sesión activa.
/// Pertenece al dominio porque expresa una intención de negocio
/// sin conocer cómo se resuelve técnicamente.
class GetCurrentUser {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  Future<User?> call() {
    return _repository.getCurrentUser();
  }
}
