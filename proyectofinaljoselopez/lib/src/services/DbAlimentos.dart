import 'package:sqflite/sqflite.dart';
import '../models/alimentos.dart';
import 'conexion_db.dart'; // Importa la clase ConexionDB

class DbAlimentos {
  // Método para insertar un nuevo alimento en la base de datos
  static Future<int> insert(Alimento alimento) async {
    Database database = await ConexionDB.database;
    int result = await database.insert("Alimentos", alimento.toMap());
    return result;
  }

  // Método para eliminar un alimento de la base de datos por ID
  static Future<int> delete(int id) async {
    Database database = await ConexionDB.database;
    int result = await database.delete("Alimentos", where: "alimento_id = ?", whereArgs: [id]);
    return result;
  }

  // Método para actualizar un alimento en la base de datos
  static Future<int> update(Alimento alimento) async {
    Database database = await ConexionDB.database;
    int result = await database.update("Alimentos", alimento.toMap(), where: "alimento_id = ?", whereArgs: [alimento.id]);
    return result;
  }

  // Método para obtener todos los alimentos de la base de datos
  static Future<List<Alimento>> alimentos() async {
    Database database = await ConexionDB.database;
    final List<Map<String, dynamic>> alimentosMap = await database.query("Alimentos");
    return List.generate(alimentosMap.length, (i) {
      return Alimento.fromMap(alimentosMap[i]);
    });
  }

  // Método para insertar datos por defecto en la base de datos
  static Future<void> insertDefaultData() async {
    Database database = await ConexionDB.database;

    await database.rawInsert(
        "INSERT INTO Alimentos (nombre, categoria_id, fecha_compra, fecha_caducidad, cantidad, usuario_id) "
            "VALUES ('Manzanas', 1, '2024-05-15', '2024-05-22', 5, 1)"
    );
  }
}
