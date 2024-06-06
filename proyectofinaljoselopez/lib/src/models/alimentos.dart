class Alimento {
  int? id;
  String nombre;
  int? categoriaId;
  DateTime? fechaCompra;
  DateTime? fechaCaducidad;
  int cantidad;
  int usuarioId;

  Alimento({
    this.id,
    required this.nombre,
    this.categoriaId,
    this.fechaCompra,
    this.fechaCaducidad,
    required this.cantidad,
    required this.usuarioId,
  });

  // Convierte un objeto Alimento en un Map
  Map<String, dynamic> toMap() {
    return {
      'alimento_id': id,
      'nombre': nombre,
      'categoria_id': categoriaId,
      'fecha_compra': fechaCompra?.toIso8601String(), // Conversión a String
      'fecha_caducidad': fechaCaducidad?.toIso8601String(), // Conversión a String
      'cantidad': cantidad,
      'usuario_id': usuarioId,
    };
  }

  // Crea un objeto Alimento a partir de un Map
  factory Alimento.fromMap(Map<String, dynamic> map) {
    return Alimento(
      id: map['alimento_id'],
      nombre: map['nombre'],
      categoriaId: map['categoria_id'],
      fechaCompra: map['fecha_compra'] != null ? DateTime.parse(map['fecha_compra']) : null,
      fechaCaducidad: map['fecha_caducidad'] != null ? DateTime.parse(map['fecha_caducidad']) : null,
      cantidad: map['cantidad'],
      usuarioId: map['usuario_id'],
    );
  }
}
