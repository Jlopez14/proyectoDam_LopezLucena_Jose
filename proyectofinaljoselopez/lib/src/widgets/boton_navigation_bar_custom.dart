import 'package:flutter/material.dart';

// Función para crear un BottomNavigationBarItem
BottomNavigationBarItem bottomNavigationBarItem(IconData icon, String nombre) {
  // Devuelve un BottomNavigationBarItem con un icono y una etiqueta
  return BottomNavigationBarItem(
    icon: Icon(icon), // Icono del item
    label: nombre, // Etiqueta del item
  );
}
