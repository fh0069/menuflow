import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/weekly_plan.dart';
import 'weekly_plan_providers.dart';

final weeklyPlanProvider =
    FutureProvider.family<WeeklyPlan?, String>((ref, familyId) async {
  final getWeeklyPlan = ref.watch(getWeeklyPlanProvider);

  return await getWeeklyPlan(familyId);
});
