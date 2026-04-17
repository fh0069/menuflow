import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/recipe.dart';
import '../providers/recipe_providers.dart';
import 'create_recipe_page.dart';

const _kBrandColor = Color(0xFF00C896);

class RecipesPage extends ConsumerWidget {
  final String familyId;
  final bool selectionMode;
  final void Function(Recipe)? onRecipeSelected;

  const RecipesPage({
    super.key,
    required this.familyId,
    this.selectionMode = false,
    this.onRecipeSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider(familyId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF555555)),
        title: Text(
          selectionMode ? 'Seleccionar receta' : 'Recetas',
          style: const TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      floatingActionButton: selectionMode
          ? null
          : FloatingActionButton(
              backgroundColor: _kBrandColor,
              tooltip: 'Añadir receta',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateRecipePage(familyId: familyId),
                  ),
                );
                ref.invalidate(recipesProvider(familyId));
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),

      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error al cargar las recetas:\n$e',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF888888)),
            ),
          ),
        ),

        data: (recipes) {
          if (recipes.isEmpty) {
            return const _EmptyRecipesState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _RecipeCard(
                recipe: recipe,
                onTap: selectionMode
                    ? () {
                        onRecipeSelected?.call(recipe);
                        Navigator.of(context).pop();
                      }
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const _RecipeCard({required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: _kBrandColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      if (recipe.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          recipe.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF999999),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFCCCCCC),
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Estado vacío: no hay recetas todavía.
class _EmptyRecipesState extends StatelessWidget {
  const _EmptyRecipesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              'No tienes recetas todavía',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pulsa + para añadir una',
              style: TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
            ),
          ],
        ),
      ),
    );
  }
}
