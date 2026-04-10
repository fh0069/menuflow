import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/planned_meal.dart';
import '../../domain/entities/weekly_plan.dart';
import 'planned_meal_model.dart';

/// Modelo de datos de [WeeklyPlan] para Firestore.
///
/// Actúa como puente entre la capa de dominio (WeeklyPlan)
/// y la persistencia en Firestore.
///

class WeeklyPlanModel extends WeeklyPlan {
  const WeeklyPlanModel({
    required super.id,
    required super.familyId,
    required super.weekStartDate,
    required super.creationDate,
    required super.meals,
  });

  /// Crea un [WeeklyPlanModel] a partir de un Map proveniente de Firestore.

  factory WeeklyPlanModel.fromMap(Map<String, dynamic> map) {
    return WeeklyPlanModel(
      // Identificador del plan semanal
      id: map['id'] as String? ?? '',

      // Identificador de la familia a la que pertenece el plan
      familyId: map['familyId'] as String? ?? '',

      // Conversión de Timestamp (Firestore) a DateTime (dominio)
      weekStartDate: _requiredDate(map, 'weekStartDate'),

      // Fecha de creación del plan
      creationDate: _requiredDate(map, 'creationDate'),

      // Conversión del mapa de comidas planificadas
      meals: _mealsFromMap(
        (map['meals'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  /// Convierte el modelo a un Map compatible con Firestore.

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'familyId': familyId,

      // Conversión a formato Firestore
      'weekStartDate': Timestamp.fromDate(weekStartDate),
      'creationDate': Timestamp.fromDate(creationDate),

      // Serialización del mapa de comidas
      'meals': _mealsToMap(meals),
    };
  }

  /// Crea un modelo a partir de una entidad de dominio.

  factory WeeklyPlanModel.fromEntity(WeeklyPlan entity) {
    return WeeklyPlanModel(
      id: entity.id,
      familyId: entity.familyId,
      weekStartDate: entity.weekStartDate,
      creationDate: entity.creationDate,
      meals: entity.meals,
    );
  }

  /// Convierte el modelo de datos de vuelta a la entidad de dominio.

  WeeklyPlan toEntity() {
    return WeeklyPlan(
      id: id,
      familyId: familyId,
      weekStartDate: weekStartDate,
      creationDate: creationDate,
      meals: meals,
    );
  }


  // C2: lanza excepción si el campo de fecha es null o tiene un tipo inesperado.
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