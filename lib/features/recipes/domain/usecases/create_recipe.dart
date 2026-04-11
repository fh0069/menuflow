import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class CreateRecipe {
  final RecipeRepository _repository;

  CreateRecipe(this._repository);

  Future<void> call(Recipe recipe) {
    return _repository.createRecipe(recipe);
  }
}
