import 'planned_meal.dart';

/// Planificación semanal de una familia.
// Se modela como unidad completa porque la app siempre la consume en bloque.
class WeeklyPlan {
  final String id;
  final String familyId;
  final DateTime weekStartDate;
  final DateTime creationDate;
  final Map<String, PlannedMeal> meals;

  const WeeklyPlan({
    required this.id,
    required this.familyId,
    required this.weekStartDate,
    required this.creationDate,
    required this.meals,
  });
}