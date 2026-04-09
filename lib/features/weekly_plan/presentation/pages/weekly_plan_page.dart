import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/weekly_plan_state_provider.dart';

/// Pantalla base de prueba para la funcionalidad de planificación semanal.
///
/// Esta página permite verificar que la cadena completa de arquitectura
/// (provider, use case, repository, datasource y Firestore) funciona
/// correctamente de extremo a extremo.
class WeeklyPlanPage extends ConsumerWidget {
  final String familyId;

  const WeeklyPlanPage({
    super.key,
    required this.familyId,
  });

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
            return const Center(
              child: Text(
                'No existe ninguna planificación semanal para esta familia.',
                textAlign: TextAlign.center,
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