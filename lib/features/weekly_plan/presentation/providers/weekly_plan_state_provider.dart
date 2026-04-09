import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/planned_meal.dart';
import '../../domain/entities/weekly_plan.dart';

// TODO: Mock temporal — eliminar cuando Firebase esté integrado.
// Sustituir por la implementación real que use getWeeklyPlanProvider.
final weeklyPlanProvider =
    FutureProvider.family<WeeklyPlan?, String>((ref, familyId) async {
  // Simula latencia de red
  await Future.delayed(const Duration(milliseconds: 600));

  return WeeklyPlan(
    id: 'mock-plan-001',
    familyId: familyId,
    weekStartDate: DateTime(2026, 4, 6), // lunes de la semana actual
    creationDate: DateTime(2026, 4, 5),
    meals: {
      'monday_lunch': const PlannedMeal(
        recipeId: 'r001',
        recipeTitle: 'Lentejas con chorizo',
        mealType: 'lunch',
      ),
      'monday_dinner': const PlannedMeal(
        recipeId: 'r002',
        recipeTitle: 'Tortilla de patatas',
        mealType: 'dinner',
      ),
      'tuesday_lunch': const PlannedMeal(
        recipeId: 'r003',
        recipeTitle: 'Paella de verduras',
        mealType: 'lunch',
      ),
      'tuesday_dinner': const PlannedMeal(
        recipeId: 'r004',
        recipeTitle: 'Ensalada César con pollo',
        mealType: 'dinner',
      ),
      'wednesday_lunch': const PlannedMeal(
        recipeId: 'r005',
        recipeTitle: 'Macarrones con tomate',
        mealType: 'lunch',
      ),
      'wednesday_dinner': const PlannedMeal(
        recipeId: 'r006',
        recipeTitle: 'Merluza al horno',
        mealType: 'dinner',
      ),
      'thursday_lunch': const PlannedMeal(
        recipeId: 'r007',
        recipeTitle: 'Cocido madrileño',
        mealType: 'lunch',
      ),
      'thursday_dinner': const PlannedMeal(
        recipeId: 'r008',
        recipeTitle: 'Crema de calabaza',
        mealType: 'dinner',
      ),
      'friday_lunch': const PlannedMeal(
        recipeId: 'r009',
        recipeTitle: 'Arroz con leche',
        mealType: 'lunch',
      ),
      'friday_dinner': const PlannedMeal(
        recipeId: 'r010',
        recipeTitle: 'Pizza casera de jamón y queso',
        mealType: 'dinner',
      ),
    },
  );
});
