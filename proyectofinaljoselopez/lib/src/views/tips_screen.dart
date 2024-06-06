import 'package:flutter/material.dart';
import '../models/categorias.dart';
import '../models/consejos.dart';
import '../services/DbAlimentos.dart';
import '../services/DbCategorias.dart';
import '../services/DbConsejos.dart';
import '../models/alimentos.dart';

class TipsScreen extends StatefulWidget {
  final int userId; // Identificador del usuario

  TipsScreen({required this.userId});

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  List<Consejo> consejos = []; // Lista de consejos
  List<Categoria> categorias = []; // Lista de categorías
  late List<bool> _expanded; // Lista para controlar la expansión de los consejos

  @override
  void initState() {
    super.initState();
    _loadConsejos(); // Carga los consejos al inicializar el estado
  }

  // Método para cargar los consejos desde la base de datos
  Future<void> _loadConsejos() async {
    List<Alimento> alimentos = await DbAlimentos.alimentos();
    List<Categoria> allCategorias = await DbCategorias.getCategorias();
    Set<int?> categoriasIds = alimentos.map((alimento) => alimento.categoriaId).toSet();

    List<Consejo> allConsejos = [];
    for (int? categoriaId in categoriasIds) {
      if (categoriaId != null) {
        List<Consejo> consejosPorCategoria = await DbConsejos.getConsejosByCategory(categoriaId);
        allConsejos.addAll(consejosPorCategoria);
      }
    }

    setState(() {
      consejos = allConsejos;
      categorias = allCategorias;
      _expanded = List<bool>.filled(consejos.length, false); // Inicializa la lista de expansión
    });
  }

  // Método para obtener el color de la categoría
  Color _getCategoriaColor(int? categoriaId) {
    Categoria? categoria = categorias.firstWhere((cat) => cat.id == categoriaId, orElse: () => Categoria(id: null, nombre: '', color: Colors.grey));
    return categoria?.color ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Consejos de Conservación',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Oculta la flecha de volver atrás
      ),
      body: ListView.builder(
        itemCount: consejos.length, // Número de consejos a mostrar
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _expanded[index] = !_expanded[index]; // Cambia el estado de expansión al tocar
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300), // Duración de la animación
              curve: Curves.easeInOut, // Curva de animación
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(12.0),
              height: _expanded[index] ? null : 60.0, // Altura fija cuando está contraído, altura automática cuando está expandido
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: _getCategoriaColor(consejos[index].categoriaId), // Color basado en la categoría
              ),
              child: SingleChildScrollView(
                physics: _expanded[index] ? NeverScrollableScrollPhysics() : null, // Desactiva el scroll cuando está contraído
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido al inicio
                  children: [
                    Text(
                      consejos[index].titulo,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    if (_expanded[index]) ...[
                      SizedBox(height: 5), // Espacio vertical
                      Text(
                        "\"${consejos[index].contenido}\"",
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.visible, // Permite que el texto se expanda
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
