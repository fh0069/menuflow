import '../entities/weekly_plan.dart';
import '../repositories/weekly_plan_repository.dart';

/// Caso de uso encargado de guardar una planificación semanal.
class SaveWeeklyPlan {
  final WeeklyPlanRepository repository;

  const SaveWeeklyPlan(this.repository);

  Future<void> call(WeeklyPlan plan) {
    return repository.saveWeeklyPlan(plan);
  }
}