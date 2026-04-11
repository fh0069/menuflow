import '../../domain/repositories/family_repository.dart';
import '../datasources/family_remote_datasource.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  final FamilyRemoteDataSource _dataSource;

  FamilyRepositoryImpl(this._dataSource);

  @override
  Future<String> joinByCode(String userId, String joinCode) {
    return _dataSource.joinByCode(userId, joinCode);
  }
}
