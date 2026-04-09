import '../../domain/entities/weekly_plan.dart';
import '../../domain/repositories/weekly_plan_repository.dart';
import '../datasources/weekly_plan_remote_datasource.dart';
import '../models/weekly_plan_model.dart';

/// Implementación del repositorio de WeeklyPlan.
///
/// Se encarga de coordinar el acceso a datos utilizando el DataSource
/// y de convertir entre entidades de dominio y modelos.
class WeeklyPlanRepositoryImpl implements WeeklyPlanRepository {
  final WeeklyPlanRemoteDataSource remoteDataSource;

  WeeklyPlanRepositoryImpl(this.remoteDataSource);

  @override
  Future<WeeklyPlan?> getWeeklyPlan(String familyId) async {
    final model = await remoteDataSource.getWeeklyPlan(familyId);

    if (model == null) return null;

    return model; // ya es WeeklyPlan porque hereda
  }

  @override
  Future<void> saveWeeklyPlan(WeeklyPlan plan) async {
    final model = WeeklyPlanModel.fromEntity(plan);

    await remoteDataSource.saveWeeklyPlan(model);
  }
}