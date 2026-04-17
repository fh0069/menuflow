import '../entities/weekly_plan.dart';
import '../repositories/weekly_plan_repository.dart';

class GetWeeklyPlan {
  final WeeklyPlanRepository repository;

  const GetWeeklyPlan(this.repository);

  Future<WeeklyPlan?> call(String familyId) {
    return repository.getWeeklyPlan(familyId);
  }
}