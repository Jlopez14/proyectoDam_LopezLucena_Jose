import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConexionDB {
  static Database? _database;

  // Método para obtener la instancia de la base de datos
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  // Método para inicializar la base de datos
  static Future<Database> _initDB() async {
    print("ABRIENDO LA BASE DE DATOS");
    try {
      return await openDatabase(
        join(await getDatabasesPath(), 'desperdiciocero.db'),
        onCreate: _onCreate,
        version: 1,
      );
    } catch (e) {
      print("Error al abrir la base de datos: $e");
      rethrow;
    }
  }

  // Método para crear las tablas en la base de datos e insertar datos iniciales
  static Future<void> _onCreate(Database db, int version) async {
    print("CREANDO LA BASE DE DATOS Y TABLAS");
    try {
      await db.execute(
        '''CREATE TABLE Usuarios (
            usuario_id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            correo_electronico TEXT NOT NULL UNIQUE,
            contrasena TEXT NOT NULL,
            otros_detalles_perfil TEXT
        )''',
      );
      await db.execute(
        '''CREATE TABLE Categorias (
            categoria_id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            descripcion TEXT
        )''',
      );
      await db.execute(
        '''CREATE TABLE Alimentos (
            alimento_id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            categoria_id INTEGER,
            fecha_compra DATE,
            fecha_caducidad DATE,
            cantidad INTEGER,
            usuario_id INTEGER,
            FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id),
            FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
        )''',
      );
      await db.execute(
        '''CREATE TABLE Recetas (
            receta_id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            instrucciones TEXT NOT NULL,
            tiempo_preparacion INTEGER,
            usuario_id INTEGER,
            FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
        )''',
      );
      await db.execute(
        '''CREATE TABLE Ingredientes_Recetas (
            receta_id INTEGER,
            alimento_id INTEGER,
            cantidad INTEGER,
            PRIMARY KEY (receta_id, alimento_id),
            FOREIGN KEY (receta_id) REFERENCES Recetas(receta_id),
            FOREIGN KEY (alimento_id) REFERENCES Alimentos(alimento_id)
        )''',
      );
      await db.execute(
        '''CREATE TABLE Consejos (
            consejo_id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            contenido TEXT NOT NULL,
            categoria_id INTEGER,
            FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id)
        )''',
      );

      // Insertar datos iniciales en la tabla Categorias
      await db.insert('Categorias', {'nombre': 'Frutas', 'descripcion': 'Frutas frescas y de temporada'});
      await db.insert('Categorias', {'nombre': 'Verduras', 'descripcion': 'Verduras frescas y de temporada'});
      await db.insert('Categorias', {'nombre': 'Carnes', 'descripcion': 'Carne de res, pollo, cerdo y otras carnes'});
      await db.insert('Categorias', {'nombre': 'Pescados y Mariscos', 'descripcion': 'Pescados y mariscos frescos'});
      await db.insert('Categorias', {'nombre': 'Lácteos', 'descripcion': 'Productos lácteos como leche, queso, yogur'});
      await db.insert('Categorias', {'nombre': 'Panadería y Repostería', 'descripcion': 'Productos de panadería y repostería'});
      await db.insert('Categorias', {'nombre': 'Bebidas', 'descripcion': 'Bebidas no alcohólicas y alcohólicas'});
      await db.insert('Categorias', {'nombre': 'Granos y Legumbres', 'descripcion': 'Arroz, frijoles, lentejas y otros granos'});
      await db.insert('Categorias', {'nombre': 'Comida Rápida', 'descripcion': 'Hamburguesas, pizzas, tacos y otros alimentos rápidos'});
      await db.insert('Categorias', {'nombre': 'Comida Internacional', 'descripcion': 'Platos de diferentes cocinas internacionales'});
      await db.insert('Categorias', {'nombre': 'Platos Preparados', 'descripcion': 'Comidas listas para consumir'});
      await db.insert('Categorias', {'nombre': 'Snacks y Botanas', 'descripcion': 'Aperitivos y bocadillos'});
      await db.insert('Categorias', {'nombre': 'Postres', 'descripcion': 'Dulces, pasteles, helados y otros postres'});
      await db.insert('Categorias', {'nombre': 'Salsas y Condimentos', 'descripcion': 'Salsas, especias y condimentos'});
      await db.insert('Categorias', {'nombre': 'Sopas y Caldos', 'descripcion': 'Sopas, caldos y cremas'});
      await db.insert('Categorias', {'nombre': 'Pastas', 'descripcion': 'Pasta y productos relacionados'});
      await db.insert('Categorias', {'nombre': 'Productos Congelados', 'descripcion': 'Alimentos congelados'});
      await db.insert('Categorias', {'nombre': 'Productos Orgánicos', 'descripcion': 'Productos orgánicos y ecológicos'});
      await db.insert('Categorias', {'nombre': 'Comida para Bebés', 'descripcion': 'Alimentos y productos para bebés'});
      await db.insert('Categorias', {'nombre': 'Suplementos Alimenticios', 'descripcion': 'Vitaminas, proteínas y otros suplementos'});

      // Insertar los consejos con categoría_id
      await db.insert('Consejos', {'titulo': 'Tomates frescos', 'contenido': 'Guarda los tomates a temperatura ambiente para mantener su sabor.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Pepinos', 'contenido': 'Almacena los pepinos en el cajón de las verduras del refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Zanahorias crujientes', 'contenido': 'Guarda las zanahorias en un recipiente con agua para mantenerlas crujientes.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Pimientos', 'contenido': 'Guarda los pimientos en el refrigerador para mantener su frescura.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Lechuga crujiente', 'contenido': 'Envuelve la lechuga en papel de aluminio para mantenerla crujiente.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Espinacas frescas', 'contenido': 'Guarda las espinacas en una bolsa de plástico en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Col rizada', 'contenido': 'Guarda la col rizada en una bolsa de plástico en el refrigerador para mantenerla fresca.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Acelga', 'contenido': 'Envuelve la acelga en una toalla de papel húmeda y guárdala en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Calabacín', 'contenido': 'Guarda el calabacín en el refrigerador para mantener su frescura.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Berenjena', 'contenido': 'Almacena la berenjena en un lugar fresco y oscuro para prolongar su vida útil.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Maíz', 'contenido': 'Guarda el maíz en el refrigerador para mantener su frescura.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Brócoli', 'contenido': 'Envuelve el brócoli en una toalla de papel húmeda y guárdalo en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Coliflor', 'contenido': 'Guarda la coliflor en una bolsa de plástico en el refrigerador para mantener su frescura.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Repollo', 'contenido': 'Almacena el repollo en una bolsa de plástico en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Chiles', 'contenido': 'Guarda los chiles en una bolsa de plástico en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Rábanos', 'contenido': 'Guarda los rábanos en un recipiente con agua en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Setas', 'contenido': 'Guarda las setas en una bolsa de papel en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Ajos', 'contenido': 'Almacena los ajos en un lugar fresco y oscuro para evitar que broten.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Nabos', 'contenido': 'Guarda los nabos en una bolsa de plástico en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Remolachas', 'contenido': 'Guarda las remolachas en una bolsa de plástico en el refrigerador.', 'categoria_id': 2});
      await db.insert('Consejos', {'titulo': 'Peras', 'contenido': 'Guarda las peras en el refrigerador para evitar que maduren demasiado rápido.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Melones', 'contenido': 'Almacena los melones a temperatura ambiente hasta que estén maduros, luego guárdalos en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Sandías', 'contenido': 'Guarda las sandías a temperatura ambiente para mantener su sabor.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Piñas', 'contenido': 'Guarda las piñas a temperatura ambiente hasta que estén maduras, luego guárdalas en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Mangos', 'contenido': 'Almacena los mangos a temperatura ambiente hasta que estén maduros, luego guárdalos en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Kiwis', 'contenido': 'Guarda los kiwis en el refrigerador para mantener su frescura.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Cerezas', 'contenido': 'Guarda las cerezas en una bolsa de plástico en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Ciruelas', 'contenido': 'Almacena las ciruelas a temperatura ambiente hasta que estén maduras, luego guárdalas en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Duraznos', 'contenido': 'Guarda los duraznos a temperatura ambiente hasta que estén maduros, luego guárdalos en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Albaricoques', 'contenido': 'Almacena los albaricoques a temperatura ambiente hasta que estén maduros, luego guárdalos en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Granadas', 'contenido': 'Guarda las granadas en el refrigerador para mantener su frescura.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Papayas', 'contenido': 'Almacena las papayas a temperatura ambiente hasta que estén maduras, luego guárdalas en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Frambuesas', 'contenido': 'Guarda las frambuesas en una bolsa de plástico en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Moras', 'contenido': 'Almacena las moras en una bolsa de plástico en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Pomelos', 'contenido': 'Guarda los pomelos en el refrigerador para mantener su frescura.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Mandarinas', 'contenido': 'Guarda las mandarinas en el refrigerador para evitar que se sequen.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Limones', 'contenido': 'Almacena los limones en el refrigerador para prolongar su vida útil.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Limas', 'contenido': 'Guarda las limas en el refrigerador para mantener su frescura.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Naranjas', 'contenido': 'Guarda las naranjas en el refrigerador para mantener su frescura.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Uvas verdes', 'contenido': 'Guarda las uvas verdes en una bolsa de plástico perforada en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Uvas rojas', 'contenido': 'Guarda las uvas rojas en una bolsa de plástico perforada en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Arándanos', 'contenido': 'Almacena los arándanos en una bolsa de plástico en el refrigerador.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Pasas', 'contenido': 'Guarda las pasas en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Higos', 'contenido': 'Guarda los higos en el refrigerador para mantener su frescura.', 'categoria_id': 1});
      await db.insert('Consejos', {'titulo': 'Almendras', 'contenido': 'Guarda las almendras en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Nueces', 'contenido': 'Almacena las nueces en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Anacardos', 'contenido': 'Guarda los anacardos en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Pistachos', 'contenido': 'Almacena los pistachos en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Avellanas', 'contenido': 'Guarda las avellanas en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Semillas de chía', 'contenido': 'Guarda las semillas de chía en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Semillas de lino', 'contenido': 'Almacena las semillas de lino en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Semillas de calabaza', 'contenido': 'Guarda las semillas de calabaza en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Semillas de girasol', 'contenido': 'Almacena las semillas de girasol en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Avena', 'contenido': 'Guarda la avena en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Arroz', 'contenido': 'Guarda el arroz en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Quinua', 'contenido': 'Almacena la quinua en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Cuscús', 'contenido': 'Guarda el cuscús en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Amaranto', 'contenido': 'Almacena el amaranto en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Trigo sarraceno', 'contenido': 'Guarda el trigo sarraceno en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Mijo', 'contenido': 'Guarda el mijo en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Frijoles negros', 'contenido': 'Almacena los frijoles negros en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Frijoles pintos', 'contenido': 'Guarda los frijoles pintos en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Garbanzos', 'contenido': 'Almacena los garbanzos en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Lentejas', 'contenido': 'Guarda las lentejas en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Guisantes partidos', 'contenido': 'Almacena los guisantes partidos en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Soja', 'contenido': 'Guarda la soja en un recipiente hermético en un lugar fresco y oscuro.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Tofu', 'contenido': 'Almacena el tofu en el refrigerador en su envase original.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Tempeh', 'contenido': 'Guarda el tempeh en el refrigerador en su envase original.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Seitan', 'contenido': 'Almacena el seitan en el refrigerador en su envase original.', 'categoria_id': 8});
      await db.insert('Consejos', {'titulo': 'Leche de almendra', 'contenido': 'Guarda la leche de almendra en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Leche de soja', 'contenido': 'Almacena la leche de soja en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Leche de coco', 'contenido': 'Guarda la leche de coco en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Leche de avena', 'contenido': 'Almacena la leche de avena en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Yogur de coco', 'contenido': 'Guarda el yogur de coco en el refrigerador.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Yogur de almendra', 'contenido': 'Almacena el yogur de almendra en el refrigerador.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Queso de soja', 'contenido': 'Guarda el queso de soja en el refrigerador.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Queso de almendra', 'contenido': 'Almacena el queso de almendra en el refrigerador.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Queso de anacardos', 'contenido': 'Guarda el queso de anacardos en el refrigerador.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Crema de coco', 'contenido': 'Almacena la crema de coco en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Crema de almendra', 'contenido': 'Guarda la crema de almendra en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Mantequilla de maní', 'contenido': 'Almacena la mantequilla de maní en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Mantequilla de almendra', 'contenido': 'Guarda la mantequilla de almendra en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Mantequilla de anacardos', 'contenido': 'Almacena la mantequilla de anacardos en el refrigerador una vez abierta.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Margarina', 'contenido': 'Guarda la margarina en el refrigerador.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Manteca de coco', 'contenido': 'Almacena la manteca de coco en el refrigerador.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Aceite de coco', 'contenido': 'Guarda el aceite de coco en un lugar fresco y oscuro.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Aceite de oliva', 'contenido': 'Almacena el aceite de oliva en un lugar fresco y oscuro.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Aceite de aguacate', 'contenido': 'Guarda el aceite de aguacate en un lugar fresco y oscuro.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Aceite de sésamo', 'contenido': 'Almacena el aceite de sésamo en un lugar fresco y oscuro.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Aceite de girasol', 'contenido': 'Guarda el aceite de girasol en un lugar fresco y oscuro.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Aceite de cacahuete', 'contenido': 'Almacena el aceite de cacahuete en un lugar fresco y oscuro.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Aceite de canola', 'contenido': 'Guarda el aceite de canola en un lugar fresco y oscuro.', 'categoria_id': 5});
      await db.insert('Consejos', {'titulo': 'Vinagre balsámico', 'contenido': 'Almacena el vinagre balsámico en un lugar fresco y oscuro.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Vinagre de manzana', 'contenido': 'Guarda el vinagre de manzana en un lugar fresco y oscuro.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Vinagre de vino', 'contenido': 'Almacena el vinagre de vino en un lugar fresco y oscuro.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Vinagre de arroz', 'contenido': 'Guarda el vinagre de arroz en un lugar fresco y oscuro.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Vinagre de malta', 'contenido': 'Almacena el vinagre de malta en un lugar fresco y oscuro.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Salsa de soja', 'contenido': 'Guarda la salsa de soja en el refrigerador una vez abierta.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Salsa de tomate', 'contenido': 'Almacena la salsa de tomate en el refrigerador una vez abierta.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Salsa BBQ', 'contenido': 'Guarda la salsa BBQ en el refrigerador una vez abierta.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Mostaza', 'contenido': 'Almacena la mostaza en el refrigerador una vez abierta.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Kétchup', 'contenido': 'Guarda el kétchup en el refrigerador una vez abierto.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Mayonesa', 'contenido': 'Almacena la mayonesa en el refrigerador una vez abierta.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Mermelada', 'contenido': 'Guarda la mermelada en el refrigerador una vez abierta.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Miel', 'contenido': 'Almacena la miel en un lugar fresco y oscuro.', 'categoria_id': 14});
      await db.insert('Consejos', {'titulo': 'Jarabe de arce', 'contenido': 'Guarda el jarabe de arce en el refrigerador una vez abierto.', 'categoria_id': 14});

// Lista original de recetas
      await db.insert('Recetas', {'nombre': 'Spaghetti Carbonara', 'instrucciones': 'Hervir la pasta, cocinar el tocino, mezclar con huevo y queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ensalada César', 'instrucciones': 'Mezclar lechuga, crutones, queso parmesano y aderezo César.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tacos al Pastor', 'instrucciones': 'Marinar la carne, cocinar y servir en tortillas con piña.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sushi', 'instrucciones': 'Preparar el arroz, cortar el pescado y enrollar en alga nori.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Paella', 'instrucciones': 'Cocinar arroz con mariscos, pollo, azafrán y verduras.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Hamburguesa', 'instrucciones': 'Cocinar la carne, armar la hamburguesa con los ingredientes deseados.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pizza Margherita', 'instrucciones': 'Preparar la masa, agregar tomate, mozzarella y albahaca.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo al Curry', 'instrucciones': 'Cocinar pollo con cebolla, ajo, jengibre, tomate y especias.', 'tiempo_preparacion': 35, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ramen', 'instrucciones': 'Hervir fideos, preparar caldo y agregar carne y vegetales.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Falafel', 'instrucciones': 'Mezclar garbanzos, formar bolitas y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Brownies', 'instrucciones': 'Mezclar ingredientes, hornear y cortar en cuadrados.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Lasagna', 'instrucciones': 'Cocinar capas de pasta, carne, salsa de tomate y queso.', 'tiempo_preparacion': 50, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Risotto', 'instrucciones': 'Cocinar arroz con caldo, vino blanco, mantequilla y queso.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chili con Carne', 'instrucciones': 'Cocinar carne con frijoles, tomate y especias.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas', 'instrucciones': 'Preparar la masa, rellenar y hornear o freír.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Goulash', 'instrucciones': 'Cocinar carne con paprika, cebolla, ajo y caldo.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Biryani', 'instrucciones': 'Cocinar arroz con especias, carne y vegetales.', 'tiempo_preparacion': 50, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Moussaka', 'instrucciones': 'Cocinar capas de berenjena, carne y bechamel.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pancakes', 'instrucciones': 'Mezclar ingredientes y cocinar en una sartén caliente.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Hummus', 'instrucciones': 'Mezclar garbanzos, tahini, ajo y jugo de limón.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ceviche', 'instrucciones': 'Marinar pescado con jugo de limón, cebolla y cilantro.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Borscht', 'instrucciones': 'Cocinar remolacha con caldo, carne y vegetales.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pad Thai', 'instrucciones': 'Saltear fideos de arroz con huevo, tofu, camarones y salsa.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Miso Soup', 'instrucciones': 'Cocinar caldo dashi con miso, tofu y algas.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bruschetta', 'instrucciones': 'Tostar pan y cubrir con tomate, ajo, albahaca y aceite de oliva.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Gazpacho', 'instrucciones': 'Mezclar tomate, pepino, pimiento, ajo y vinagre.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tiramisu', 'instrucciones': 'Capa de bizcochos empapados en café y crema de mascarpone.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pho', 'instrucciones': 'Preparar caldo con especias, agregar fideos y carne.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Shakshuka', 'instrucciones': 'Cocinar huevos en salsa de tomate con especias.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Guacamole', 'instrucciones': 'Mezclar aguacate, tomate, cebolla, cilantro y jugo de limón.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ratatouille', 'instrucciones': 'Cocinar capas de vegetales con salsa de tomate.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Baklava', 'instrucciones': 'Capa de masa filo con nueces y miel.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Clam Chowder', 'instrucciones': 'Cocinar almejas con crema, papa y cebolla.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Beef Wellington', 'instrucciones': 'Cocinar filete envuelto en hojaldre con duxelles.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Croissants', 'instrucciones': 'Preparar masa laminada con mantequilla, formar y hornear.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Lobster Roll', 'instrucciones': 'Mezclar langosta con mayonesa y servir en un bollo.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Margarita', 'instrucciones': 'Mezclar tequila, jugo de limón y licor de naranja.', 'tiempo_preparacion': 5, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tom Yum', 'instrucciones': 'Preparar caldo picante con camarones y vegetales.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Peking Duck', 'instrucciones': 'Cocinar pato laqueado y servir con panqueques y salsa.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fish and Chips', 'instrucciones': 'Freír pescado rebozado y servir con papas fritas.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Torta de Chocolate', 'instrucciones': 'Mezclar ingredientes, hornear y decorar.', 'tiempo_preparacion': 60, 'usuario_id': 0});

// Nuevas recetas adicionales
      await db.insert('Recetas', {'nombre': 'Curry Katsu', 'instrucciones': 'Freír cerdo empanizado y servir con curry japonés.', 'tiempo_preparacion': 35, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Gambas al Ajillo', 'instrucciones': 'Cocinar gambas con ajo, aceite de oliva y guindilla.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Shabu Shabu', 'instrucciones': 'Cocinar carne en caldo hirviendo y acompañar con salsas.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bibimbap', 'instrucciones': 'Mezclar arroz con vegetales, carne y huevo frito.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fondue', 'instrucciones': 'Derretir queso y mojar trozos de pan en él.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pierogi', 'instrucciones': 'Rellenar masa con patata y queso, y hervir o freír.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ravioli', 'instrucciones': 'Rellenar pasta con carne o queso y cocinar en salsa.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Jambalaya', 'instrucciones': 'Cocinar arroz con pollo, salchicha y mariscos.', 'tiempo_preparacion': 50, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Cassoulet', 'instrucciones': 'Cocinar alubias con carne y embutidos.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Boeuf Bourguignon', 'instrucciones': 'Cocinar carne en vino tinto con champiñones y cebolla.', 'tiempo_preparacion': 150, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Caponata', 'instrucciones': 'Cocinar berenjena con tomate, apio, aceitunas y alcaparras.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Crème Brûlée', 'instrucciones': 'Hornear crema con azúcar caramelizado en la superficie.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Panna Cotta', 'instrucciones': 'Cocinar crema con gelatina y enfriar hasta que cuaje.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Quiche Lorraine', 'instrucciones': 'Hornear tarta de masa quebrada con huevo, nata y bacon.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Samosas', 'instrucciones': 'Rellenar masa con patatas y guisantes y freír.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tamales', 'instrucciones': 'Cocinar masa de maíz rellena en hojas de maíz.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Gumbo', 'instrucciones': 'Cocinar sopa espesa de mariscos y salchicha con okra.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Rosti', 'instrucciones': 'Rallar patatas y freír hasta que estén doradas.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arepas', 'instrucciones': 'Cocinar masa de maíz y rellenar con queso o carne.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Baozi', 'instrucciones': 'Rellenar masa con carne y cocinar al vapor.', 'tiempo_preparacion': 35, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Maki Sushi', 'instrucciones': 'Enrollar arroz y pescado en alga nori.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tempura', 'instrucciones': 'Freír mariscos y vegetales rebozados.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Katsudon', 'instrucciones': 'Cocinar cerdo empanizado sobre arroz con huevo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Okonomiyaki', 'instrucciones': 'Preparar torta de harina con vegetales y carne.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Takoyaki', 'instrucciones': 'Cocinar bolitas de masa con pulpo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Dango', 'instrucciones': 'Cocinar bolitas de arroz y servir con salsa dulce.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Onigiri', 'instrucciones': 'Formar bolas de arroz con relleno.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Gyoza', 'instrucciones': 'Rellenar masa con carne y vegetales y cocinar al vapor.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mapo Tofu', 'instrucciones': 'Cocinar tofu en salsa picante con carne molida.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Kung Pao Chicken', 'instrucciones': 'Cocinar pollo con maní y vegetales en salsa picante.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Hot Pot', 'instrucciones': 'Cocinar carne y vegetales en caldo hirviendo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bibingka', 'instrucciones': 'Hornear pastel de arroz con coco y queso.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Banh Mi', 'instrucciones': 'Rellenar baguette con carne, vegetales y salsa.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chow Mein', 'instrucciones': 'Saltear fideos con carne y vegetales.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tom Kha Gai', 'instrucciones': 'Cocinar sopa de coco con pollo y especias.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Khao Pad', 'instrucciones': 'Saltear arroz con huevo, vegetales y carne.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Massaman Curry', 'instrucciones': 'Cocinar curry de carne con papas y maní.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Som Tum', 'instrucciones': 'Mezclar ensalada de papaya verde con salsa picante.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Larb', 'instrucciones': 'Mezclar carne picada con hierbas y salsa de pescado.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Rendang', 'instrucciones': 'Cocinar carne en leche de coco y especias hasta que esté tierna.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Nasi Goreng', 'instrucciones': 'Saltear arroz con huevo, vegetales y salsa.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Satay', 'instrucciones': 'Asar brochetas de carne y servir con salsa de maní.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Gado Gado', 'instrucciones': 'Mezclar ensalada de vegetales con salsa de maní.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Babi Pangang', 'instrucciones': 'Asar cerdo marinado y servir con salsa agridulce.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bitterballen', 'instrucciones': 'Freír croquetas de carne holandesas.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Stroopwafels', 'instrucciones': 'Preparar galletas de waffle con jarabe de caramelo.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Poffertjes', 'instrucciones': 'Cocinar mini pancakes holandeses.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sauerbraten', 'instrucciones': 'Marinar carne y cocinar en vino tinto con especias.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pretzel', 'instrucciones': 'Hornear pan en forma de nudo con sal gruesa.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Schnitzel', 'instrucciones': 'Empanizar y freír carne de cerdo o ternera.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bratwurst', 'instrucciones': 'Asar o freír salchichas alemanas.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Kartoffelsalat', 'instrucciones': 'Mezclar ensalada de papas con vinagreta o mayonesa.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tarte Tatin', 'instrucciones': 'Hornear tarta de manzana al revés.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Coq au Vin', 'instrucciones': 'Cocinar pollo en vino tinto con champiñones y tocino.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bouillabaisse', 'instrucciones': 'Cocinar sopa de mariscos con azafrán y hierbas.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Confit de Canard', 'instrucciones': 'Cocinar pato en su propia grasa.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Raclette', 'instrucciones': 'Derretir queso y servir con papas y encurtidos.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fondant de Chocolate', 'instrucciones': 'Hornear pastel de chocolate con centro líquido.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Meringue', 'instrucciones': 'Hornear claras de huevo batidas con azúcar.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tortilla Española', 'instrucciones': 'Cocinar tortilla de papas con cebolla.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Gazpacho Andaluz', 'instrucciones': 'Mezclar sopa fría de tomate con pepino y pimiento.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Churros', 'instrucciones': 'Freír masa y espolvorear con azúcar.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Patatas Bravas', 'instrucciones': 'Freír papas y servir con salsa picante.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pimientos de Padrón', 'instrucciones': 'Freír pimientos pequeños y espolvorear con sal.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Manchego', 'instrucciones': 'Servir queso manchego con aceite de oliva y pan.', 'tiempo_preparacion': 5, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ceviche Peruano', 'instrucciones': 'Marinar pescado en jugo de limón con cebolla y cilantro.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Lomo Saltado', 'instrucciones': 'Saltear carne con cebolla, tomate y papas fritas.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Aji de Gallina', 'instrucciones': 'Cocinar pollo en salsa de ají amarillo y nueces.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Anticuchos', 'instrucciones': 'Asar brochetas de corazón de res.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tacu Tacu', 'instrucciones': 'Freír mezcla de arroz y frijoles con carne.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Suspiro a la Limeña', 'instrucciones': 'Preparar postre de leche condensada y merengue.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Picarones', 'instrucciones': 'Freír buñuelos de camote y zapallo y servir con miel.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Brasa', 'instrucciones': 'Asar pollo marinado con especias.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Causa Limeña', 'instrucciones': 'Preparar puré de papa con ají amarillo y relleno.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Papa a la Huancaína', 'instrucciones': 'Servir papas con salsa de ají amarillo y queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chicharrón', 'instrucciones': 'Freír carne de cerdo con piel crujiente.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tequeños', 'instrucciones': 'Freír masa rellena de queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Asado Negro', 'instrucciones': 'Cocinar carne en salsa de panela y vino.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Hallacas', 'instrucciones': 'Cocinar masa de maíz rellena y envuelta en hojas.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pabellón Criollo', 'instrucciones': 'Servir carne mechada con arroz, frijoles y plátano.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Cachapas', 'instrucciones': 'Cocinar tortas de maíz con queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Golfeados', 'instrucciones': 'Hornear pan dulce con papelón y queso.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Mechada', 'instrucciones': 'Cocinar carne de res desmechada con tomate y cebolla.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arequipe', 'instrucciones': 'Cocinar leche condensada hasta que caramelice.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chupe de Camarones', 'instrucciones': 'Cocinar sopa de camarones con papa, maíz y huevo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Seco de Cordero', 'instrucciones': 'Cocinar cordero en salsa de cilantro y cerveza.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo', 'instrucciones': 'Cocinar arroz con pollo y vegetales en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mote Pillo', 'instrucciones': 'Saltear mote con huevo y cebolla.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fanesca', 'instrucciones': 'Cocinar sopa de granos y bacalao con leche.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Encebollado', 'instrucciones': 'Cocinar pescado con yuca y cebolla en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Llapingachos', 'instrucciones': 'Freír tortas de papa rellenas de queso.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bolón de Verde', 'instrucciones': 'Mezclar plátano verde con queso y formar bolas.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Menestra', 'instrucciones': 'Cocinar arroz con lentejas y carne.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Cuy Asado', 'instrucciones': 'Asar cuy con especias.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Humitas', 'instrucciones': 'Cocinar masa de maíz en hojas de maíz.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Patacones', 'instrucciones': 'Freír rodajas de plátano verde.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sancocho', 'instrucciones': 'Cocinar sopa de carne y tubérculos.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mazamorra', 'instrucciones': 'Cocinar postre de maíz morado y frutas.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz Zambito', 'instrucciones': 'Cocinar arroz con leche, coco y especias.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Juane', 'instrucciones': 'Cocinar arroz con pollo envuelto en hojas.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Cerveza', 'instrucciones': 'Cocinar pollo con cerveza y especias.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa Seca', 'instrucciones': 'Cocinar fideos con carne y especias.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Cebiche de Chochos', 'instrucciones': 'Marinar chochos con jugo de limón, cebolla y cilantro.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz Tapado', 'instrucciones': 'Cocinar arroz con carne y cubrir con huevo frito.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chifles', 'instrucciones': 'Freír rodajas de plátano maduro.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mole Poblano', 'instrucciones': 'Cocinar pollo con salsa de chiles y chocolate.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chilaquiles', 'instrucciones': 'Cocinar totopos con salsa y queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pozole', 'instrucciones': 'Cocinar sopa de maíz con carne y especias.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Cochinita Pibil', 'instrucciones': 'Asar cerdo marinado en achiote.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Enchiladas', 'instrucciones': 'Rellenar tortillas con carne y salsa, y hornear.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tamales Mexicanos', 'instrucciones': 'Cocinar masa de maíz rellena en hojas de maíz.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Quesadillas', 'instrucciones': 'Rellenar tortillas con queso y calentar.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopes', 'instrucciones': 'Freír masa de maíz y rellenar con carne y salsa.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostadas', 'instrucciones': 'Freír tortillas y cubrir con frijoles y carne.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Guacamole Mexicano', 'instrucciones': 'Mezclar aguacate, tomate, cebolla y cilantro.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Flautas', 'instrucciones': 'Rellenar tortillas con carne y freír.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Churros Mexicanos', 'instrucciones': 'Freír masa y espolvorear con azúcar y canela.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pico de Gallo', 'instrucciones': 'Mezclar tomate, cebolla, cilantro y chile.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tamal de Dulce', 'instrucciones': 'Cocinar masa de maíz dulce en hojas de maíz.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Enfrijoladas', 'instrucciones': 'Rellenar tortillas con frijoles y queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Tortilla', 'instrucciones': 'Cocinar sopa de tomate con tortillas fritas.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones a la Diabla', 'instrucciones': 'Cocinar camarones en salsa picante.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Mole', 'instrucciones': 'Rellenar masa con mole y freír.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pan de Muerto', 'instrucciones': 'Hornear pan dulce con azúcar y anís.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones', 'instrucciones': 'Freír rodajas de plátano verde dos veces.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bandeja Paisa', 'instrucciones': 'Servir frijoles, arroz, carne y huevo en un plato.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ajiaco', 'instrucciones': 'Cocinar sopa de pollo con papas y mazorca.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Lechona', 'instrucciones': 'Cocinar cerdo relleno de arroz y guisantes.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arepa de Huevo', 'instrucciones': 'Freír masa de maíz rellena de huevo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sancocho Colombiano', 'instrucciones': 'Cocinar sopa de carne y tubérculos.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Buñuelos Colombianos', 'instrucciones': 'Freír masa de queso y maíz.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pandebono', 'instrucciones': 'Hornear pan de queso.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Natilla Colombiana', 'instrucciones': 'Cocinar postre de maíz y leche.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Obleas', 'instrucciones': 'Rellenar obleas con arequipe.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Caracol', 'instrucciones': 'Cocinar sopa de caracol con coco y especias.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo con Tajadas', 'instrucciones': 'Cocinar pollo frito con plátano maduro.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Chicharrón', 'instrucciones': 'Servir yuca frita con chicharrón.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Nacatamales', 'instrucciones': 'Cocinar masa de maíz rellena en hojas de plátano.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Baleadas', 'instrucciones': 'Rellenar tortillas con frijoles y queso.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tapado', 'instrucciones': 'Cocinar sopa de carne y mariscos con coco.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ensalada de Coditos', 'instrucciones': 'Mezclar pasta con mayonesa, jamón y vegetales.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Platano', 'instrucciones': 'Rellenar masa de plátano con frijoles y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chicharrón con Yuca', 'instrucciones': 'Servir chicharrón con yuca frita y ensalada.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Rellenitos de Platano', 'instrucciones': 'Rellenar plátano con frijoles y freír.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chalupas', 'instrucciones': 'Rellenar tortillas con carne y salsa.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ensalada Rusa', 'instrucciones': 'Mezclar papa, zanahoria, guisantes y mayonesa.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tamales de Elote', 'instrucciones': 'Cocinar masa de maíz dulce en hojas de elote.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Quesadillas de Queso', 'instrucciones': 'Rellenar tortillas con queso y calentar.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Jocon', 'instrucciones': 'Cocinar pollo en salsa de tomate y tomatillo.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Hilachas', 'instrucciones': 'Cocinar carne desmenuzada en salsa de tomate.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ensalada de Papa', 'instrucciones': 'Mezclar papa con mayonesa, huevo y mostaza.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tajadas con Queso', 'instrucciones': 'Servir plátano frito con queso.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Vigoron', 'instrucciones': 'Servir yuca con chicharrón y ensalada de repollo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Ajo', 'instrucciones': 'Freír rodajas de plátano verde y servir con ajo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chocobanano', 'instrucciones': 'Cubrir plátano con chocolate y congelar.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Gallo Pinto', 'instrucciones': 'Mezclar arroz con frijoles y especias.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Picadillo de Papaya', 'instrucciones': 'Cocinar papaya verde con carne y especias.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Casado', 'instrucciones': 'Servir arroz, frijoles, plátano y carne en un plato.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Olla de Carne', 'instrucciones': 'Cocinar sopa de carne y vegetales.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ceviche Tico', 'instrucciones': 'Marinar pescado en jugo de limón con cebolla y cilantro.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tres Leches', 'instrucciones': 'Hornear pastel y remojar en mezcla de tres leches.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Flan de Coco', 'instrucciones': 'Cocinar flan de coco y caramelo.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa Negra', 'instrucciones': 'Cocinar sopa de frijoles negros con huevo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Leche', 'instrucciones': 'Cocinar arroz en leche con canela y azúcar.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Rondon', 'instrucciones': 'Cocinar sopa de mariscos con coco y plátano.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Cazuela de Mariscos', 'instrucciones': 'Cocinar mariscos con papas y zanahorias en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fritanga', 'instrucciones': 'Freír carne y tubérculos y servir con ensalada.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada', 'instrucciones': 'Asar carne con especias.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bistec a Caballo', 'instrucciones': 'Servir bistec con huevo frito y salsa criolla.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chifrijo', 'instrucciones': 'Servir frijoles con chicharrón y pico de gallo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca en Mojo', 'instrucciones': 'Cocinar yuca con ajo y limón.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo Costarricense', 'instrucciones': 'Cocinar arroz con pollo y vegetales en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Mariscos', 'instrucciones': 'Cocinar mariscos con vegetales en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Vigoron Costarricense', 'instrucciones': 'Servir yuca con chicharrón y ensalada de repollo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tamal de Arroz', 'instrucciones': 'Cocinar masa de arroz en hojas de plátano.', 'tiempo_preparacion': 120, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chorreadas', 'instrucciones': 'Cocinar tortas de maíz dulce.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ensalada de Palmito', 'instrucciones': 'Mezclar palmito con tomate, aguacate y lechuga.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Mondongo', 'instrucciones': 'Cocinar sopa de callos con vegetales.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Patacones Costarricenses', 'instrucciones': 'Freír rodajas de plátano verde dos veces.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pescado a la Parrilla', 'instrucciones': 'Asar pescado con limón y hierbas.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Picadillo de Chayote', 'instrucciones': 'Cocinar chayote con carne y especias.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Atún', 'instrucciones': 'Rellenar masa con atún y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chayotes Rellenos', 'instrucciones': 'Rellenar chayotes con carne y hornear.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Calamares', 'instrucciones': 'Cocinar arroz con calamares y especias.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pan de Elote', 'instrucciones': 'Hornear pan de maíz dulce.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Gallo Pinto Costarricense', 'instrucciones': 'Mezclar arroz con frijoles y especias.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bocas', 'instrucciones': 'Servir pequeños bocados de comida.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tamal Asado', 'instrucciones': 'Cocinar masa de maíz en hojas de plátano.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Frito', 'instrucciones': 'Freír queso hasta que esté dorado.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Gandules', 'instrucciones': 'Cocinar arroz con guisantes y cerdo.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Guisado', 'instrucciones': 'Cocinar pollo con tomate, ajo y especias.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo', 'instrucciones': 'Mezclar plátano verde con chicharrón y ajo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pastelón', 'instrucciones': 'Cocinar lasaña de plátano maduro con carne.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Quesitos', 'instrucciones': 'Hornear masa de hojaldre rellena de queso crema.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Flan de Vainilla', 'instrucciones': 'Cocinar flan de huevo y caramelo.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones Boricuas', 'instrucciones': 'Freír rodajas de plátano verde dos veces.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Criolla', 'instrucciones': 'Cocinar pollo con salsa de tomate y pimientos.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz Mamposteao', 'instrucciones': 'Mezclar arroz con frijoles y carne.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Cazuela de Pollo', 'instrucciones': 'Cocinar pollo con papas y zanahorias en caldo.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sorullitos de Maíz', 'instrucciones': 'Freír masa de maíz y queso.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Chicharrón de Pollo', 'instrucciones': 'Freír pollo empanizado hasta que esté dorado.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo en Fricasé', 'instrucciones': 'Cocinar pollo con salsa de vino y tomate.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Dulce', 'instrucciones': 'Cocinar arroz en leche de coco con especias.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Piñonates', 'instrucciones': 'Freír masa de harina y miel.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bacalaítos', 'instrucciones': 'Freír masa de bacalao y harina.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Lechón Asado', 'instrucciones': 'Asar cerdo entero con especias.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Alcapurrias', 'instrucciones': 'Rellenar masa de yuca con carne y freír.', 'tiempo_preparacion': 40, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Mechada Boricua', 'instrucciones': 'Cocinar carne desmechada con tomate y cebolla.', 'tiempo_preparacion': 90, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Ensalada de Pulpo', 'instrucciones': 'Mezclar pulpo con vegetales y vinagreta.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Masa de Puerco', 'instrucciones': 'Freír carne de cerdo hasta que esté dorada.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Piononos', 'instrucciones': 'Rellenar plátano maduro con carne y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo al Horno', 'instrucciones': 'Asar pollo con especias y limón.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Piña', 'instrucciones': 'Hornear pastel de piña y caramelo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones al Ajillo', 'instrucciones': 'Cocinar camarones con ajo y aceite de oliva.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pollo', 'instrucciones': 'Cocinar pollo con vegetales en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Mojo', 'instrucciones': 'Servir yuca con salsa de ajo y limón.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadillas', 'instrucciones': 'Rellenar masa con carne y freír.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Frito con Guayaba', 'instrucciones': 'Freír queso y servir con salsa de guayaba.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcillas', 'instrucciones': 'Asar morcillas hasta que estén crujientes.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil Asado', 'instrucciones': 'Asar pierna de cerdo con especias.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito', 'instrucciones': 'Freír pollo empanizado hasta que esté dorado.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Frita', 'instrucciones': 'Freír carne hasta que esté crujiente.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Pollo', 'instrucciones': 'Cocinar pollo con salsa de vino y tomate.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Gandules', 'instrucciones': 'Cocinar arroz con guisantes y cerdo.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Tres Leches', 'instrucciones': 'Hornear pastel y remojar en mezcla de tres leches.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones de Pana', 'instrucciones': 'Freír rodajas de pana dos veces.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo de Yuca', 'instrucciones': 'Mezclar yuca con chicharrón y ajo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Parilla', 'instrucciones': 'Asar pollo con especias.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Calabaza', 'instrucciones': 'Hornear pastel de calabaza con especias.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones Empanizados', 'instrucciones': 'Freír camarones empanizados.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pescado', 'instrucciones': 'Cocinar pescado con vegetales en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca Frita', 'instrucciones': 'Freír yuca hasta que esté dorada.', 'tiempo_preparacion': 15, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Queso', 'instrucciones': 'Rellenar masa con queso y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fundido', 'instrucciones': 'Derretir queso y servir con tortillas.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla Asada', 'instrucciones': 'Asar morcillas hasta que estén crujientes.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil al Horno', 'instrucciones': 'Asar pierna de cerdo con especias.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito Picante', 'instrucciones': 'Freír pollo empanizado picante hasta que esté dorado.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Chimichurri', 'instrucciones': 'Asar carne y servir con chimichurri.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Cerdo', 'instrucciones': 'Cocinar cerdo con salsa de vino y tomate.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo Boricua', 'instrucciones': 'Cocinar arroz con pollo y vegetales en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Naranja', 'instrucciones': 'Hornear pastel de naranja.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Mojo', 'instrucciones': 'Freír rodajas de plátano verde y servir con mojo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Caldo', 'instrucciones': 'Mezclar plátano verde con chicharrón y servir con caldo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Plancha', 'instrucciones': 'Cocinar pollo a la plancha con especias.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Limón', 'instrucciones': 'Hornear pastel de limón con glaseado.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones al Coco', 'instrucciones': 'Freír camarones empanizados en coco.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Cangrejo', 'instrucciones': 'Cocinar cangrejo con vegetales en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Queso', 'instrucciones': 'Servir yuca con queso derretido.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Carne', 'instrucciones': 'Rellenar masa con carne y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fresco', 'instrucciones': 'Servir queso fresco con miel.', 'tiempo_preparacion': 5, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Arroz', 'instrucciones': 'Cocinar morcillas con arroz.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil en Adobo', 'instrucciones': 'Asar pierna de cerdo en adobo.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito con Ajo', 'instrucciones': 'Freír pollo empanizado con ajo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Salsa Verde', 'instrucciones': 'Asar carne y servir con salsa verde.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Pollo con Papas', 'instrucciones': 'Cocinar pollo con salsa de vino, tomate y papas.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo y Vegetales', 'instrucciones': 'Cocinar arroz con pollo y vegetales en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Almendra', 'instrucciones': 'Hornear pastel de almendra.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Salsa de Queso', 'instrucciones': 'Freír rodajas de plátano verde y servir con salsa de queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Camarones', 'instrucciones': 'Mezclar plátano verde con chicharrón y camarones.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Brasa con Limón', 'instrucciones': 'Asar pollo con especias y limón.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Zanahoria', 'instrucciones': 'Hornear pastel de zanahoria con glaseado.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones en Salsa de Ajo', 'instrucciones': 'Cocinar camarones en salsa de ajo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pollo con Fideos', 'instrucciones': 'Cocinar pollo con fideos y vegetales en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Chicharrón y Mojo', 'instrucciones': 'Servir yuca con chicharrón y salsa de ajo y limón.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Frutas', 'instrucciones': 'Rellenar masa con frutas y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Derretido', 'instrucciones': 'Derretir queso y servir con pan.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Manzana', 'instrucciones': 'Cocinar morcillas con manzana.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil en Cerveza', 'instrucciones': 'Asar pierna de cerdo en cerveza.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito con Limón', 'instrucciones': 'Freír pollo empanizado con limón.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Salsa de Champiñones', 'instrucciones': 'Asar carne y servir con salsa de champiñones.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Pollo con Verduras', 'instrucciones': 'Cocinar pollo con salsa de vino, tomate y verduras.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo y Chorizo', 'instrucciones': 'Cocinar arroz con pollo y chorizo en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Nueces', 'instrucciones': 'Hornear pastel de nueces.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Carne', 'instrucciones': 'Freír rodajas de plátano verde y servir con carne.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Pollo', 'instrucciones': 'Mezclar plátano verde con chicharrón y pollo.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Plancha con Ajo', 'instrucciones': 'Cocinar pollo a la plancha con ajo y especias.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Manzana', 'instrucciones': 'Hornear pastel de manzana con canela.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones al Limón', 'instrucciones': 'Cocinar camarones en salsa de limón.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pollo con Arroz', 'instrucciones': 'Cocinar pollo con arroz y vegetales en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Mantequilla', 'instrucciones': 'Servir yuca con mantequilla derretida.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Pollo', 'instrucciones': 'Rellenar masa con pollo y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fundido con Chorizo', 'instrucciones': 'Derretir queso con chorizo y servir con tortillas.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Cebolla', 'instrucciones': 'Cocinar morcillas con cebolla.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil en Salsa de Piña', 'instrucciones': 'Asar pierna de cerdo en salsa de piña.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito con Miel', 'instrucciones': 'Freír pollo empanizado con miel.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Salsa de Ajo', 'instrucciones': 'Asar carne y servir con salsa de ajo.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Pollo con Champiñones', 'instrucciones': 'Cocinar pollo con salsa de vino, tomate y champiñones.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo y Vegetales Frescos', 'instrucciones': 'Cocinar arroz con pollo y vegetales frescos en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Chocolate con Nueces', 'instrucciones': 'Hornear pastel de chocolate con nueces.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Pollo', 'instrucciones': 'Freír rodajas de plátano verde y servir con pollo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Queso', 'instrucciones': 'Mezclar plátano verde con chicharrón y queso.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Parrilla con Limón y Ajo', 'instrucciones': 'Asar pollo con especias, limón y ajo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Café', 'instrucciones': 'Hornear pastel de café con glaseado.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones a la Parrilla', 'instrucciones': 'Asar camarones con especias y limón.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pollo con Verduras', 'instrucciones': 'Cocinar pollo con verduras en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Salsa de Ajo', 'instrucciones': 'Servir yuca con salsa de ajo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Verduras', 'instrucciones': 'Rellenar masa con verduras y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fundido con Chiles', 'instrucciones': 'Derretir queso con chiles y servir con tortillas.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Tomate', 'instrucciones': 'Cocinar morcillas con tomate.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil en Salsa de Naranja', 'instrucciones': 'Asar pierna de cerdo en salsa de naranja.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito con Salsa Picante', 'instrucciones': 'Freír pollo empanizado con salsa picante.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Salsa de Tomate', 'instrucciones': 'Asar carne y servir con salsa de tomate.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Pollo con Papas y Verduras', 'instrucciones': 'Cocinar pollo con salsa de vino, tomate, papas y verduras.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo y Mariscos', 'instrucciones': 'Cocinar arroz con pollo y mariscos en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Zanahoria y Nueces', 'instrucciones': 'Hornear pastel de zanahoria con nueces.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Salsa de Queso y Pollo', 'instrucciones': 'Freír rodajas de plátano verde y servir con salsa de queso y pollo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Mariscos', 'instrucciones': 'Mezclar plátano verde con chicharrón y mariscos.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Plancha con Limón y Ajo', 'instrucciones': 'Cocinar pollo a la plancha con limón y ajo.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Almendra y Limón', 'instrucciones': 'Hornear pastel de almendra y limón.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones al Ajo y Limón', 'instrucciones': 'Cocinar camarones en salsa de ajo y limón.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pollo con Pasta', 'instrucciones': 'Cocinar pollo con pasta y vegetales en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Salsa de Cilantro', 'instrucciones': 'Servir yuca con salsa de cilantro.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Pescado', 'instrucciones': 'Rellenar masa con pescado y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fundido con Champiñones', 'instrucciones': 'Derretir queso con champiñones y servir con tortillas.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Papas', 'instrucciones': 'Cocinar morcillas con papas.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil en Salsa de Miel', 'instrucciones': 'Asar pierna de cerdo en salsa de miel.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito con Salsa de Mostaza', 'instrucciones': 'Freír pollo empanizado con salsa de mostaza.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Salsa de Pimienta', 'instrucciones': 'Asar carne y servir con salsa de pimienta.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Pollo con Papas y Champiñones', 'instrucciones': 'Cocinar pollo con salsa de vino, tomate, papas y champiñones.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo y Verduras al Horno', 'instrucciones': 'Cocinar arroz con pollo y verduras al horno.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Nueces y Miel', 'instrucciones': 'Hornear pastel de nueces y miel.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Carne y Salsa de Queso', 'instrucciones': 'Freír rodajas de plátano verde y servir con carne y salsa de queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Carne y Chicharrón', 'instrucciones': 'Mezclar plátano verde con carne y chicharrón.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Brasa con Especias', 'instrucciones': 'Asar pollo con especias.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Chocolate y Naranja', 'instrucciones': 'Hornear pastel de chocolate y naranja.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones a la Parrilla con Limón', 'instrucciones': 'Asar camarones con limón.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pollo con Verduras y Fideos', 'instrucciones': 'Cocinar pollo con verduras y fideos en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Salsa de Queso', 'instrucciones': 'Servir yuca con salsa de queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Mariscos', 'instrucciones': 'Rellenar masa con mariscos y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fundido con Especias', 'instrucciones': 'Derretir queso con especias y servir con tortillas.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Hierbas', 'instrucciones': 'Cocinar morcillas con hierbas.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil en Salsa de Mango', 'instrucciones': 'Asar pierna de cerdo en salsa de mango.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito con Salsa de Tomate', 'instrucciones': 'Freír pollo empanizado con salsa de tomate.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Salsa de Queso', 'instrucciones': 'Asar carne y servir con salsa de queso.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo y Verduras Picantes', 'instrucciones': 'Cocinar arroz con pollo y verduras picantes en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Chocolate y Café', 'instrucciones': 'Hornear pastel de chocolate y café.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Camarones', 'instrucciones': 'Freír rodajas de plátano verde y servir con camarones.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Carne y Queso', 'instrucciones': 'Mezclar plátano verde con carne y queso.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Brasa con Miel', 'instrucciones': 'Asar pollo con especias y miel.', 'tiempo_preparacion': 60, 'usuario_id': 0});
        await db.insert('Recetas', {'nombre': 'Pollo a la Brasa con Salsa de Limón', 'instrucciones': 'Asar pollo con especias y salsa de limón.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Almendra y Miel', 'instrucciones': 'Hornear pastel de almendra y miel.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones al Ajo y Limón con Verduras', 'instrucciones': 'Cocinar camarones en salsa de ajo y limón y servir con verduras.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pollo con Verduras y Pasta', 'instrucciones': 'Cocinar pollo con verduras y pasta en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Salsa de Ajo y Limón', 'instrucciones': 'Servir yuca con salsa de ajo y limón.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Carne y Verduras', 'instrucciones': 'Rellenar masa con carne y verduras y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fundido con Salsa de Tomate', 'instrucciones': 'Derretir queso con salsa de tomate y servir con tortillas.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Verduras', 'instrucciones': 'Cocinar morcillas con verduras.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil en Salsa de Cerveza', 'instrucciones': 'Asar pierna de cerdo en salsa de cerveza.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito con Salsa de Barbacoa', 'instrucciones': 'Freír pollo empanizado con salsa de barbacoa.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Salsa de Ajo y Limón', 'instrucciones': 'Asar carne y servir con salsa de ajo y limón.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Pollo con Papas y Verduras Frescas', 'instrucciones': 'Cocinar pollo con salsa de vino, tomate, papas y verduras frescas.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo y Mariscos al Horno', 'instrucciones': 'Cocinar arroz con pollo y mariscos al horno.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Chocolate y Miel', 'instrucciones': 'Hornear pastel de chocolate y miel.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Salsa de Queso y Camarones', 'instrucciones': 'Freír rodajas de plátano verde y servir con salsa de queso y camarones.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Pollo y Queso', 'instrucciones': 'Mezclar plátano verde con pollo y queso.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Brasa con Salsa de Hierbas', 'instrucciones': 'Asar pollo con especias y salsa de hierbas.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Limón y Miel', 'instrucciones': 'Hornear pastel de limón y miel.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Camarones al Ajo y Limón con Hierbas', 'instrucciones': 'Cocinar camarones en salsa de ajo y limón y servir con hierbas.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Sopa de Pollo con Verduras y Quinoa', 'instrucciones': 'Cocinar pollo con verduras y quinoa en caldo.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Salsa de Tomate y Queso', 'instrucciones': 'Servir yuca con salsa de tomate y queso.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Pescado y Verduras', 'instrucciones': 'Rellenar masa con pescado y verduras y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fundido con Salsa de Ajo', 'instrucciones': 'Derretir queso con salsa de ajo y servir con tortillas.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Hierbas y Verduras', 'instrucciones': 'Cocinar morcillas con hierbas y verduras.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pernil en Salsa de Limón', 'instrucciones': 'Asar pierna de cerdo en salsa de limón.', 'tiempo_preparacion': 180, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo Frito con Salsa de Limón y Miel', 'instrucciones': 'Freír pollo empanizado con salsa de limón y miel.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Carne Asada con Salsa de Tomate y Queso', 'instrucciones': 'Asar carne y servir con salsa de tomate y queso.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Fricase de Pollo con Papas, Verduras y Hierbas', 'instrucciones': 'Cocinar pollo con salsa de vino, tomate, papas, verduras y hierbas.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Arroz con Pollo, Verduras y Mariscos', 'instrucciones': 'Cocinar arroz con pollo, verduras y mariscos en salsa.', 'tiempo_preparacion': 45, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Bizcocho de Zanahoria, Nuez y Miel', 'instrucciones': 'Hornear pastel de zanahoria, nuez y miel.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Tostones con Pollo y Salsa de Tomate', 'instrucciones': 'Freír rodajas de plátano verde y servir con pollo y salsa de tomate.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Mofongo con Chicharrón y Salsa de Queso', 'instrucciones': 'Mezclar plátano verde con chicharrón y salsa de queso.', 'tiempo_preparacion': 30, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Pollo a la Brasa con Salsa de Mango', 'instrucciones': 'Asar pollo con especias y salsa de mango.', 'tiempo_preparacion': 60, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Yuca con Salsa de Queso y Limón', 'instrucciones': 'Servir yuca con salsa de queso y limón.', 'tiempo_preparacion': 20, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Empanadas de Carne, Verduras y Salsa de Tomate', 'instrucciones': 'Rellenar masa con carne, verduras y salsa de tomate y freír.', 'tiempo_preparacion': 25, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Queso Fundido con Salsa de Ajo y Hierbas', 'instrucciones': 'Derretir queso con salsa de ajo y hierbas y servir con tortillas.', 'tiempo_preparacion': 10, 'usuario_id': 0});
      await db.insert('Recetas', {'nombre': 'Morcilla con Verduras y Salsa de Tomate', 'instrucciones': 'Cocinar morcillas con verduras y salsa de tomate.', 'tiempo_preparacion': 25, 'usuario_id': 0});

    } catch (e) {
      print("Error al crear las tablas: $e");
      rethrow;
    }
  }

  // Método para cerrar la base de datos
  static Future<void> close() async {
    if (_database != null) {
      try {
        await _database!.close();
        _database = null;
        print("Base de datos cerrada");
      } catch (e) {
        print("Error al cerrar la base de datos: $e");
      }
    }
  }
}
