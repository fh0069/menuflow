/// Representa una comida planificada dentro de un WeeklyPlan.
///
/// No es una entidad independiente, sino parte de la planificación semanal.
/// Contiene la receta asignada a una comida concreta (comida o cena).
class PlannedMeal {
  final String recipeId;
  final String recipeTitle;
  final String mealType;

  const PlannedMeal({
    required this.recipeId,
    required this.recipeTitle,
    required this.mealType,
  });
}