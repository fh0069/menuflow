import '../entities/weekly_plan.dart';

/// Define las operaciones disponibles para la planificación semanal
/// desde el punto de vista del dominio.
abstract class WeeklyPlanRepository {
  Future<WeeklyPlan?> getWeeklyPlan(String familyId);
  Future<void> saveWeeklyPlan(WeeklyPlan plan);
}