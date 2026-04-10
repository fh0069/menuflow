import '../../domain/entities/planned_meal.dart';

class PlannedMealModel extends PlannedMeal {
  const PlannedMealModel({
    required super.recipeId,
    required super.recipeTitle,
    required super.mealType,
  });

  factory PlannedMealModel.fromMap(Map<String, dynamic> map) {
    return PlannedMealModel(
      recipeId: map['recipeId'] as String? ?? '',
      recipeTitle: map['recipeTitle'] as String? ?? '',
      mealType: map['mealType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeTitle': recipeTitle,
      'mealType': mealType,
    };
  }

  factory PlannedMealModel.fromEntity(PlannedMeal entity) {
    return PlannedMealModel(
      recipeId: entity.recipeId,
      recipeTitle: entity.recipeTitle,
      mealType: entity.mealType,
    );
  }

  PlannedMeal toEntity() {
    return PlannedMeal(
      recipeId: recipeId,
      recipeTitle: recipeTitle,
      mealType: mealType,
    );
  }
}