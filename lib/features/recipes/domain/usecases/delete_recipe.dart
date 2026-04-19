import '../repositories/recipe_repository.dart';

class DeleteRecipe {
  final RecipeRepository _repository;

  DeleteRecipe(this._repository);

  Future<void> call(String recipeId) {
    return _repository.deleteRecipe(recipeId);
  }
}
