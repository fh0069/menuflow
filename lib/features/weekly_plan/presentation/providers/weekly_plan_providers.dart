import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/weekly_plan_remote_datasource.dart';
import '../../data/repositories/weekly_plan_repository_impl.dart';
import '../../domain/repositories/weekly_plan_repository.dart';
import '../../domain/usecases/get_weekly_plan.dart';
import '../../domain/usecases/save_weekly_plan.dart';

/// Provider global de acceso a Firestore.
///
/// Expone una única instancia de [FirebaseFirestore] para que pueda
/// ser reutilizada por los distintos componentes de la aplicación.
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Provider del datasource remoto de planificación semanal.
///
/// Se encarga de crear la implementación concreta que accede
/// a Firestore para obtener y guardar planificaciones semanales.
final weeklyPlanRemoteDataSourceProvider =
    Provider<WeeklyPlanRemoteDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);

  return WeeklyPlanRemoteDataSourceImpl(firestore);
});

/// Provider del repositorio de planificación semanal.
///
/// Expone la abstracción utilizada por la capa de dominio,
/// desacoplando la aplicación de la implementación concreta.
final weeklyPlanRepositoryProvider = Provider<WeeklyPlanRepository>((ref) {
  final remoteDataSource = ref.watch(weeklyPlanRemoteDataSourceProvider);

  return WeeklyPlanRepositoryImpl(remoteDataSource);
});

/// Provider del caso de uso para obtener una planificación semanal.
final getWeeklyPlanProvider = Provider<GetWeeklyPlan>((ref) {
  final repository = ref.watch(weeklyPlanRepositoryProvider);

  return GetWeeklyPlan(repository);
});

/// Provider del caso de uso para guardar una planificación semanal.
final saveWeeklyPlanProvider = Provider<SaveWeeklyPlan>((ref) {
  final repository = ref.watch(weeklyPlanRepositoryProvider);

  return SaveWeeklyPlan(repository);
});