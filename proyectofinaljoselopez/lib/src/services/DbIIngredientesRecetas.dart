import 'package:sqflite/sqflite.dart';
import '../models/ingredientes_recetas.dart';
import 'conexion_db.dart';

class DbIngredientesRecetas {
  // Método para insertar un nuevo ingrediente de receta en la base de datos
  static Future<int> insert(IngredienteReceta ingredienteReceta) async {
    // Obtiene la instancia de la base de datos
    Database database = await ConexionDB.database;
    // Inserta el nuevo ingrediente de receta en la tabla "Ingredientes_Recetas" y devuelve el id del registro insertado
    return await database.insert("Ingredientes_Recetas", ingredienteReceta.toMap());
  }

  // Método para obtener todos los ingredientes de una receta específica por su ID
  static Future<List<IngredienteReceta>> getIngredientesPorReceta(int recetaId) async {
    // Obtiene la instancia de la base de datos
    Database database = await ConexionDB.database;
    // Consulta la tabla "Ingredientes_Recetas" para obtener los ingredientes de la receta con el ID proporcionado
    final List<Map<String, dynamic>> ingredientesMap = await database.query(
      "Ingredientes_Recetas",
      where: "receta_id = ?",
      whereArgs: [recetaId],
    );
    // Convierte el resultado de la consulta en una lista de objetos IngredienteReceta y la devuelve
    return List.generate(ingredientesMap.length, (i) {
      return IngredienteReceta.fromMap(ingredientesMap[i]);
    });
  }

  // Método para actualizar un ingrediente de receta en la base de datos
  static Future<int> update(IngredienteReceta ingredienteReceta) async {
    // Obtiene la instancia de la base de datos
    Database database = await ConexionDB.database;
    // Actualiza el ingrediente de receta en la tabla "Ingredientes_Recetas" basado en receta_id y alimento_id
    return await database.update(
      "Ingredientes_Recetas",
      ingredienteReceta.toMap(),
      where: "receta_id = ? AND alimento_id = ?",
      whereArgs: [ingredienteReceta.recetaId, ingredienteReceta.alimentoId],
    );
  }

  // Método para eliminar un ingrediente de receta específico de la base de datos
  static Future<int> delete(int recetaId, int alimentoId) async {
    // Obtiene la instancia de la base de datos
    Database database = await ConexionDB.database;
    // Elimina el ingrediente de receta de la tabla "Ingredientes_Recetas" basado en receta_id y alimento_id
    return await database.delete(
      "Ingredientes_Recetas",
      where: "receta_id = ? AND alimento_id = ?",
      whereArgs: [recetaId, alimentoId],
    );
  }

  // Método para eliminar todos los ingredientes de una receta específica de la base de datos
  static Future<int> deleteAllIngredientesPorReceta(int recetaId) async {
    // Obtiene la instancia de la base de datos
    Database database = await ConexionDB.database;
    // Elimina todos los ingredientes de receta de la tabla "Ingredientes_Recetas" basado en receta_id
    return await database.delete(
      "Ingredientes_Recetas",
      where: "receta_id = ?",
      whereArgs: [recetaId],
    );
  }
}
