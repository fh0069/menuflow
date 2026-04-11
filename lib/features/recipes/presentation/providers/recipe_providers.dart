import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../data/datasources/recipe_remote_datasource.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/usecases/create_recipe.dart';
import '../../domain/usecases/get_recipes.dart';

final recipeRemoteDataSourceProvider = Provider<RecipeRemoteDataSource>((ref) {
  return RecipeRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepositoryImpl(ref.watch(recipeRemoteDataSourceProvider));
});

final getRecipesProvider = Provider<GetRecipes>((ref) {
  return GetRecipes(ref.watch(recipeRepositoryProvider));
});

final createRecipeProvider = Provider<CreateRecipe>((ref) {
  return CreateRecipe(ref.watch(recipeRepositoryProvider));
});

/// Lista de recetas filtradas por familyId.
final recipesProvider =
    FutureProvider.family<List<Recipe>, String>((ref, familyId) async {
  return ref.watch(getRecipesProvider).call(familyId);
});
