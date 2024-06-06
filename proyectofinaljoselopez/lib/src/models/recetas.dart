import 'ingredientes_recetas.dart';

class Receta {
  int? id;
  String nombre;
  String instrucciones;
  int tiempoPreparacion;
  int usuarioId;
  List<IngredienteReceta> ingredientes;

  Receta({
    this.id,
    required this.nombre,
    required this.instrucciones,
    required this.tiempoPreparacion,
    required this.usuarioId,
    this.ingredientes = const [],
  });

  // Convierte un objeto Receta en un Map
  Map<String, dynamic> toMap() {
    return {
      'receta_id': id,
      'nombre': nombre,
      'instrucciones': instrucciones,
      'tiempo_preparacion': tiempoPreparacion,
      'usuario_id': usuarioId,
    };
  }

  // Crea un objeto Receta a partir de un Map
  factory Receta.fromMap(Map<String, dynamic> map, List<IngredienteReceta> ingredientes) {
    return Receta(
      id: map['receta_id'],
      nombre: map['nombre'],
      instrucciones: map['instrucciones'],
      tiempoPreparacion: map['tiempo_preparacion'],
      usuarioId: map['usuario_id'],
      ingredientes: ingredientes,
    );
  }
}
