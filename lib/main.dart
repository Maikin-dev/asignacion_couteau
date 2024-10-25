import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drawer Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Índice para cambiar entre las diferentes pantallas
  int _selectedIndex = 0;

  // Lista de las páginas
  final List<Widget> _pages = [
    HomePage(),
    Page1(),
    Page2(),
    Page3(),
    Page4(),
    Page5(),
    Page6(),
  ];

  // Función para cambiar de página cuando el usuario selecciona un ítem del Drawer
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Cierra el Drawer automáticamente después de seleccionar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplicación Couteau'),
      ),
      body: _pages[_selectedIndex], // Muestra la página seleccionada
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(BootstrapIcons.house_door_fill),
              title: Text('Home'),
              onTap: () => _onItemTapped(0), // Página de inicio
            ),
            ListTile(
              leading: Icon(BootstrapIcons.gender_ambiguous),
              title: Text('Predicción de Género'),
              onTap: () => _onItemTapped(1), // Ventana 1
            ),
            ListTile(
              leading: Icon(BootstrapIcons.percent),
              title: Text('Predicción de Edad'),
              onTap: () => _onItemTapped(2), // Ventana 2
            ),
            ListTile(
              leading: Icon(BootstrapIcons.book_half),
              title: Text('Universidad'),
              onTap: () => _onItemTapped(3), // Ventana 3
            ),
            ListTile(
              leading: Icon(BootstrapIcons.cloud_sun_fill),
              title: Text('Clima'),
              onTap: () => _onItemTapped(4), // Ventana 4
            ),
            ListTile(
              leading: Icon(BootstrapIcons.wordpress),
              title: Text('WordPress'),
              onTap: () => _onItemTapped(5), // Ventana 5
            ),
            ListTile(
              leading: Icon(BootstrapIcons.person_lines_fill),
              title: Text('Contacto'),
              onTap: () => _onItemTapped(6), // Ventana 6
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de inicio (Home)
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image.asset(
            'assets/Navajasuiza.webp', // Ruta de tu imagen en los assets
            fit: BoxFit.cover,    // Ajusta la imagen para que cubra toda la pantalla
          ),
        ),
      ],
    );
  }
}

// Otras páginas
class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  String _genderPrediction = 'Cargando...'; // Variable para almacenar el resultado
  Color _backgroundColor = Colors.white; // Color de fondo inicial
  final TextEditingController _nameController = TextEditingController(); // Controlador para el TextField

  @override
  void initState() {
    super.initState();
  }

  // Función para obtener datos de la API
  Future<void> _fetchGenderPrediction(String name) async {
    final response = await http.get(Uri.parse('https://api.genderize.io/?name=$name')); // Cambia esta URL según tu API

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _genderPrediction = data['gender']; // Suponiendo que el API retorna un campo 'gender'
        // Cambiar el color de fondo según el género
        if (_genderPrediction == 'female') {
          _backgroundColor = Colors.pink;
        } else if (_genderPrediction == 'male') {
          _backgroundColor = Colors.blue;
        } else {
          _backgroundColor = Colors.white; // Color por defecto si no es masculino ni femenino
        }
      });
    } else {
      setState(() {
        _genderPrediction = 'Error al obtener datos';
        _backgroundColor = Colors.white; // Restablecer el color de fondo en caso de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor, // Usar el color de fondo actualizado
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Introduce tu nombre',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Llamar a la función para obtener la predicción de género
              _fetchGenderPrediction(_nameController.text);
            },
            child: Text('Predecir Género'),
          ),
          SizedBox(height: 20),
          Text(
            _genderPrediction,
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}



class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  String _ageMessage = '';
  String _ageImage = ''; 
  int _age = 0; 
  final TextEditingController _nameController = TextEditingController(); 

  Future<void> _fetchAgePrediction(String name) async {
    final response = await http.get(Uri.parse('https://api.agify.io/?name=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _age = data['age']; 
        if (_age < 30) {
          _ageMessage = 'Eres joven';
          _ageImage = 'assets/chico_joven.png'; 
        } else if (_age < 65) {
          _ageMessage = 'Eres adulto';
          _ageImage = 'assets/adulto.png'; 
        } else {
          _ageMessage = 'Eres anciano';
          _ageImage = 'assets/anciano.png'; 
        }
      });
    } else {
      setState(() {
        _ageMessage = 'Error al obtener datos';
        _ageImage = ''; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Introduce tu nombre',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _fetchAgePrediction(_nameController.text);
            },
            child: Text('Predecir Edad'),
          ),
          SizedBox(height: 20),
          Text(
            _ageMessage,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          if (_age > 0) ...[
            Text(
              'Edad: $_age años',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Image.asset(
              _ageImage,
              width: 150, 
            ),
          ],
        ],
      ),
    );
  }
}


class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final TextEditingController _countryController = TextEditingController(); // Controlador para el TextField
  List<dynamic> _universities = []; // Lista para almacenar universidades
  String _errorMessage = ''; // Mensaje de error

  Future<void> _fetchUniversities(String country) async {
    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$country'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _universities = data; // Almacenar universidades en la lista
        _errorMessage = ''; // Limpiar mensaje de error
      });
    } else {
      setState(() {
        _universities = []; // Limpiar universidades en caso de error
        _errorMessage = 'Error al obtener universidades'; // Mensaje de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _countryController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Introduce el nombre del país (en inglés)',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Llamar a la función para obtener universidades
              _fetchUniversities(_countryController.text);
            },
            child: Text('Buscar Universidades'),
          ),
          SizedBox(height: 20),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _universities.length,
              itemBuilder: (context, index) {
                final university = _universities[index];
                return ListTile(
                  title: Text(university['name'] ?? 'Nombre no disponible'),
                  subtitle: Text(university['domain'] != null ? university['domain'].join(', ') : 'Dominio no disponible'),
                  trailing: IconButton(
                    icon: Icon(Icons.open_in_new),
                    onPressed: () {
                      if (university['website'] != null && university['website'].isNotEmpty) {
                        launchUrl(university['website'][0]); // Abre la página web en el navegador
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  String _weatherInfo = 'Cargando...';
  String _apiKey = '216522714e24a260246178d65c11bc04'; 

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=Dominican Republic&appid=$_apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temperature = data['main']['temp'];
      final description = data['weather'][0]['description'];

      setState(() {
        _weatherInfo = 'Temperatura: $temperature °C\nDescripción: $description';
      });
    } else {
      setState(() {
        _weatherInfo = 'Error al obtener el clima';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima en RD'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.teal[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wb_sunny, 
                  size: 100,
                  color: Colors.orange,
                ),
                SizedBox(height: 20),
                Text(
                  'Clima en República Dominicana',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  _weatherInfo,
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _fetchWeather, 
                  child: Text('Refrescar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class Page5 extends StatefulWidget {
  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  String _logoUrl = 'assets/bon.png'; // Ruta a la imagen local
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final String apiUrl = 'https://heladosbon.com/wp-json/wp/v2/posts';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        _posts = json.decode(response.body);
      });
    } else {
      // Manejar error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias de WordPress'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              _logoUrl,
              height: 100, // Ajusta el tamaño según lo necesites
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length > 3 ? 3 : _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return ListTile(
                    title: Text(post['title']['rendered']),
                    subtitle: Text(post['excerpt']['rendered']),
                    onTap: () {
                      // Aquí puedes agregar la lógica para abrir la noticia original
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Page6 extends StatelessWidget {
  final String name = "Maikin Alejandro";
  final String lastName = "Custodio Garcia";
  final String email = "maikin3500@gmail.com";
  final String phone = "849-912-1550";
  final String imageUrl = "assets/imagen_team.jpg"; // Reemplaza con la URL de tu foto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacto'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(imageUrl), // Cambiar a AssetImage
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Nombre: $name',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Apellidos: $lastName',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Gmail: $email',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Teléfono: $phone',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}