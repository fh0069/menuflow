import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recipe_providers.dart';
import 'create_recipe_page.dart';

class RecipesPage extends ConsumerWidget {
  final String familyId;

  const RecipesPage({super.key, required this.familyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider(familyId));

    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Error al cargar las recetas:\n$e',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Text(
                'No hay recetas todavía.\nPulsa + para añadir una.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: Text(recipe.description),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CreateRecipePage(familyId: familyId),
            ),
          );
          // Invalida el provider para recargar la lista tras crear una receta.
          ref.invalidate(recipesProvider(familyId));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
