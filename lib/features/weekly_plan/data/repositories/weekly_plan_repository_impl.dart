import '../../domain/entities/weekly_plan.dart';
import '../../domain/repositories/weekly_plan_repository.dart';
import '../datasources/weekly_plan_remote_datasource.dart';
import '../models/weekly_plan_model.dart';


class WeeklyPlanRepositoryImpl implements WeeklyPlanRepository {
  final WeeklyPlanRemoteDataSource remoteDataSource;

  WeeklyPlanRepositoryImpl(this.remoteDataSource);

  @override
  Future<WeeklyPlan?> getWeeklyPlan(String familyId) async {
    final model = await remoteDataSource.getWeeklyPlan(familyId);

    if (model == null) return null;

    // Convertimos explícitamente el modelo de datos
    // a entidad de dominio para mantener la separación de capas.
    return model.toEntity();
  }

  @override
  Future<void> saveWeeklyPlan(WeeklyPlan plan) async {
    // Convertimos la entidad de dominio a modelo
    // antes de persistir en Firestore.
    final model = WeeklyPlanModel.fromEntity(plan);

    await remoteDataSource.saveWeeklyPlan(model);
  }
}