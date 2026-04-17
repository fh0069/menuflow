import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/planned_meal.dart';
import '../../domain/entities/weekly_plan.dart';
import 'planned_meal_model.dart';

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
      id: map['id'] as String? ?? '',
      familyId: map['familyId'] as String? ?? '',
      weekStartDate: _requiredDate(map, 'weekStartDate'),
      creationDate: _requiredDate(map, 'creationDate'),
      meals: _mealsFromMap(
        (map['meals'] as Map<String, dynamic>?) ?? {},
      ),
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

  WeeklyPlan toEntity() {
    return WeeklyPlan(
      id: id,
      familyId: familyId,
      weekStartDate: weekStartDate,
      creationDate: creationDate,
      meals: meals,
    );
  }


  // Lanza excepción si el campo de fecha es null o tiene un tipo inesperado.
  static DateTime _requiredDate(Map<String, dynamic> map, String field) {
    final value = map[field];
    if (value == null) {
      throw FormatException("Campo requerido ausente en Firestore: '$field'");
    }
    if (value is! Timestamp) {
      throw FormatException(
        "Tipo inesperado para '$field': se esperaba Timestamp, se recibió ${value.runtimeType}",
      );
    }
    return value.toDate();
  }

  static Map<String, PlannedMealModel> _mealsFromMap(
    Map<String, dynamic> map,
  ) {
    return map.map(
      (key, value) => MapEntry(
        key,
        PlannedMealModel.fromMap(value as Map<String, dynamic>),
      ),
    );
  }


  static Map<String, dynamic> _mealsToMap(
    Map<String, PlannedMeal> meals,
  ) {
    return meals.map(
      (key, value) => MapEntry(
        key,
        PlannedMealModel.fromEntity(value).toMap(),
      ),
    );
  }
}