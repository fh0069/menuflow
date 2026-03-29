/// Representa una familia o grupo de convivencia dentro del sistema.
///
/// Una familia agrupa a varios usuarios y permite la gestión
/// colaborativa de recetas y planificación semanal de menús.
class Family {
  final String id;
  final String name;
  final String joinCode;
  final DateTime creationDate;
  final String country;
  final String region;

  const Family({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.creationDate,
    required this.country,
    required this.region,
  });
}