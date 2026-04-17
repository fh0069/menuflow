enum FamilyRole {
  admin,
  member,
}

// No tiene repositorio propio; siempre está asociada a una familia.
class FamilyMember {
  final String userId;
  final FamilyRole role;
  final DateTime joinDate;

  const FamilyMember({
    required this.userId,
    required this.role,
    required this.joinDate,
  });
}