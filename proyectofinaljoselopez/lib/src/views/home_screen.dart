import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'recipes_screen.dart';
import 'tips_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId; // Identificador del usuario

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice de la página seleccionada inicialmente

  late List<Widget> _pages; // Lista de páginas que se mostrarán en la navegación inferior

  @override
  void initState() {
    super.initState();
    // Inicializa la lista de páginas con los widgets correspondientes
    _pages = [
      HomePage(),
      InventoryScreen(userId: widget.userId),
      RecipesScreen(userId: widget.userId),
      TipsScreen(userId: widget.userId),
    ];
  }

  // Método para manejar el cambio de página en la navegación inferior
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Muestra la página seleccionada
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Tipo de barra de navegación
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icono de la primera opción
            label: 'Inicio', // Etiqueta de la primera opción
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory), // Icono de la segunda opción
            label: 'Inventario', // Etiqueta de la segunda opción
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // Icono de la tercera opción
            label: 'Recetas', // Etiqueta de la tercera opción
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb), // Icono de la cuarta opción
            label: 'Consejos', // Etiqueta de la cuarta opción
          ),
        ],
        currentIndex: _selectedIndex, // Índice de la opción seleccionada actualmente
        selectedItemColor: Colors.green, // Color del icono y texto seleccionados
        unselectedItemColor: Colors.grey, // Color del icono y texto no seleccionados
        onTap: _onItemTapped, // Maneja el evento de tocar una opción
        backgroundColor: Colors.white, // Color de fondo de la barra de navegación
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> nombres = ['Francisco', 'Ramón', 'Carlos']; // Lista de nombres para los testimonios
  final List<String> apellidos = ['Gómez', 'López', 'Martínez']; // Lista de apellidos para los testimonios

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido horizontalmente
          children: [
            Text(
              'Desperdicio Cero',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10), // Espacio horizontal
            Image.asset(
              'lib/assets/logo.png', // Ruta de la imagen del logo
              height: 40, // Altura de la imagen
            ),
          ],
        ),
        centerTitle: true, // Centra el título
        automaticallyImplyLeading: false, // No muestra el botón de regreso
      ),
      body: SingleChildScrollView( // Permite el desplazamiento vertical
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido al inicio horizontalmente
            children: [
              ExpansionTile(
                title: Text(
                  'Sobre Nosotros',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    color: Colors.grey[200], // Color de fondo personalizado
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Nuestra aplicación aborda el desperdicio de alimentos en los hogares mediante la integración de tecnología y gestión alimentaria. Ayuda a los usuarios a planificar sus comidas y a manejar eficientemente los alimentos almacenados, ofreciendo recetas basadas en ingredientes disponibles y consejos de conservación. Esto permite reducir el desperdicio, ahorrar costos y promover un estilo de vida sostenible. Las funcionalidades clave incluyen la gestión del inventario de alimentos, la generación de recetas, recomendaciones de conservación y alertas de vencimiento.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20), // Espacio vertical
                  Container(
                    height: 200,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal, // Dirección de desplazamiento horizontal
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // Número de elementos en cada fila
                        mainAxisSpacing: 10, // Espacio entre los elementos
                      ),
                      itemCount: 5, // Número de elementos en el GridView
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15), // Bordes redondeados
                          child: Image.asset(
                            'lib/assets/basura${index + 1}.jpg', // Ruta de la imagen
                            fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Espacio vertical
              ExpansionTile(
                title: Text(
                  'Estadísticas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    color: Colors.grey[200], // Color de fondo personalizado
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Se estima que 1.052 millones de toneladas de alimentos acabaron en los contenedores de basura de hogares, minoristas, restaurantes y otros servicios alimentarios de todo el mundo en 2022, según el Índice de desperdicio de alimentos 2024, publicado por el Programa de las Naciones Unidas para el Medio Ambiente (PNUMA).',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20), // Espacio vertical
                  Container(
                    width: double.infinity, // Ancho completo del contenedor
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25), // Bordes redondeados
                      child: Image.asset(
                        'lib/assets/estadisticadecomidatirada.jpeg', // Ruta de la imagen
                        fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Espacio vertical
              ExpansionTile(
                title: Text(
                  'Importancia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    color: Colors.grey[200], // Color de fondo personalizado
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Aprovechar al máximo la comida es esencial para cuidar el planeta. Cada vez que desperdiciamos alimentos, desperdiciamos recursos naturales y contribuimos al cambio climático. Al planificar nuestras compras, almacenar adecuadamente los alimentos y consumir lo que tenemos, podemos reducir el desperdicio y preservar los recursos para las futuras generaciones. Juntos, podemos marcar la diferencia en la lucha contra el desperdicio de alimentos y en la protección del medio ambiente.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20), // Espacio vertical
                  Container(
                    width: double.infinity, // Ancho completo del contenedor
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25), // Bordes redondeados
                      child: Image.asset(
                        'lib/assets/comidacorrecta.jpg', // Ruta de la imagen
                        fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Espacio vertical
              ExpansionTile(
                title: Text(
                  'Testimonios',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  for (int i = 0; i < 3; i++) // Itera para crear los testimonios
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('lib/assets/perfil_usuario_$i.jpg'), // Imagen del avatar
                        radius: 30, // Radio del avatar
                      ),
                      title: Text(
                        '${nombres[i]} ${apellidos[i]}', // Nombre y apellido del usuario
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        i == 0
                            ? '¡Esta aplicación ha revolucionado mi forma de cocinar! Ahora puedo planificar mis comidas con anticipación, aprovechando al máximo los ingredientes que'
                            : i == 1
                            ? 'Me encanta cómo esta aplicación simplifica la gestión de mi despensa. ¡Es una herramienta indispensable para cualquier persona que quiera cocinar de manera más eficiente y reducir el desperdicio!'
                            : '¡Una aplicación increíblemente útil para cualquier persona que quiera llevar un estilo de vida más sostenible! No solo me ayuda a reducir el desperdicio de alimentos al sugerir recetas basadas en lo que ya tengo en casa, sino que también me brinda consejos prácticos sobre cómo almacenar adecuadamente los alimentos para prolongar su vida útil.',
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20), // Espacio vertical
              Container(
                width: double.infinity, // Ancho completo del contenedor
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25), // Bordes redondeados
                  child: Image.asset(
                    'lib/assets/saludable.jpg', // Ruta de la imagen
                    fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio vertical
              Center(
                child: Column(
                  children: [
                    Text(
                      'Gracias por contribuir',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'en hacer el planeta',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'un lugar mejor',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
