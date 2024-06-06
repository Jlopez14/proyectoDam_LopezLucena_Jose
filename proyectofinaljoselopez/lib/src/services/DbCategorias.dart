import 'package:sqflite/sqflite.dart';
import '../models/categorias.dart';
import 'conexion_db.dart'; // Importa la clase ConexionDB

class DbCategorias {
  // Método para obtener todas las categorías de la base de datos
  static Future<List<Categoria>> getCategorias() async {
    Database database = await ConexionDB.database;
    final List<Map<String, dynamic>> categoriasMap = await database.query("Categorias");
    return List.generate(categoriasMap.length, (i) {
      return Categoria.fromMap(categoriasMap[i]);
    });
  }
}
