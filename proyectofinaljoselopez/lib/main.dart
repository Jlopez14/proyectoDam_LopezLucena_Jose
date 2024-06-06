import 'package:flutter/material.dart';
import 'package:proyectofinaljoselopez/src/views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que los plugins estén inicializados

  // Inicializa la base de datos
  runApp(MyApp()); // Ejecuta la aplicación
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de modo debug
      title: 'Tu Aplicación', // Título de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Color primario de la aplicación
        visualDensity: VisualDensity.adaptivePlatformDensity, // Ajusta la densidad visual
      ),
      home: LoginScreen(), // Pantalla inicial de la aplicación
    );
  }
}
