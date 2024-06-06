class Consejo {
  int? id;
  String titulo;
  String contenido;
  int? categoriaId;

  Consejo({
    this.id,
    required this.titulo,
    required this.contenido,
    this.categoriaId,
  });

  // Convierte un objeto Consejo en un Map
  Map<String, dynamic> toMap() {
    return {
      'consejo_id': id,
      'titulo': titulo,
      'contenido': contenido,
      'categoria_id': categoriaId,
    };
  }

  // Crea un objeto Consejo a partir de un Map
  factory Consejo.fromMap(Map<String, dynamic> map) {
    return Consejo(
      id: map['consejo_id'],
      titulo: map['titulo'],
      contenido: map['contenido'],
      categoriaId: map['categoria_id'],
    );
  }
}
