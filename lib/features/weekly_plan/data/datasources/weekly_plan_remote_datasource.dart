import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/weekly_plan_model.dart';

/// Define las operaciones de acceso a datos para WeeklyPlan.
abstract class WeeklyPlanRemoteDataSource {
  Future<WeeklyPlanModel?> getWeeklyPlan(String familyId);
  Future<void> saveWeeklyPlan(WeeklyPlanModel plan);
}

/// Implementación que utiliza Firebase Firestore.
class WeeklyPlanRemoteDataSourceImpl
    implements WeeklyPlanRemoteDataSource {
  final FirebaseFirestore firestore;

  WeeklyPlanRemoteDataSourceImpl(this.firestore);

  @override
  Future<WeeklyPlanModel?> getWeeklyPlan(String familyId) async {
    final query = await firestore
        .collection('weekly_plans')
        .where('familyId', isEqualTo: familyId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;

    return WeeklyPlanModel.fromMap(doc.data());
  }

  @override
  Future<void> saveWeeklyPlan(WeeklyPlanModel plan) async {
    await firestore
        .collection('weekly_plans')
        .doc(plan.id)
        .set(plan.toMap());
  }
}