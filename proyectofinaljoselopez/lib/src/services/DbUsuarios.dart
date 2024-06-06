import 'package:sqflite/sqflite.dart';
import '../models/usuarios.dart';
import 'conexion_db.dart'; // Importa la clase ConexionDB

class DBUsuarios {
  // Método para insertar un nuevo usuario en la base de datos
  static Future<int> insert(Usuario usuario) async {
    // Usa la clase ConexionDB para obtener la base de datos
    Database database = await ConexionDB.database;
    // Inserta el nuevo usuario en la tabla "Usuarios" y devuelve el id del registro insertado
    int result = await database.insert("Usuarios", usuario.toMap());
    return result;
  }

  // Método para eliminar un usuario de la base de datos
  static Future<int> delete(Usuario usuario) async {
    // Usa la clase ConexionDB para obtener la base de datos
    Database database = await ConexionDB.database;
    // Elimina el usuario de la tabla "Usuarios" basado en usuario_id
    int result = await database.delete("Usuarios", where: "usuario_id = ?", whereArgs: [usuario.id]);
    return result;
  }

  // Método para actualizar un usuario en la base de datos
  static Future<int> update(Usuario usuario) async {
    // Usa la clase ConexionDB para obtener la base de datos
    Database database = await ConexionDB.database;
    // Actualiza el usuario en la tabla "Usuarios" basado en usuario_id
    int result = await database.update("Usuarios", usuario.toMap(), where: "usuario_id = ?", whereArgs: [usuario.id]);
    return result;
  }

  // Método para obtener todos los usuarios de la base de datos
  static Future<List<Usuario>> usuarios() async {
    // Usa la clase ConexionDB para obtener la base de datos
    Database database = await ConexionDB.database;
    // Consulta la tabla "Usuarios" para obtener todos los usuarios
    final List<Map<String, dynamic>> usuariosMap = await database.query("Usuarios");
    // Convierte el resultado de la consulta en una lista de objetos Usuario y la devuelve
    return List.generate(usuariosMap.length,
            (i) => Usuario(
          id: usuariosMap[i]['usuario_id'],
          nombre: usuariosMap[i]['nombre'],
          correoElectronico: usuariosMap[i]['correo_electronico'],
          contrasena: usuariosMap[i]['contrasena'],
        )
    );
  }

  // Método para buscar un usuario por correo electrónico y contraseña
  static Future<Usuario?> buscarUsuario(String correoElectronico, String contrasena) async {
    // Usa la clase ConexionDB para obtener la base de datos
    Database database = await ConexionDB.database;
    // Consulta la tabla "Usuarios" para buscar un usuario con el correo electrónico y contraseña proporcionados
    List<Map<String, dynamic>> usuariosMap = await database.query(
      "Usuarios",
      where: "correo_electronico = ? AND contrasena = ?",
      whereArgs: [correoElectronico, contrasena],
    );
    if (usuariosMap.isEmpty) {
      // No se encontró ningún usuario con las credenciales proporcionadas
      return null;
    } else {
      // Devuelve el primer usuario encontrado
      return Usuario(
        id: usuariosMap[0]['usuario_id'],
        nombre: usuariosMap[0]['nombre'],
        correoElectronico: usuariosMap[0]['correo_electronico'],
        contrasena: usuariosMap[0]['contrasena'],
      );
    }
  }
}
