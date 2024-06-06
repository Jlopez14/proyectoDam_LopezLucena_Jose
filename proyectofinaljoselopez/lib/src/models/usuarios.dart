class Usuario {
  int? id;
  String nombre;
  String correoElectronico;
  String contrasena;
  String? otrosDetallesPerfil;

  Usuario({
    this.id,
    required this.nombre,
    required this.correoElectronico,
    required this.contrasena,
    this.otrosDetallesPerfil,
  });

  // Convierte un objeto Usuario en un Map
  Map<String, dynamic> toMap() {
    return {
      'usuario_id': id,
      'nombre': nombre,
      'correo_electronico': correoElectronico,
      'contrasena': contrasena,
      'otros_detalles_perfil': otrosDetallesPerfil,
    };
  }

  // Crea un objeto Usuario a partir de un Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['usuario_id'],
      nombre: map['nombre'],
      correoElectronico: map['correo_electronico'],
      contrasena: map['contrasena'],
      otrosDetallesPerfil: map['otros_detalles_perfil'],
    );
  }
}
