import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes(String familyId);
  Future<void> createRecipe(Recipe recipe);
}
