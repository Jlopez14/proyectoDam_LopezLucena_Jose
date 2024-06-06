import 'package:flutter/material.dart';
import '../models/alimentos.dart';
import '../models/categorias.dart';
import '../services/DbAlimentos.dart';
import '../services/DbCategorias.dart';
import 'package:intl/intl.dart';

class InventoryScreen extends StatefulWidget {
  final int userId; // Identificador del usuario

  InventoryScreen({required this.userId});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Alimento> alimentos = []; // Lista de alimentos
  List<Categoria> categorias = []; // Lista de categorías
  String searchQuery = ''; // Consulta de búsqueda
  int? selectedCategory; // Categoría seleccionada

  @override
  void initState() {
    super.initState();
    _loadData(); // Carga los datos al inicializar el estado
  }

  // Método para cargar los datos de alimentos y categorías
  Future<void> _loadData() async {
    List<Alimento> allAlimentos = await DbAlimentos.alimentos();
    List<Categoria> allCategorias = await DbCategorias.getCategorias();
    setState(() {
      // Filtra los alimentos por el usuario actual y asigna colores a las categorías
      alimentos = allAlimentos.where((alimento) => alimento.usuarioId == widget.userId).toList();
      categorias = allCategorias.map((categoria) {
        categoria.color = Categoria.getColorForCategory(categoria.nombre);
        return categoria;
      }).toList();
    });
  }

  // Método para filtrar los alimentos según la consulta de búsqueda y la categoría seleccionada
  List<Alimento> get filteredAlimentos {
    List<Alimento> filteredList = alimentos.where((alimento) {
      bool matchesSearchQuery = alimento.nombre.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCategory = selectedCategory == null || alimento.categoriaId == selectedCategory;
      return matchesSearchQuery && matchesCategory;
    }).toList();

    filteredList.sort((a, b) {
      if (a.fechaCaducidad == null || b.fechaCaducidad == null) {
        return 0;
      }
      return a.fechaCaducidad!.compareTo(b.fechaCaducidad!);
    });

    return filteredList;
  }

  // Método para mostrar información de las categorías en un cuadro de diálogo
  void _showCategoryHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información de Categorías'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: categorias.map((categoria) {
                return Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: categoria.color,
                    ),
                    SizedBox(width: 10),
                    Text(categoria.nombre),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Gestión de Alimentos', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        automaticallyImplyLeading: false, // Oculta la flecha de volver atrás
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de texto para la búsqueda
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            // Dropdown para seleccionar la categoría
            Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: selectedCategory,
                    hint: Text('Categoría'),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text('Mostrar todas las categorías'),
                      ),
                      ...categorias.map((Categoria categoria) {
                        return DropdownMenuItem<int>(
                          value: categoria.id,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                // Botón de ayuda para mostrar información de las categorías
                IconButton(
                  icon: Icon(Icons.help_outline),
                  onPressed: () => _showCategoryHelp(context),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Título de la lista de alimentos
            Text(
              'Alimentos:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              // Lista de alimentos filtrados
              child: ListView.builder(
                itemCount: filteredAlimentos.length,
                itemBuilder: (context, index) {
                  final categoria = categorias.firstWhere(
                        (cat) => cat.id == filteredAlimentos[index].categoriaId,
                    orElse: () => Categoria(id: null, nombre: 'Desconocido', color: Colors.grey),
                  );
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: categoria.color,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ListTile(
                      title: Text(
                        filteredAlimentos[index].nombre,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categoría: ${categoria.nombre}', style: TextStyle(color: Colors.black)),
                          Text('Fecha de Caducidad: ${filteredAlimentos[index].fechaCaducidad != null ? DateFormat('yyyy-MM-dd').format(filteredAlimentos[index].fechaCaducidad!) : 'N/A'}', style: TextStyle(color: Colors.black)),
                          Text('Cantidad: ${filteredAlimentos[index].cantidad.toString()}', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botón para editar el alimento
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              _mostrarDialogoEditarAlimento(context, filteredAlimentos[index]);
                            },
                          ),
                          // Botón para eliminar el alimento
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              eliminarAlimento(context, filteredAlimentos[index].id!);
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
            // Botón para insertar un nuevo alimento
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _mostrarDialogoAgregarAlimento(context);
                },
                child: Text('Insertar Alimento'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para actualizar la lista de alimentos
  void _actualizarAlimentos() {
    _loadData();
  }

  // Método para mostrar el cuadro de diálogo para agregar un nuevo alimento
  void _mostrarDialogoAgregarAlimento(BuildContext context) async {
    TextEditingController nombreController = TextEditingController();
    TextEditingController cantidadController = TextEditingController();
    int? categoriaSeleccionada;
    DateTime? fechaCompra;
    DateTime? fechaCaducidad;

    // Método para seleccionar una fecha usando un selector de fecha
    Future<void> _selectDate(BuildContext context, DateTime? initialDate, Function(DateTime) onDateSelected) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != initialDate) {
        onDateSelected(picked);
      }
    }

    // Muestra el cuadro de diálogo para agregar un alimento
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Insertar Alimento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
                    DropdownButton<int>(
                      value: categoriaSeleccionada,
                      hint: Text('Selecciona una Categoría'),
                      onChanged: (int? newValue) {
                        setState(() {
                          categoriaSeleccionada = newValue;
                        });
                      },
                      items: categorias.map((Categoria categoria) {
                        return DropdownMenuItem<int>(
                          value: categoria.id,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fechaCompra != null ? 'Fecha de Compra: ${DateFormat('yyyy-MM-dd').format(fechaCompra!)}' : 'Fecha de Compra',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectDate(context, fechaCompra, (pickedDate) {
                            setState(() {
                              fechaCompra = pickedDate;
                            });
                          }),
                          icon: Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fechaCaducidad != null ? 'Fecha de Caducidad: ${DateFormat('yyyy-MM-dd').format(fechaCaducidad!)}' : 'Fecha de Caducidad',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectDate(context, fechaCaducidad, (pickedDate) {
                            setState(() {
                              fechaCaducidad = pickedDate;
                            });
                          }),
                          icon: Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    TextField(controller: cantidadController, decoration: InputDecoration(labelText: 'Cantidad')),
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
                    if (categoriaSeleccionada != null && fechaCompra != null && fechaCaducidad != null) {
                      Alimento nuevoAlimento = Alimento(
                        nombre: nombreController.text,
                        categoriaId: categoriaSeleccionada,
                        fechaCompra: fechaCompra,
                        fechaCaducidad: fechaCaducidad,
                        cantidad: int.parse(cantidadController.text),
                        usuarioId: widget.userId,
                      );
                      await DbAlimentos.insert(nuevoAlimento);
                      Navigator.of(context).pop();
                      _actualizarAlimentos();
                    } else {
                      // Mostrar un mensaje de error o validación
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Método para mostrar el cuadro de diálogo para editar un alimento
  void _mostrarDialogoEditarAlimento(BuildContext context, Alimento alimento) async {
    TextEditingController nombreController = TextEditingController(text: alimento.nombre);
    TextEditingController cantidadController = TextEditingController(text: alimento.cantidad.toString());
    int? categoriaSeleccionada = alimento.categoriaId;
    DateTime? fechaCompra = alimento.fechaCompra;
    DateTime? fechaCaducidad = alimento.fechaCaducidad;

    // Método para seleccionar una fecha usando un selector de fecha
    Future<void> _selectDate(BuildContext context, DateTime? initialDate, Function(DateTime) onDateSelected) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != initialDate) {
        onDateSelected(picked);
      }
    }

    // Muestra el cuadro de diálogo para editar un alimento
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Editar Alimento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
                    DropdownButton<int>(
                      value: categoriaSeleccionada,
                      hint: Text('Selecciona una Categoría'),
                      onChanged: (int? newValue) {
                        setState(() {
                          categoriaSeleccionada = newValue;
                        });
                      },
                      items: categorias.map((Categoria categoria) {
                        return DropdownMenuItem<int>(
                          value: categoria.id,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fechaCompra != null ? 'Fecha de Compra: ${DateFormat('yyyy-MM-dd').format(fechaCompra!)}' : 'Fecha de Compra',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectDate(context, fechaCompra, (pickedDate) {
                            setState(() {
                              fechaCompra = pickedDate;
                            });
                          }),
                          icon: Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fechaCaducidad != null ? 'Fecha de Caducidad: ${DateFormat('yyyy-MM-dd').format(fechaCaducidad!)}' : 'Fecha de Caducidad',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectDate(context, fechaCaducidad, (pickedDate) {
                            setState(() {
                              fechaCaducidad = pickedDate;
                            });
                          }),
                          icon: Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    TextField(controller: cantidadController, decoration: InputDecoration(labelText: 'Cantidad')),
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
                    if (categoriaSeleccionada != null && fechaCompra != null && fechaCaducidad != null) {
                      Alimento alimentoModificado = Alimento(
                        id: alimento.id,
                        nombre: nombreController.text,
                        categoriaId: categoriaSeleccionada,
                        fechaCompra: fechaCompra,
                        fechaCaducidad: fechaCaducidad,
                        cantidad: int.parse(cantidadController.text),
                        usuarioId: widget.userId,
                      );
                      await DbAlimentos.update(alimentoModificado);
                      Navigator.of(context).pop();
                      _actualizarAlimentos();
                    } else {
                      // Mostrar un mensaje de error o validación
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Método para eliminar un alimento
  void eliminarAlimento(BuildContext context, int idAlimento) async {
    await DbAlimentos.delete(idAlimento);

    // Muestra un mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Alimento eliminado')));

    // Actualiza la lista de alimentos
    _actualizarAlimentos();
  }
}
