import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdBy,
    required super.createdAt,
    required super.familyId,
  });

  factory RecipeModel.fromMap(String id, Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    if (createdAt == null) {
      throw FormatException("Campo requerido ausente en Firestore: 'createdAt'");
    }
    if (createdAt is! Timestamp) {
      throw FormatException(
        "Tipo inesperado para 'createdAt': se esperaba Timestamp, se recibió ${createdAt.runtimeType}",
      );
    }

    return RecipeModel(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
      createdAt: createdAt.toDate(),
      familyId: map['familyId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'familyId': familyId,
    };
  }

  factory RecipeModel.fromEntity(Recipe entity) {
    return RecipeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      familyId: entity.familyId,
    );
  }

  Recipe toEntity() {
    return Recipe(
      id: id,
      name: name,
      description: description,
      createdBy: createdBy,
      createdAt: createdAt,
      familyId: familyId,
    );
  }
}
