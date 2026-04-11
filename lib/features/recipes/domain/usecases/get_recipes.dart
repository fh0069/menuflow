import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRecipes {
  final RecipeRepository _repository;

  GetRecipes(this._repository);

  Future<List<Recipe>> call(String familyId) {
    return _repository.getRecipes(familyId);
  }
}
