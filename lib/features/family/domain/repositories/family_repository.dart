abstract class FamilyRepository {
  /// Une al usuario [userId] a la familia identificada por [joinCode].
  /// Devuelve el [familyId] de la familia encontrada.
  Future<String> joinByCode(String userId, String joinCode);
}
