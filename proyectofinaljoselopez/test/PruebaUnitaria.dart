import 'package:flutter_test/flutter_test.dart';
import 'package:proyectofinaljoselopez/src/models/usuarios.dart';

void main() {
  group('Usuario', () {
    test('Creación de Usuario', () {
      final usuario = Usuario(
        id: 1,
        nombre: 'John Doe',
        correoElectronico: 'john.doe@example.com',
        contrasena: 'password123',
      );

      expect(usuario.id, 1);
      expect(usuario.nombre, 'John Doe');
      expect(usuario.correoElectronico, 'john.doe@example.com');
      expect(usuario.contrasena, 'password123');
    });

    test('Conversión a Map', () {
      final usuario = Usuario(
        id: 1,
        nombre: 'John Doe',
        correoElectronico: 'john.doe@example.com',
        contrasena: 'password123',
      );

      final usuarioMap = usuario.toMap();
      expect(usuarioMap['usuario_id'], 1);
      expect(usuarioMap['nombre'], 'John Doe');
      expect(usuarioMap['correo_electronico'], 'john.doe@example.com');
      expect(usuarioMap['contrasena'], 'password123');
    });

    test('Creación desde Map', () {
      final usuarioMap = {
        'usuario_id': 1,
        'nombre': 'John Doe',
        'correo_electronico': 'john.doe@example.com',
        'contrasena': 'password123',
      };

      final usuario = Usuario.fromMap(usuarioMap);
      expect(usuario.id, 1);
      expect(usuario.nombre, 'John Doe');
      expect(usuario.correoElectronico, 'john.doe@example.com');
      expect(usuario.contrasena, 'password123');
    });
  });
}
