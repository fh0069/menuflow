import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Stream<User?> authStateChanges() {
    return remoteDataSource.authStateChanges().map((model) => model?.toEntity());
  }

  @override
  Future<User?> getCurrentUser() async {
    final model = await remoteDataSource.getCurrentUser();
    return model?.toEntity();
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final model = await remoteDataSource.register(name, email, password);
    return model.toEntity();
  }

  @override
  Future<User> login(String email, String password) async {
    final model = await remoteDataSource.login(email, password);
    return model.toEntity();
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }
}
