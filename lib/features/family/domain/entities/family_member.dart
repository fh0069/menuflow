/// Define los roles posibles de un miembro dentro de una familia.
enum FamilyRole {
  admin,
  member,
}

/// Representa la relación entre un usuario y una familia.
///
/// Esta entidad define la pertenencia de un usuario a una familia
/// y su rol dentro de la misma.
///
/// No existe de forma independiente en el sistema, ya que siempre
/// está asociada a una familia concreta.
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