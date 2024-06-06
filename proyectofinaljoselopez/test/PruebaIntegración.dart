import 'package:flutter_test/flutter_test.dart';
import 'package:proyectofinaljoselopez/src/models/usuarios.dart';
import 'package:proyectofinaljoselopez/src/services/DbUsuarios.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  // Inicializa el factory de sqflite_common_ffi
  sqfliteFfiInit();

  // Configura el factory global para utilizar sqflite_common_ffi en las pruebas
  databaseFactory = databaseFactoryFfi;

  group('DbUsuarios', () {
    late Database db;

    setUp(() async {
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE Usuarios(
              usuario_id INTEGER PRIMARY KEY,
              nombre TEXT,
              correo_electronico TEXT UNIQUE,
              contrasena TEXT
            )
          ''');
        },
      );
    });

    tearDown(() async {
      await db.execute('DROP TABLE IF EXISTS Usuarios');  // Eliminar la tabla Usuarios entre pruebas
      await db.execute('''
        CREATE TABLE Usuarios(
          usuario_id INTEGER PRIMARY KEY,
          nombre TEXT,
          correo_electronico TEXT UNIQUE,
          contrasena TEXT
        )
      ''');  // Volver a crear la tabla Usuarios
      await db.close();
    });

    test('Inserción de Usuario con ID manual', () async {
      final usuario = Usuario(
        id: 10,
        nombre: 'John Doe',
        correoElectronico: 'john.doe10@example.com',
        contrasena: 'password123',
      );

      final result = await DBUsuarios.insert(usuario);
      expect(result, greaterThan(0)); // Verifica que se haya insertado correctamente
    });

    test('Búsqueda de Usuario con ID manual', () async {
      final usuario = Usuario(
        id: 11,
        nombre: 'Jane Doe',
        correoElectronico: 'jane.doe11@example.com',
        contrasena: 'password456',
      );

      // Inserta el usuario
      final insertResult = await DBUsuarios.insert(usuario);
      expect(insertResult, greaterThan(0)); // Verifica que la inserción fue exitosa

      // Busca el usuario
      final foundUser = await DBUsuarios.buscarUsuario('jane.doe11@example.com', 'password456');
      expect(foundUser, isNotNull); // Verifica que se haya encontrado el usuario
      expect(foundUser!.nombre, 'Jane Doe');
    });
  });
}
