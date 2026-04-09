import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/weekly_plan.dart';
import 'planned_meal_model.dart';

/// Modelo de datos de [WeeklyPlan] para Firestore.
///
/// Contiene la planificación semanal completa y gestiona la
/// conversión del mapa de comidas planificadas.
class WeeklyPlanModel extends WeeklyPlan {
  const WeeklyPlanModel({
    required super.id,
    required super.familyId,
    required super.weekStartDate,
    required super.creationDate,
    required super.meals,
  });

  factory WeeklyPlanModel.fromMap(Map<String, dynamic> map) {
    return WeeklyPlanModel(
      id: map['id'] as String,
      familyId: map['familyId'] as String,
      weekStartDate: (map['weekStartDate'] as Timestamp).toDate(),
      creationDate: (map['creationDate'] as Timestamp).toDate(),
      meals: _mealsFromMap(map['meals'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'familyId': familyId,
      'weekStartDate': Timestamp.fromDate(weekStartDate),
      'creationDate': Timestamp.fromDate(creationDate),
      'meals': _mealsToMap(meals),
    };
  }

  factory WeeklyPlanModel.fromEntity(WeeklyPlan entity) {
    return WeeklyPlanModel(
      id: entity.id,
      familyId: entity.familyId,
      weekStartDate: entity.weekStartDate,
      creationDate: entity.creationDate,
      meals: entity.meals,
    );
  }

  /// Convierte el mapa de Firestore a Map<String, PlannedMeal>
  static Map<String, PlannedMealModel> _mealsFromMap(
      Map<String, dynamic> map) {
    return map.map(
      (key, value) => MapEntry(
        key,
        PlannedMealModel.fromMap(value as Map<String, dynamic>),
      ),
    );
  }

  /// Convierte el Map<String, PlannedMeal> a formato Firestore
  static Map<String, dynamic> _mealsToMap(
      Map<String, PlannedMeal> meals) {
    return meals.map(
      (key, value) => MapEntry(
        key,
        PlannedMealModel.fromEntity(value).toMap(),
      ),
    );
  }
}