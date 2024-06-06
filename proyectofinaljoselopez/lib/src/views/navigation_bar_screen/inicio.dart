import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0; // Índice seleccionado inicialmente

  // Lista de widgets para cada página en la navegación inferior
  final List<Widget> _listadoPaginas = [
    Inicio(), // Aquí deberías agregar las diferentes páginas correspondientes a cada índice
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'), // Título de la AppBar
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Alineación del contenido al centro
        children: [
          SizedBox(height: 20), // Espacio vertical
          Text(
            '¡Bienvenido!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20), // Espacio vertical
          Expanded(
            // Muestra la página correspondiente al índice seleccionado
            child: _listadoPaginas[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Tipo de barra de navegación
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icono de la primera opción
            label: "Inicio", // Etiqueta de la primera opción
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Icono de la segunda opción
            label: "Buscar", // Etiqueta de la segunda opción
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star), // Icono de la tercera opción
            label: "Choice", // Etiqueta de la tercera opción
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), // Icono de la cuarta opción
            label: "Carrito", // Etiqueta de la cuarta opción
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icono de la quinta opción
            label: "Perfil", // Etiqueta de la quinta opción
          )
        ],
        currentIndex: _selectedIndex, // Índice seleccionado actualmente
        onTap: (index) {
          setState(() {
            // Actualiza el estado del índice seleccionado
            _selectedIndex = index;
          });
        },
      ),
      drawer: Drawer(
        // Agrega un Drawer para el menú lateral
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Opción 1'),
              onTap: () {
                // Lógica para la opción 1
              },
            ),
            ListTile(
              title: Text('Opción 2'),
              onTap: () {
                // Lógica para la opción 2
              },
            ),
            // Agrega más ListTile según sea necesario
          ],
        ),
      ),
    );
  }
}
