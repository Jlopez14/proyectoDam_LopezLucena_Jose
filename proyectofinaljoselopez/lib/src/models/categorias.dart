import 'package:flutter/material.dart';

class Categoria {
  int? id;
  String nombre;
  String? descripcion;
  Color color;

  Categoria({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.color,
  });

  // Convierte un objeto Categoria en un Map
  Map<String, dynamic> toMap() {
    return {
      'categoria_id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      // Color no se guarda en la base de datos, se usa solo en la app
    };
  }

  // Crea un objeto Categoria a partir de un Map
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['categoria_id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      color: Categoria.getColorForCategory(map['nombre']),
    );
  }

  static Color getColorForCategory(String nombreCategoria) {
    switch (nombreCategoria) {
      case 'Frutas':
        return Colors.red;
      case 'Verduras':
        return Colors.green;
      case 'Carnes':
        return Colors.brown;
      case 'Pescados y Mariscos':
        return Colors.blue;
      case 'Lácteos':
        return Colors.orange;
      case 'Panadería y Repostería':
        return Colors.yellow;
      case 'Bebidas':
        return Colors.purple;
      case 'Granos y Legumbres':
        return Colors.amber;
      case 'Comida Rápida':
        return Colors.deepOrange;
      case 'Comida Internacional':
        return Colors.teal;
      case 'Platos Preparados':
        return Colors.lightBlue;
      case 'Snacks y Botanas':
        return Colors.lime;
      case 'Postres':
        return Colors.pink;
      case 'Salsas y Condimentos':
        return Colors.redAccent;
      case 'Sopas y Caldos':
        return Colors.deepPurple;
      case 'Pastas':
        return Colors.cyan;
      case 'Productos Congelados':
        return Colors.indigo;
      case 'Productos Orgánicos':
        return Colors.greenAccent;
      case 'Comida para Bebés':
        return Colors.blueAccent;
      case 'Suplementos Alimenticios':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
