class Recipe {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final String familyId;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.familyId,
  });
}
