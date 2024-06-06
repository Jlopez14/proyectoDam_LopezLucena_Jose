import 'package:flutter/material.dart';
import '../models/usuarios.dart';
import '../services/DbUsuarios.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<Usuario> _usuarios = []; // Lista para almacenar los usuarios

  @override
  void initState() {
    super.initState();
    _fetchUsuarios(); // Carga los usuarios al inicializar el estado
  }

  // Método para obtener los usuarios desde la base de datos
  Future<void> _fetchUsuarios() async {
    List<Usuario> usuarios = await DBUsuarios.usuarios();
    setState(() {
      _usuarios = usuarios; // Actualiza la lista de usuarios
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'), // Título de la AppBar
      ),
      body: _usuarios.isEmpty // Si la lista de usuarios está vacía
          ? Center(child: Text('No hay usuarios')) // Muestra un texto indicando que no hay usuarios
          : ListView.builder(
        itemCount: _usuarios.length, // Número de elementos en la lista
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_usuarios[index].nombre), // Nombre del usuario
            subtitle: Text(_usuarios[index].correoElectronico), // Correo electrónico del usuario
            // Muestra el ID del usuario
            trailing: Text('ID: ${_usuarios[index].id}'),
          );
        },
      ),
    );
  }
}
