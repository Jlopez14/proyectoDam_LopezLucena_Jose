import 'package:sqflite/sqflite.dart';
import '../models/consejos.dart';
import 'conexion_db.dart'; // Importa la clase ConexionDB

class DbConsejos {
  // Método para obtener todos los consejos de la base de datos
  static Future<List<Consejo>> getConsejos() async {
    Database database = await ConexionDB.database;
    final List<Map<String, dynamic>> consejosMap = await database.query("Consejos");
    return List.generate(consejosMap.length, (i) {
      return Consejo.fromMap(consejosMap[i]);
    });
  }

  // Método para obtener los consejos por categoría
  static Future<List<Consejo>> getConsejosByCategory(int categoriaId) async {
    Database database = await ConexionDB.database;
    final List<Map<String, dynamic>> consejosMap = await database.query(
      "Consejos",
      where: "categoria_id = ?",
      whereArgs: [categoriaId],
    );
    return List.generate(consejosMap.length, (i) {
      return Consejo.fromMap(consejosMap[i]);
    });
  }
}
