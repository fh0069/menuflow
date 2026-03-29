/// Representa una receta dentro del sistema.
///
/// Las recetas pertenecen a una familia y pueden ser utilizadas
/// en la planificación semanal de comidas.
///
/// Esta entidad contiene la información necesaria para mostrar
/// y gestionar recetas dentro de la aplicación.
class Recipe {
  final String id;
  final String familyId;
  final String title;
  final String description;
  final int preparationTime;
  final String? imageUrl;

  const Recipe({
    required this.id,
    required this.familyId,
    required this.title,
    required this.description,
    required this.preparationTime,
    this.imageUrl,
  });
}