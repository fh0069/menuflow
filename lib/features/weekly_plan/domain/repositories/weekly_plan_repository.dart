import '../entities/weekly_plan.dart';

abstract class WeeklyPlanRepository {
  Future<WeeklyPlan?> getWeeklyPlan(String familyId);
  Future<void> saveWeeklyPlan(WeeklyPlan plan);
}