import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes(String familyId);
  Future<void> createRecipe(RecipeModel recipe);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final FirebaseFirestore _firestore;

  RecipeRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<RecipeModel>> getRecipes(String familyId) async {
    try {
      final snapshot = await _firestore
          .collection('recipes')
          .where('familyId', isEqualTo: familyId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint('RecipeRemoteDataSource.getRecipes error: $e');
      throw Exception('Error al obtener las recetas: $e');
    }
  }

  @override
  Future<void> createRecipe(RecipeModel recipe) async {
    try {
      await _firestore.collection('recipes').add(recipe.toMap());
    } catch (e) {
      debugPrint('RecipeRemoteDataSource.createRecipe error: $e');
      throw Exception('Error al crear la receta: $e');
    }
  }
}
