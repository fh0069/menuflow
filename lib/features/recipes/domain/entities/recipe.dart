class Recipe {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final String familyId;
  final String? imageUrl;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.familyId,
    this.imageUrl,
  });
}
