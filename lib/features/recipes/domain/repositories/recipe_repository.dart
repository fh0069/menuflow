import 'dart:io';

import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes(String familyId);
  Future<void> createRecipe(Recipe recipe, {File? imageFile});
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(String recipeId);
}
