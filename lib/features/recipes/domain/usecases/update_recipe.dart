import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class UpdateRecipe {
  final RecipeRepository _repository;

  UpdateRecipe(this._repository);

  Future<void> call(Recipe recipe) {
    return _repository.updateRecipe(recipe);
  }
}
