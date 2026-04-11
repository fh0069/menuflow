import '../repositories/family_repository.dart';

class JoinFamily {
  final FamilyRepository _repository;

  JoinFamily(this._repository);

  Future<String> call(String userId, String joinCode) {
    return _repository.joinByCode(userId, joinCode);
  }
}
