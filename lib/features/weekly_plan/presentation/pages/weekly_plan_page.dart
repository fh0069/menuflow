import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/planned_meal.dart';
import '../../domain/entities/weekly_plan.dart';
import '../providers/weekly_plan_providers.dart';
import '../providers/weekly_plan_state_provider.dart';

/// Pantalla principal de la planificación semanal.
///
/// Muestra la planificación existente de la familia o, si no existe,
/// permite crearla desde cero.
class WeeklyPlanPage extends ConsumerWidget {
  final String familyId;

  const WeeklyPlanPage({
    super.key,
    required this.familyId,
  });

  Future<void> _createPlan(BuildContext context, WidgetRef ref) async {
    final saveWeeklyPlan = ref.read(saveWeeklyPlanProvider);
    final now = DateTime.now();

    // Calcula el lunes de la semana actual
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final emptyPlan = WeeklyPlan(
      id: familyId,
      familyId: familyId,
      weekStartDate: weekStart,
      creationDate: now,
      meals: const {},
    );

    try {
      await saveWeeklyPlan(emptyPlan);

      // Fuerza la recarga del provider para obtener los datos actualizados
      ref.invalidate(weeklyPlanProvider(familyId));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la planificación: $e')),
        );
      }
    }
  }

  Future<void> _addTestMeal(
    BuildContext context,
    WidgetRef ref,
    WeeklyPlan currentPlan,
  ) async {
    final saveWeeklyPlan = ref.read(saveWeeklyPlanProvider);
    final key = 'test_meal_${DateTime.now().millisecondsSinceEpoch}';

    final updatedMeals = Map<String, PlannedMeal>.from(currentPlan.meals)
      ..[key] = const PlannedMeal(
        recipeId: 'test_recipe',
        recipeTitle: 'Comida de prueba',
        mealType: 'lunch',
      );

    try {
      await saveWeeklyPlan(
        WeeklyPlan(
          id: currentPlan.id,
          familyId: currentPlan.familyId,
          weekStartDate: currentPlan.weekStartDate,
          creationDate: currentPlan.creationDate,
          meals: updatedMeals,
        ),
      );

      ref.invalidate(weeklyPlanProvider(familyId));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir la comida: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyPlanAsync = ref.watch(weeklyPlanProvider(familyId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan semanal'),
      ),
      body: weeklyPlanAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Se ha producido un error al cargar la planificación semanal:\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (plan) {
          if (plan == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No existe ninguna planificación semanal para esta familia.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _createPlan(context, ref),
                    child: const Text('Crear planificación'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID del plan: ${plan.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('ID de familia: ${plan.familyId}'),
                const SizedBox(height: 8),
                Text('Inicio de semana: ${plan.weekStartDate}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _addTestMeal(context, ref, plan),
                  child: const Text('Añadir comida de prueba'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Comidas planificadas:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: plan.meals.entries.map((entry) {
                      final mealKey = entry.key;
                      final meal = entry.value;

                      return Card(
                        child: ListTile(
                          title: Text(meal.recipeTitle),
                          subtitle: Text(
                            'Clave: $mealKey\n'
                            'Recipe ID: ${meal.recipeId}\n'
                            'Tipo: ${meal.mealType}',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}