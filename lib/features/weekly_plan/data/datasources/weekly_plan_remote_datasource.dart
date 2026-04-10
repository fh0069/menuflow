import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/weekly_plan_model.dart';

/// Define las operaciones de acceso a datos para WeeklyPlan.
abstract class WeeklyPlanRemoteDataSource {
  Future<WeeklyPlanModel?> getWeeklyPlan(String familyId);
  Future<void> saveWeeklyPlan(WeeklyPlanModel plan);
}

/// Implementación que utiliza Firebase Firestore.
/// - Un documento por familia -> familyId es el ID del documento

class WeeklyPlanRemoteDataSourceImpl
    implements WeeklyPlanRemoteDataSource {
  final FirebaseFirestore firestore;

  WeeklyPlanRemoteDataSourceImpl(this.firestore);

  @override
  Future<WeeklyPlanModel?> getWeeklyPlan(String familyId) async {
    
    final doc = await firestore
        .collection('weekly_plans')
        .doc(familyId)
        .get();

    if (!doc.exists) return null;

    final data = doc.data()!;

    
    data['id'] = doc.id;

    return WeeklyPlanModel.fromMap(data);
  }

  @override
  Future<void> saveWeeklyPlan(WeeklyPlanModel plan) async {
    // Guardamos el plan usando el familyId como ID del documento
    await firestore
        .collection('weekly_plans')
        .doc(plan.familyId)
        .set(plan.toMap());
  }
}