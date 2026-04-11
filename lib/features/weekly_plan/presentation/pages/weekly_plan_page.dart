import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/planned_meal.dart';
import '../../domain/entities/weekly_plan.dart';
import '../providers/weekly_plan_providers.dart';
import '../providers/weekly_plan_state_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../family/presentation/pages/join_family_page.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/presentation/pages/recipes_page.dart';

// Color de marca compartido con el resto de la app.
const _kBrandColor = Color(0xFF00C896);

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

  // ── Lógica existente — sin modificar ──────────────────────────────────────

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

  String _mapMealType(String type) {
    switch (type) {
      case 'lunch':
        return 'Comida';
      case 'dinner':
        return 'Cena';
      default:
        return type;
    }
  }

  void _openRecipeSelector(
    BuildContext context,
    WidgetRef ref,
    WeeklyPlan currentPlan,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipesPage(
          familyId: familyId,
          selectionMode: true,
          onRecipeSelected: (recipe) => _addMealFromRecipe(
            context,
            ref,
            currentPlan,
            recipe,
          ),
        ),
      ),
    );
  }

  Future<void> _addMealFromRecipe(
    BuildContext context,
    WidgetRef ref,
    WeeklyPlan currentPlan,
    Recipe recipe,
  ) async {
    final saveWeeklyPlan = ref.read(saveWeeklyPlanProvider);
    final key = '${recipe.id}_${DateTime.now().millisecondsSinceEpoch}';

    final updatedMeals = Map<String, PlannedMeal>.from(currentPlan.meals)
      ..[key] = PlannedMeal(
        recipeId: recipe.id,
        recipeTitle: recipe.name,
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

  // ── Helpers de presentación ───────────────────────────────────────────────

  /// Formatea la fecha de inicio de semana en lenguaje natural.
  String _formatWeekStart(DateTime date) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return 'Semana del ${date.day} de ${months[date.month - 1]}';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyPlanAsync = ref.watch(weeklyPlanProvider(familyId));
    final currentUser = ref.watch(authNotifierProvider).currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Plan semanal',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RecipesPage(familyId: familyId),
              ),
            ),
            icon: const Icon(Icons.menu_book, color: _kBrandColor),
            label: const Text(
              'Recetas',
              style: TextStyle(color: _kBrandColor),
            ),
          ),
          Tooltip(
            message: 'Cerrar sesión',
            child: IconButton(
              icon: const Icon(Icons.logout, color: _kBrandColor),
              onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
            ),
          ),
        ],
      ),

      // ── FAB: visible solo cuando existe un plan ───────────────────────────
      floatingActionButton: weeklyPlanAsync.whenOrNull(
        data: (plan) => plan == null
            ? null
            : FloatingActionButton(
                onPressed: () => _openRecipeSelector(context, ref, plan),
                backgroundColor: _kBrandColor,
                tooltip: 'Añadir comida',
                child: const Icon(Icons.add, color: Colors.white),
              ),
      ),

      // ── Cuerpo ────────────────────────────────────────────────────────────
      body: weeklyPlanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Se ha producido un error al cargar la planificación semanal:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF888888)),
            ),
          ),
        ),

        data: (plan) {
          // Estado sin plan: invita a crear la primera planificación.
          if (plan == null) {
            return _NoPlanState(onCreatePlan: () => _createPlan(context, ref));
          }

          // Plan existente: muestra cabecera, tarjeta de familia y comidas.
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
            children: [
              // ── Cabecera de semana ────────────────────────────────────────
              _SectionCard(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8F3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_today_outlined,
                        color: _kBrandColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatWeekStart(plan.weekStartDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Tarjeta de familia ────────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F8F3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.people_outline,
                            color: _kBrandColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tu familia',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              if (currentUser?.name != null)
                                Text(
                                  currentUser!.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Botón para unirse a otra familia
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const JoinFamilyPage(),
                            ),
                          ),
                          icon: const Icon(Icons.group_add, size: 16),
                          label: const Text('Unirse'),
                          style: TextButton.styleFrom(
                            foregroundColor: _kBrandColor,
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 12),

                    // Código de familia copiable.
                    // TODO: sustituir familyId por el joinCode real
                    //       cuando se implemente getFamilyById.
                    Row(
                      children: [
                        const Icon(
                          Icons.vpn_key_outlined,
                          size: 16,
                          color: Color(0xFFAAAAAA),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Código de invitación',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFAAAAAA),
                                ),
                              ),
                              Text(
                                familyId,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF555555),
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: familyId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Código copiado al portapapeles'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 14),
                          label: const Text('Copiar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF555555),
                            side: const BorderSide(color: Color(0xFFDDDDDD)),
                            textStyle: const TextStyle(fontSize: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Sección de comidas ─────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 10),
                child: Text(
                  'Comidas planificadas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),

              if (plan.meals.isEmpty)
                const _EmptyMealsState()
              else
                ...plan.meals.entries.map(
                  (entry) => _MealCard(
                    meal: entry.value,
                    mealTypeLabel: _mapMealType(entry.value.mealType),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ── Widgets de soporte ────────────────────────────────────────────────────────

/// Card base reutilizable con fondo blanco, bordes redondeados y sombra suave.
class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

/// Estado vacío cuando no hay comidas planificadas aún.
class _EmptyMealsState extends StatelessWidget {
  const _EmptyMealsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.dining_outlined,
            size: 56,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Aún no has planificado comidas',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pulsa el botón + para empezar',
            style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
          ),
        ],
      ),
    );
  }
}

/// Card individual para cada comida planificada.
class _MealCard extends StatelessWidget {
  final PlannedMeal meal;
  final String mealTypeLabel;

  const _MealCard({required this.meal, required this.mealTypeLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.restaurant,
            color: _kBrandColor,
            size: 22,
          ),
        ),
        title: Text(
          meal.recipeTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1A1A2E),
          ),
        ),
        subtitle: Text(
          'Asignada como: $mealTypeLabel',
          style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
      ),
    );
  }
}

/// Estado cuando todavía no existe ningún plan para esta familia.
class _NoPlanState extends StatelessWidget {
  final VoidCallback onCreatePlan;

  const _NoPlanState({required this.onCreatePlan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 24),
            const Text(
              'Sin planificación esta semana',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crea la planificación semanal\nde tu familia para empezar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onCreatePlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBrandColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Crear planificación'),
            ),
          ],
        ),
      ),
    );
  }
}
