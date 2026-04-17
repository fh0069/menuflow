import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/weekly_plan_remote_datasource.dart';
import '../../data/repositories/weekly_plan_repository_impl.dart';
import '../../domain/repositories/weekly_plan_repository.dart';
import '../../domain/usecases/get_weekly_plan.dart';
import '../../domain/usecases/save_weekly_plan.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final weeklyPlanRemoteDataSourceProvider =
    Provider<WeeklyPlanRemoteDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);

  return WeeklyPlanRemoteDataSourceImpl(firestore);
});

final weeklyPlanRepositoryProvider = Provider<WeeklyPlanRepository>((ref) {
  final remoteDataSource = ref.watch(weeklyPlanRemoteDataSourceProvider);

  return WeeklyPlanRepositoryImpl(remoteDataSource);
});

final getWeeklyPlanProvider = Provider<GetWeeklyPlan>((ref) {
  final repository = ref.watch(weeklyPlanRepositoryProvider);

  return GetWeeklyPlan(repository);
});

final saveWeeklyPlanProvider = Provider<SaveWeeklyPlan>((ref) {
  final repository = ref.watch(weeklyPlanRepositoryProvider);

  return SaveWeeklyPlan(repository);
});