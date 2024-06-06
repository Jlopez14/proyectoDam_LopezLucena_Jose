import 'package:flutter/material.dart';
import '../models/usuarios.dart';
import '../services/DbUsuarios.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  // Controladores para los campos de texto del nombre, correo electrónico y contraseña
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Evita que el teclado cause desbordamiento visual
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen del logo
                Image.asset(
                  'lib/assets/desperdiciocerobla.png',
                  height: 300,
                ),
                SizedBox(height: 20), // Espacio vertical
                // Texto de introducción
                Text(
                  'Introduce tus credenciales para registrarte',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20), // Espacio vertical
                // Campo de texto para el nombre
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                SizedBox(height: 10), // Espacio vertical
                // Campo de texto para el correo electrónico
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                  ),
                ),
                SizedBox(height: 10), // Espacio vertical
                // Campo de texto para la contraseña
                TextField(
                  controller: _contrasenaController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  obscureText: true, // Oculta el texto para la contraseña
                ),
                SizedBox(height: 20), // Espacio vertical
                // Botones para cancelar y registrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Navega hacia atrás
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 18),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String nombre = _nombreController.text;
                        String email = _emailController.text;
                        String contrasena = _contrasenaController.text;

                        // Validar correo electrónico
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Por favor, introduce un correo electrónico válido.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        // Validar contraseña
                        if (contrasena.length < 6) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Error'),
                              content: Text('La contraseña debe tener al menos 6 caracteres.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        // Crear un nuevo usuario
                        Usuario nuevoUsuario = Usuario(
                          nombre: nombre,
                          correoElectronico: email,
                          contrasena: contrasena,
                        );

                        // Insertar el usuario en la base de datos
                        int resultado = await DBUsuarios.insert(nuevoUsuario);

                        // Mostrar un diálogo según el resultado de la inserción
                        if (resultado != 0) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Registro exitoso'),
                              content: Text('El usuario se registró correctamente.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Navega a la pantalla de inicio de sesión
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Ocurrió un error al registrar el usuario.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 18),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Registrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
