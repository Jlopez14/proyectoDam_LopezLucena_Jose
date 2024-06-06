import 'package:flutter/material.dart';
import '../models/alimentos.dart';
import '../models/categorias.dart';
import '../models/ingredientes_recetas.dart';
import '../models/recetas.dart';
import '../services/DbAlimentos.dart';
import '../services/DbIIngredientesRecetas.dart';
import '../services/DbRecetas.dart';
import '../services/DbCategorias.dart';

class RecipesScreen extends StatefulWidget {
  final int userId;

  RecipesScreen({required this.userId});

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<Receta> recetas = [];
  List<Alimento> alimentos = [];
  List<Categoria> categorias = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Carga todas las recetas, alimentos y categorías
  Future<void> _loadData() async {
    await Future.wait([_loadRecetas(), _loadAlimentos(), _loadCategorias()]);
    setState(() {
      isLoading = false;
    });
  }

  // Carga las recetas desde la base de datos
  Future<void> _loadRecetas() async {
    List<Receta> allRecetas = await DbRecetas.getRecetas();
    setState(() {
      recetas = allRecetas;
    });
  }

  // Carga los alimentos desde la base de datos y filtra por el usuario logueado
  Future<void> _loadAlimentos() async {
    List<Alimento> allAlimentos = await DbAlimentos.alimentos();
    setState(() {
      alimentos = allAlimentos.where((alimento) => alimento.usuarioId == widget.userId).toList();
    });
  }

  // Carga las categorías desde la base de datos
  Future<void> _loadCategorias() async {
    List<Categoria> allCategorias = await DbCategorias.getCategorias();
    setState(() {
      categorias = allCategorias;
    });
  }

  // Filtra las recetas según la consulta de búsqueda
  List<Receta> _filterRecetas(List<Receta> recetas) {
    if (searchQuery.isEmpty) {
      return recetas;
    } else {
      return recetas.where((receta) {
        return receta.nombre.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  // Ordena las recetas para que las que tienen ingredientes disponibles aparezcan primero
  List<Receta> _sortRecetas(List<Receta> recetas) {
    List<int> availableAlimentosIds = alimentos.map((alimento) => alimento.id!).toList();
    recetas.sort((a, b) {
      bool aHasIngredients = a.ingredientes.any((ingrediente) => availableAlimentosIds.contains(ingrediente.alimentoId));
      bool bHasIngredients = b.ingredientes.any((ingrediente) => availableAlimentosIds.contains(ingrediente.alimentoId));
      if (aHasIngredients && !bHasIngredients) {
        return -1;
      } else if (!aHasIngredients && bHasIngredients) {
        return 1;
      } else {
        return 0;
      }
    });
    return recetas;
  }

  // Obtiene el color de la receta según la categoría de su ingrediente principal
  Color _getRecipeColor(Receta receta) {
    if (receta.ingredientes.isNotEmpty) {
      IngredienteReceta ingredientePrincipal = receta.ingredientes.first;
      Alimento alimento = alimentos.firstWhere(
            (a) => a.id == ingredientePrincipal.alimentoId,
        orElse: () => Alimento(id: 0, nombre: 'Desconocido', categoriaId: 0, cantidad: 0, fechaCompra: DateTime.now(), fechaCaducidad: DateTime.now(), usuarioId: widget.userId),
      );
      Categoria categoria = categorias.firstWhere(
            (cat) => cat.id == alimento.categoriaId,
        orElse: () => Categoria(id: 0, nombre: 'Desconocido', color: Colors.grey),
      );
      return categoria.color;
    }
    return Colors.grey[100]!;
  }

  @override
  Widget build(BuildContext context) {
    List<Receta> filteredRecetas = _filterRecetas(recetas);
    List<Receta> sortedRecetas = _sortRecetas(filteredRecetas);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Gestión de Recetas',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar Recetas',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Recetas:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sortedRecetas.length,
                itemBuilder: (context, index) {
                  Receta receta = sortedRecetas[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _getRecipeColor(receta), // Asigna el color de la receta
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ListTile(
                      title: Text(
                        receta.nombre,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tiempo de Preparación: ${receta.tiempoPreparacion} minutos', style: TextStyle(color: Colors.black)),
                          Text('Instrucciones: ${receta.instrucciones}', style: TextStyle(color: Colors.black)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: receta.ingredientes.map((ingrediente) {
                              final alimento = alimentos.firstWhere(
                                      (a) => a.id == ingrediente.alimentoId,
                                  orElse: () => Alimento(id: 0, nombre: 'Desconocido', categoriaId: 0, cantidad: 0, fechaCompra: DateTime.now(), fechaCaducidad: DateTime.now(), usuarioId: widget.userId));
                              return Text('${alimento.nombre}: ${ingrediente.cantidad}');
                            }).toList(),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              _mostrarDialogoEditarReceta(context, receta);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              eliminarReceta(context, receta.id!);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.menu_book, color: Colors.black),
                            onPressed: () {
                              _mostrarDialogoHacerReceta(context, receta);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _mostrarDialogoAgregarReceta(context);
                },
                child: Text('Insertar Receta'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Actualiza la lista de recetas, alimentos y categorías
  void _actualizarRecetas() {
    _loadData();
  }

  // Muestra el diálogo para agregar una nueva receta
  void _mostrarDialogoAgregarReceta(BuildContext context) async {
    TextEditingController nombreController = TextEditingController();
    TextEditingController instruccionesController = TextEditingController();
    TextEditingController tiempoPreparacionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insertar Receta'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
                TextField(controller: instruccionesController, decoration: InputDecoration(labelText: 'Instrucciones')),
                TextField(controller: tiempoPreparacionController, decoration: InputDecoration(labelText: 'Tiempo de Preparación (minutos)')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Insertar'),
              onPressed: () async {
                Receta nuevaReceta = Receta(
                  nombre: nombreController.text,
                  instrucciones: instruccionesController.text,
                  tiempoPreparacion: int.parse(tiempoPreparacionController.text),
                  usuarioId: widget.userId,
                );
                await DbRecetas.insert(nuevaReceta);
                Navigator.of(context).pop();
                _actualizarRecetas();
              },
            ),
          ],
        );
      },
    );
  }

  // Muestra el diálogo para editar una receta existente
  void _mostrarDialogoEditarReceta(BuildContext context, Receta receta) async {
    TextEditingController nombreController = TextEditingController(text: receta.nombre);
    TextEditingController instruccionesController = TextEditingController(text: receta.instrucciones);
    TextEditingController tiempoPreparacionController = TextEditingController(text: receta.tiempoPreparacion.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Receta'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
                TextField(controller: instruccionesController, decoration: InputDecoration(labelText: 'Instrucciones')),
                TextField(controller: tiempoPreparacionController, decoration: InputDecoration(labelText: 'Tiempo de Preparación (minutos)')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () async {
                Receta recetaModificada = Receta(
                  id: receta.id,
                  nombre: nombreController.text,
                  instrucciones: instruccionesController.text,
                  tiempoPreparacion: int.parse(tiempoPreparacionController.text),
                  usuarioId: widget.userId,
                );
                await DbRecetas.update(recetaModificada);
                Navigator.of(context).pop();
                _actualizarRecetas();
              },
            ),
          ],
        );
      },
    );
  }

  // Muestra el diálogo para hacer una receta, permitiendo seleccionar alimentos y cantidades
  void _mostrarDialogoHacerReceta(BuildContext context, Receta receta) async {
    List<Alimento> selectedAlimentos = [];
    Map<int, TextEditingController> cantidadControllers = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Hacer Receta'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Seleccionar Alimentos:', style: TextStyle(fontWeight: FontWeight.bold)),
                    // Muestra una lista de alimentos disponibles
                    ...alimentos.map((alimento) {
                      return CheckboxListTile(
                        title: Text(alimento.nombre),
                        value: selectedAlimentos.contains(alimento),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected!) {
                              selectedAlimentos.add(alimento);
                              cantidadControllers[alimento.id!] = TextEditingController();
                            } else {
                              selectedAlimentos.remove(alimento);
                              cantidadControllers.remove(alimento.id!);
                            }
                          });
                        },
                      );
                    }).toList(),
                    // Muestra campos de texto para ingresar las cantidades de los alimentos seleccionados
                    ...selectedAlimentos.map((alimento) {
                      return TextField(
                        controller: cantidadControllers[alimento.id!],
                        decoration: InputDecoration(labelText: 'Cantidad de ${alimento.nombre}'),
                        keyboardType: TextInputType.number,
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Hacer Receta'),
                  onPressed: () async {
                    for (var alimento in selectedAlimentos) {
                      int cantidadUsada = int.parse(cantidadControllers[alimento.id!]!.text);
                      if (alimento.cantidad! < cantidadUsada) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cantidad insuficiente de ${alimento.nombre}')),
                        );
                        return;
                      }
                      alimento.cantidad = alimento.cantidad! - cantidadUsada;
                      if (alimento.cantidad! == 0) {
                        await DbAlimentos.delete(alimento.id!);
                      } else {
                        await DbAlimentos.update(alimento);
                      }
                    }
                    Navigator.of(context).pop();
                    _actualizarRecetas();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Receta hecha con éxito')),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Elimina una receta de la base de datos
  void eliminarReceta(BuildContext context, int idReceta) async {
    await DbRecetas.delete(idReceta);
    await DbIngredientesRecetas.delete(idReceta, 0); // Eliminar todos los ingredientes de la receta

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Receta eliminada')));

    _actualizarRecetas();
  }
}
