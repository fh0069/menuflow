import 'planned_meal.dart';

/// Representa la planificación semanal de una familia.
///
/// Contiene la organización de comidas y cenas para cada día
/// de la semana, estructurada en un mapa de comidas planificadas.
///
/// Esta entidad se modela como una unidad completa, ya que
/// la aplicación consume la planificación semanal en bloque.
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