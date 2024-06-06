import 'package:sqflite/sqflite.dart';
import '../models/ingredientes_recetas.dart';
import '../models/recetas.dart';
import 'DbIIngredientesRecetas.dart';
import 'conexion_db.dart';

class DbRecetas {
  // Método para insertar una receta en la base de datos
  static Future<int> insert(Receta receta) async {
    Database database = await ConexionDB.database;
    return await database.insert("Recetas", receta.toMap());
  }

  // Método para obtener todas las recetas de la base de datos
  static Future<List<Receta>> getRecetas() async {
    Database database = await ConexionDB.database;
    final List<Map<String, dynamic>> recetasMap = await database.query("Recetas");

    List<Receta> recetas = [];
    for (var recetaMap in recetasMap) {
      int recetaId = recetaMap['receta_id'];
      List<IngredienteReceta> ingredientes = await DbIngredientesRecetas.getIngredientesPorReceta(recetaId);
      Receta receta = Receta.fromMap(recetaMap, ingredientes);
      recetas.add(receta);
    }
    return recetas;
  }

  // Método para actualizar una receta en la base de datos
  static Future<int> update(Receta receta) async {
    Database database = await ConexionDB.database;
    return await database.update("Recetas", receta.toMap(), where: "receta_id = ?", whereArgs: [receta.id]);
  }

  // Método para eliminar una receta de la base de datos
  static Future<int> delete(int id) async {
    Database database = await ConexionDB.database;
    return await database.delete("Recetas", where: "receta_id = ?", whereArgs: [id]);
  }
}
