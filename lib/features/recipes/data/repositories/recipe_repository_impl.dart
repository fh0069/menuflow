import 'dart:io';

import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_datasource.dart';
import '../models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource _dataSource;

  RecipeRepositoryImpl(this._dataSource);

  @override
  Future<List<Recipe>> getRecipes(String familyId) async {
    final models = await _dataSource.getRecipes(familyId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createRecipe(Recipe recipe, {File? imageFile}) {
    return _dataSource.createRecipe(
      RecipeModel.fromEntity(recipe),
      imageFile: imageFile,
    );
  }

  @override
  Future<void> updateRecipe(Recipe recipe) {
    return _dataSource.updateRecipe(RecipeModel.fromEntity(recipe));
  }

  @override
  Future<void> deleteRecipe(String recipeId) {
    return _dataSource.deleteRecipe(recipeId);
  }
}
