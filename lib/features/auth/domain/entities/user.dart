/// Esta entidad contiene la información básica del usuario
/// y se utiliza en la lógica de negocio de la aplicación.
///
/// Forma parte de la capa de dominio, por lo que es independiente
/// de Firebase, de la interfaz de usuario y de cualquier detalle
/// de infraestructura.
class User {
  final String id;
  final String name;
  final String email;
  final DateTime registrationDate;

  // Relación con familia
  final String? familyId;

  // Rol dentro de la familia (admin / member)
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