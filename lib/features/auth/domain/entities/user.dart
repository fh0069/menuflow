class User {
  final String id;
  final String name;
  final String email;
  final DateTime registrationDate;

  final String? familyId;

  // Rol dentro de la familia: 'admin' o 'member'.
  final String? role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.registrationDate,
    this.familyId,
    this.role,
  });
}