import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes(String familyId);
  Future<void> createRecipe(RecipeModel recipe, {File? imageFile});
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  RecipeRemoteDataSourceImpl(this._firestore, this._storage);

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
  Future<void> createRecipe(RecipeModel recipe, {File? imageFile}) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        final fileName =
            '${recipe.familyId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = _storage.ref('recipes/${recipe.familyId}/$fileName');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      final recipeWithImage = RecipeModel(
        id: recipe.id,
        name: recipe.name,
        description: recipe.description,
        createdBy: recipe.createdBy,
        createdAt: recipe.createdAt,
        familyId: recipe.familyId,
        imageUrl: imageUrl,
      );

      await _firestore.collection('recipes').add(recipeWithImage.toMap());
    } catch (e) {
      debugPrint('RecipeRemoteDataSource.createRecipe error: $e');
      throw Exception('Error al crear la receta: $e');
    }
  }
}
