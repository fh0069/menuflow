import '../entities/weekly_plan.dart';
import '../repositories/weekly_plan_repository.dart';

/// Caso de uso encargado de obtener la planificación semanal
/// asociada a una familia.
class GetWeeklyPlan {
  final WeeklyPlanRepository repository;

  const GetWeeklyPlan(this.repository);

  Future<WeeklyPlan?> call(String familyId) {
    return repository.getWeeklyPlan(familyId);
  }
}