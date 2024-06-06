import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import '../models/usuarios.dart';
import '../services/DbUsuarios.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos de texto del correo electrónico y la contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  String _errorMessage = ''; // Mensaje de error para mostrar si las credenciales son incorrectas

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
                  'Introduce tus credenciales para iniciar la App',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 30), // Espacio vertical
                // Campo de texto para el correo electrónico
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                  ),
                ),
                SizedBox(height: 30), // Espacio vertical
                // Campo de texto para la contraseña
                TextField(
                  controller: _contrasenaController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  obscureText: true, // Oculta el texto para la contraseña
                ),
                SizedBox(height: 30), // Espacio vertical
                // Muestra el mensaje de error si las credenciales son incorrectas
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                SizedBox(height: 30), // Espacio vertical
                // Botones para aceptar y registrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String correo = _emailController.text;
                        String contrasena = _contrasenaController.text;

                        // Busca al usuario en la base de datos con las credenciales proporcionadas
                        Usuario? usuario = await DBUsuarios.buscarUsuario(correo, contrasena);
                        if (usuario != null) {
                          // Si el usuario existe, navega a la pantalla de inicio pasando el ID del usuario
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(userId: usuario.id!), // Pasa el ID del usuario
                            ),
                          );
                        } else {
                          // Si las credenciales son incorrectas, muestra un mensaje de error
                          setState(() {
                            _errorMessage = 'Correo electrónico o contraseña incorrectos';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 20),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Aceptar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navega a la pantalla de registro
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 20),
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
