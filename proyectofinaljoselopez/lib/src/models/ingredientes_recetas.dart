class IngredienteReceta {
  int recetaId;
  int alimentoId;
  int cantidad;

  IngredienteReceta({
    required this.recetaId,
    required this.alimentoId,
    required this.cantidad,
  });

  // Convierte un objeto IngredienteReceta en un Map
  Map<String, dynamic> toMap() {
    return {
      'receta_id': recetaId,
      'alimento_id': alimentoId,
      'cantidad': cantidad,
    };
  }

  // Crea un objeto IngredienteReceta a partir de un Map
  factory IngredienteReceta.fromMap(Map<String, dynamic> map) {
    return IngredienteReceta(
      recetaId: map['receta_id'],
      alimentoId: map['alimento_id'],
      cantidad: map['cantidad'],
    );
  }
}
